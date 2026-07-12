<?php

namespace App\Service;

use App\Entity\ClientDocument;
use App\Entity\ClientDocumentPaymentLink;
use Stripe\PaymentLink;
use Stripe\Price;
use Stripe\Stripe;

class StripePaymentLinkService
{
    public function __construct(
        private readonly string $stripeSecretKey,
    ) {
    }

    public function createForClientDocument(ClientDocument $document): ClientDocumentPaymentLink
    {
        $amountCents = $this->resolveAmountCents($document);
        if ($amountCents <= 0) {
            throw new \RuntimeException('Impossible de créer un lien de paiement : le montant estimé est invalide.');
        }

        $this->configureApiKey();

        $price = Price::create([
            'currency' => 'EUR',
            'unit_amount' => $amountCents,
            'product_data' => [
                'name' => $this->buildProductName($document),
            ],
        ]);

        $paymentLink = PaymentLink::create([
            'line_items' => [
                [
                    'price' => $price->id,
                    'quantity' => 1,
                ],
            ],
        ]);

        if (null === $paymentLink->url || '' === $paymentLink->url) {
            throw new \RuntimeException('Stripe n\'a pas renvoyé d\'URL de paiement.');
        }

        $entity = new ClientDocumentPaymentLink();
        $entity->setClientDocument($document);
        $entity->setStripePriceId($price->id);
        $entity->setStripePaymentLinkId($paymentLink->id);
        $entity->setUrl($paymentLink->url);
        $entity->setAmountCents($amountCents);
        $entity->setCurrency('EUR');

        return $entity;
    }

    public function deactivate(ClientDocumentPaymentLink $paymentLink): void
    {
        $stripePaymentLinkId = $paymentLink->getStripePaymentLinkId();
        if (null === $stripePaymentLinkId || '' === $stripePaymentLinkId) {
            throw new \RuntimeException('Identifiant Stripe du lien de paiement manquant.');
        }

        $this->configureApiKey();

        PaymentLink::update($stripePaymentLinkId, [
            'active' => false,
        ]);
    }

    private function resolveAmountCents(ClientDocument $document): int
    {
        $amountCents = $document->getPrice() ?? 0;
        if ($document->isReceiveByPaper()) {
            $amountCents += ClientDocument::PAPER_DELIVERY_SURCHARGE_CENTS;
        }

        return $amountCents;
    }

    private function buildProductName(ClientDocument $document): string
    {
        return sprintf(
            'Traduction %s %s | %s | %s',
            $document->getDocument()?->getName() ?? 'Document',
            $document->getLanguage() ?? '—',
            $document->getUser()?->getEmail() ?? '—',
            $document->getId() ?? '—',
        );
    }

    private function configureApiKey(): void
    {
        if ('' === $this->stripeSecretKey) {
            throw new \RuntimeException('La clé secrète Stripe (STRIPE_SECRET_KEY) n’est pas configurée.');
        }

        Stripe::setApiKey($this->stripeSecretKey);
    }
}
