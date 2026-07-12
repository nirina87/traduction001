<?php

namespace App\Controller;

use App\Service\StripeWebhookService;
use Stripe\Exception\SignatureVerificationException;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class StripeWebhookController extends AbstractController
{
    #[Route('/webhook/stripe', name: 'stripe_webhook', methods: ['POST'], priority: 10)]
    public function __invoke(Request $request, StripeWebhookService $stripeWebhookService): Response
    {
        try {
            $stripeWebhookService->handle(
                $request->getContent(),
                $request->headers->get('Stripe-Signature'),
            );
        } catch (SignatureVerificationException) {
            return new Response('Invalid signature.', Response::HTTP_BAD_REQUEST);
        } catch (\RuntimeException $exception) {
            return new Response($exception->getMessage(), Response::HTTP_BAD_REQUEST);
        } catch (\Throwable) {
            return new Response('Webhook processing failed.', Response::HTTP_INTERNAL_SERVER_ERROR);
        }

        return new Response('Webhook handled.', Response::HTTP_OK);
    }
}
