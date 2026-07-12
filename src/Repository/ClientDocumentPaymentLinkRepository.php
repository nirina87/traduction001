<?php

namespace App\Repository;

use App\Entity\ClientDocument;
use App\Entity\ClientDocumentPaymentLink;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<ClientDocumentPaymentLink>
 */
class ClientDocumentPaymentLinkRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, ClientDocumentPaymentLink::class);
    }

    /**
     * @return ClientDocumentPaymentLink[]
     */
    public function findByClientDocumentOrdered(ClientDocument $clientDocument): array
    {
        return $this->createQueryBuilder('pl')
            ->andWhere('pl.clientDocument = :document')
            ->setParameter('document', $clientDocument)
            ->orderBy('pl.createdAt', 'DESC')
            ->getQuery()
            ->getResult();
    }

    public function findOneByStripePaymentLinkId(string $stripePaymentLinkId): ?ClientDocumentPaymentLink
    {
        return $this->findOneBy(['stripePaymentLinkId' => $stripePaymentLinkId]);
    }

    public function findOneByStripeCheckoutSessionId(string $stripeCheckoutSessionId): ?ClientDocumentPaymentLink
    {
        return $this->findOneBy(['stripeCheckoutSessionId' => $stripeCheckoutSessionId]);
    }
}
