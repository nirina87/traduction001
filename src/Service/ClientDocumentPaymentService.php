<?php

namespace App\Service;

use App\Entity\ClientDocument;
use App\Entity\ClientDocumentPaymentLink;
use App\Entity\Order;
use Doctrine\ORM\EntityManagerInterface;
use Stripe\Checkout\Session;

class ClientDocumentPaymentService
{
    public function __construct(
        private readonly EntityManagerInterface $entityManager,
        private readonly MailjetService $mailjetService,
        private readonly StripePaymentLinkService $stripePaymentLinkService,
    ) {
    }

    public function isAlreadyPaid(ClientDocument $document, string $checkoutSessionId): bool
    {
        $order = $document->getOrder();
        if (null === $order) {
            return false;
        }

        return 'paid' === $order->getStatus()
            && $order->getStripeSessionId() === $checkoutSessionId;
    }

    /**
     * @return bool True when the dossier was newly marked as paid.
     */
    public function markAsPaidFromCheckoutSession(Session $session, ClientDocumentPaymentLink $paymentLink): bool
    {
        $document = $paymentLink->getClientDocument();
        if (!$document instanceof ClientDocument) {
            throw new \RuntimeException('Aucun document client associé à ce lien de paiement.');
        }

        if ($this->isAlreadyPaid($document, $session->id)) {
            return false;
        }

        if ('paid' === $document->getPaymentStatus()) {
            return false;
        }

        $wasAlreadyPaid = 'paid' === $document->getOrder()?->getStatus();

        $this->applyPaidStatus($document, $session);
        $paymentLink->setStripeCheckoutSessionId($session->id);
        $paymentLink->setPaidAt(new \DateTimeImmutable());

        $this->entityManager->flush();

        try {
            $this->stripePaymentLinkService->deactivate($paymentLink);
        } catch (\Throwable) {
            // Le paiement est validé même si la désactivation Stripe échoue.
        }

        if (!$wasAlreadyPaid && null !== $document->getOrder()) {
            $this->mailjetService->sendOrderConfirmationEmail($document->getOrder());
            $this->mailjetService->sendOrderProcessingNotification($document->getOrder());
        }

        return true;
    }

    private function applyPaidStatus(ClientDocument $document, Session $session): void
    {
        $order = $document->getOrder();
        if (null === $order) {
            $user = $document->getUser();
            if (null === $user) {
                throw new \RuntimeException('Impossible de valider le paiement : aucun client associé au dossier.');
            }

            $order = new Order();
            $order->setUser($user);
            $order->setInvoiceNumber('FACT-' . date('Ymd') . '-' . random_int(1000, 9999));
            $document->setOrder($order);
            $this->entityManager->persist($order);
        }

        if (null !== $session->amount_total) {
            $order->setTotal(number_format($session->amount_total / 100, 2, '.', ''));
        }

        $order->setCurrency(strtoupper((string) ($session->currency ?? 'EUR')));
        $order->setStatus('paid');
        $order->setStripeSessionId($session->id);

        if (ClientDocument::STATUS_UNPAID === $document->getStatus()) {
            $document->setStatus(ClientDocument::STATUS_PAID);
        }
    }
}
