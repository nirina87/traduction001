<?php

namespace App\Service;

use App\Repository\ClientDocumentPaymentLinkRepository;
use App\Repository\ClientDocumentRepository;
use Psr\Log\LoggerInterface;
use Stripe\Checkout\Session;
use Stripe\Event;
use Stripe\Exception\SignatureVerificationException;
use Stripe\Stripe;
use Stripe\Webhook;

class StripeWebhookService
{
    public function __construct(
        private readonly string $stripeSecretKey,
        private readonly string $stripeWebhookSecret,
        private readonly ClientDocumentPaymentLinkRepository $paymentLinkRepository,
        private readonly ClientDocumentRepository $clientDocumentRepository,
        private readonly ClientDocumentPaymentService $clientDocumentPaymentService,
        private readonly LoggerInterface $logger,
    ) {
    }

    public function handle(string $payload, ?string $signatureHeader): void
    {
        if ('' === $this->stripeWebhookSecret) {
            throw new \RuntimeException('La clé secrète du webhook Stripe (STRIPE_WEBHOOK_SECRET) n’est pas configurée.');
        }

        if (null === $signatureHeader || '' === $signatureHeader) {
            throw new SignatureVerificationException('En-tête Stripe-Signature manquant.', $signatureHeader);
        }

        $this->configureApiKey();

        try {
            $event = Webhook::constructEvent($payload, $signatureHeader, $this->stripeWebhookSecret);
        } catch (SignatureVerificationException $exception) {
            $this->logger->warning('Signature Stripe webhook invalide.', [
                'message' => $exception->getMessage(),
            ]);

            throw $exception;
        }

        $this->dispatchEvent($event);
    }

    private function dispatchEvent(Event $event): void
    {
        if ('checkout.session.completed' !== $event->type) {
            return;
        }

        $session = $event->data->object;
        if (!$session instanceof Session) {
            $this->logger->warning('Événement checkout.session.completed sans objet Session.', [
                'event_id' => $event->id,
            ]);

            return;
        }

        $this->handleCheckoutSessionCompleted($session, $event->id);
    }

    private function handleCheckoutSessionCompleted(Session $session, string $eventId): void
    {
        if ('payment' !== $session->mode || 'paid' !== $session->payment_status) {
            return;
        }

        $paymentLink = $this->resolvePaymentLink($session);
        if (null === $paymentLink) {
            return;
        }

        $document = $paymentLink->getClientDocument();
        if (null === $document) {
            $this->logger->error('Lien de paiement Stripe sans document client associé.', [
                'event_id' => $eventId,
                'checkout_session_id' => $session->id,
                'payment_link_id' => $session->payment_link,
            ]);

            return;
        }

        if ($this->clientDocumentPaymentService->isAlreadyPaid($document, $session->id)) {
            $this->logger->info('Webhook Stripe ignoré : session déjà traitée.', [
                'event_id' => $eventId,
                'checkout_session_id' => $session->id,
                'client_document_id' => $document->getId(),
            ]);

            return;
        }

        $newlyPaid = $this->clientDocumentPaymentService->markAsPaidFromCheckoutSession($session, $paymentLink);

        $this->logger->info($newlyPaid
            ? 'Paiement lien de paiement validé via webhook Stripe.'
            : 'Webhook Stripe reçu mais dossier déjà payé.',
            [
                'event_id' => $eventId,
                'checkout_session_id' => $session->id,
                'client_document_id' => $document->getId(),
                'payment_link_id' => $paymentLink->getId(),
            ]);
    }

    private function resolvePaymentLink(Session $session): ?\App\Entity\ClientDocumentPaymentLink
    {
        $existingBySession = $this->paymentLinkRepository->findOneByStripeCheckoutSessionId($session->id);
        if (null !== $existingBySession) {
            return $existingBySession;
        }

        $paymentLinkId = $session->payment_link;
        if (is_string($paymentLinkId) && '' !== $paymentLinkId) {
            $paymentLink = $this->paymentLinkRepository->findOneByStripePaymentLinkId($paymentLinkId);
            if (null !== $paymentLink) {
                return $paymentLink;
            }
        }

        $metadata = $this->normalizeMetadata($session->metadata ?? null);
        if (($metadata['source'] ?? '') !== 'client_document_payment_link') {
            return null;
        }

        $clientDocumentId = (int) ($metadata['client_document_id'] ?? 0);
        if ($clientDocumentId <= 0) {
            return null;
        }

        $document = $this->clientDocumentRepository->find($clientDocumentId);
        if (null === $document) {
            return null;
        }

        $paymentLinks = $this->paymentLinkRepository->findByClientDocumentOrdered($document);

        return $paymentLinks[0] ?? null;
    }

    /**
     * @return array<string, string>
     */
    private function normalizeMetadata(mixed $metadata): array
    {
        if (!\is_object($metadata) && !\is_array($metadata)) {
            return [];
        }

        $normalized = [];
        foreach ($metadata as $key => $value) {
            if (\is_string($key)) {
                $normalized[$key] = (string) $value;
            }
        }

        return $normalized;
    }

    private function configureApiKey(): void
    {
        if ('' === $this->stripeSecretKey) {
            throw new \RuntimeException('La clé secrète Stripe (STRIPE_SECRET_KEY) n’est pas configurée.');
        }

        Stripe::setApiKey($this->stripeSecretKey);
    }
}
