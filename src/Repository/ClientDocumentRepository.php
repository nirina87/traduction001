<?php

namespace App\Repository;

use App\Entity\ClientDocument;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

class ClientDocumentRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, ClientDocument::class);
    }

    /**
     * @return ClientDocument[]
     */
    public function findRecentWithOrder(int $limit = 5): array
    {
        return $this->createQueryBuilder('cd')
            ->leftJoin('cd.order', 'o')
            ->addSelect('o')
            ->orderBy('cd.uploadedAt', 'DESC')
            ->setMaxResults($limit)
            ->getQuery()
            ->getResult();
    }

    /**
     * @return array{total: int, unpaid: int, inProgress: int, delivered: int}
     */
    public function getIndexStats(): array
    {
        return [
            'total' => (int) $this->createQueryBuilder('cd')
                ->select('COUNT(cd.id)')
                ->getQuery()
                ->getSingleScalarResult(),
            'unpaid' => (int) $this->createQueryBuilder('cd')
                ->select('COUNT(cd.id)')
                ->andWhere('cd.status = :status')
                ->setParameter('status', ClientDocument::STATUS_UNPAID)
                ->getQuery()
                ->getSingleScalarResult(),
            'inProgress' => (int) $this->createQueryBuilder('cd')
                ->select('COUNT(cd.id)')
                ->andWhere('cd.status IN (:statuses)')
                ->setParameter('statuses', [ClientDocument::STATUS_IN_TRANSLATION, ClientDocument::STATUS_TRANSLATION_COMPLETED])
                ->getQuery()
                ->getSingleScalarResult(),
            'delivered' => (int) $this->createQueryBuilder('cd')
                ->select('COUNT(cd.id)')
                ->andWhere('cd.status = :status')
                ->setParameter('status', ClientDocument::STATUS_DELIVERED)
                ->getQuery()
                ->getSingleScalarResult(),
        ];
    }
}
