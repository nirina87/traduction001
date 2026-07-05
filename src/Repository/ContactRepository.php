<?php

namespace App\Repository;

use App\Entity\Contact;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

class ContactRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Contact::class);
    }

    /**
     * @return Contact[]
     */
    public function findLatest(int $limit = 10): array
    {
        return $this->createQueryBuilder('c')
            ->orderBy('c.createdAt', 'DESC')
            ->setMaxResults($limit)
            ->getQuery()
            ->getResult();
    }

    /**
     * @return array{total: int, thisWeek: int, thisMonth: int, withPhone: int}
     */
    public function getIndexStats(): array
    {
        $now = new \DateTimeImmutable();
        $weekStart = $now->modify('monday this week')->setTime(0, 0, 0);
        $monthStart = $now->modify('first day of this month')->setTime(0, 0, 0);

        return [
            'total' => (int) $this->createQueryBuilder('c')
                ->select('COUNT(c.id)')
                ->getQuery()
                ->getSingleScalarResult(),
            'thisWeek' => (int) $this->createQueryBuilder('c')
                ->select('COUNT(c.id)')
                ->andWhere('c.createdAt >= :weekStart')
                ->setParameter('weekStart', $weekStart)
                ->getQuery()
                ->getSingleScalarResult(),
            'thisMonth' => (int) $this->createQueryBuilder('c')
                ->select('COUNT(c.id)')
                ->andWhere('c.createdAt >= :monthStart')
                ->setParameter('monthStart', $monthStart)
                ->getQuery()
                ->getSingleScalarResult(),
            'withPhone' => (int) $this->createQueryBuilder('c')
                ->select('COUNT(c.id)')
                ->andWhere('c.telephone IS NOT NULL')
                ->andWhere("c.telephone != ''")
                ->getQuery()
                ->getSingleScalarResult(),
        ];
    }
}