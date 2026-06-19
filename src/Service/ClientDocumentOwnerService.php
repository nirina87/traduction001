<?php

namespace App\Service;

use App\Entity\ClientDocument;
use App\Entity\User;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\RequestStack;

class ClientDocumentOwnerService
{
    public const SESSION_PENDING_IDS = 'pending_client_document_ids';

    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly RequestStack $requestStack,
    ) {}

    public function registerPendingDocumentId(int $clientDocumentId): void
    {
        if ($clientDocumentId <= 0) {
            return;
        }

        $session = $this->requestStack->getSession();
        $pendingIds = $session->get(self::SESSION_PENDING_IDS, []);
        $pendingIds[] = $clientDocumentId;
        $session->set(self::SESSION_PENDING_IDS, array_values(array_unique($pendingIds)));
    }

    public function attachPendingDocumentsToUser(User $user): int
    {
        $session = $this->requestStack->getSession();
        $pendingIds = array_values(array_unique(array_map('intval', $session->get(self::SESSION_PENDING_IDS, []))));

        if ([] === $pendingIds) {
            return 0;
        }

        $attachedIds = [];

        foreach ($pendingIds as $clientDocumentId) {
            if ($clientDocumentId <= 0) {
                continue;
            }

            $clientDocument = $this->em->getRepository(ClientDocument::class)->find($clientDocumentId);
            if (!$clientDocument || null !== $clientDocument->getUser()) {
                continue;
            }

            $clientDocument->setUser($user);
            $attachedIds[] = $clientDocumentId;
        }

        if ([] !== $attachedIds) {
            $this->em->flush();
            $session->set(
                self::SESSION_PENDING_IDS,
                array_values(array_diff($pendingIds, $attachedIds)),
            );
        }

        return \count($attachedIds);
    }
}
