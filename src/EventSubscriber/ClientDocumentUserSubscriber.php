<?php

namespace App\EventSubscriber;

use App\Entity\User;
use App\Service\ClientDocumentOwnerService;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\Security\Http\Event\LoginSuccessEvent;

class ClientDocumentUserSubscriber implements EventSubscriberInterface
{
    public function __construct(
        private readonly ClientDocumentOwnerService $clientDocumentOwnerService,
    ) {}

    public static function getSubscribedEvents(): array
    {
        return [
            LoginSuccessEvent::class => 'onLoginSuccess',
        ];
    }

    public function onLoginSuccess(LoginSuccessEvent $event): void
    {
        if ('main' !== $event->getFirewallName()) {
            return;
        }

        $user = $event->getUser();
        if (!$user instanceof User) {
            return;
        }

        $this->clientDocumentOwnerService->attachPendingDocumentsToUser($user);
    }
}
