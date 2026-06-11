<?php

namespace App\Service;

use Stripe\Checkout\Session;
use Stripe\Stripe;

class StripeCheckoutService
{
    public function __construct(
        private readonly string $stripeSecretKey,
    ) {
    }

    public function createCheckoutSession(
        array $lineItems,
        string $customerEmail,
        string $successUrl,
        string $cancelUrl,
        string $userId,
    ): Session {
        $this->configureApiKey();

        return Session::create([
            'mode' => 'payment',
            'customer_email' => $customerEmail,
            'line_items' => $lineItems,
            'success_url' => $successUrl,
            'cancel_url' => $cancelUrl,
            'metadata' => [
                'user_id' => $userId,
            ],
        ]);
    }

    public function retrieveCheckoutSession(string $sessionId): Session
    {
        $this->configureApiKey();

        return Session::retrieve($sessionId);
    }

    private function configureApiKey(): void
    {
        if ('' === $this->stripeSecretKey) {
            throw new \RuntimeException('La clé secrète Stripe (STRIPE_SECRET_KEY) n’est pas configurée.');
        }

        Stripe::setApiKey($this->stripeSecretKey);
    }
}
