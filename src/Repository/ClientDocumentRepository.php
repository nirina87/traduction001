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
}
