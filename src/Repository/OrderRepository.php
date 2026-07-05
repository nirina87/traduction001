<?php

namespace App\Repository;

use App\Entity\Order;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Order>
 */
class OrderRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Order::class);
    }

    public function sumPaidTotalBetween(\DateTimeImmutable $start, \DateTimeImmutable $end): float
    {
        $result = $this->createQueryBuilder('o')
            ->select('COALESCE(SUM(o.total), 0)')
            ->where('o.status = :status')
            ->andWhere('o.createdAt >= :start')
            ->andWhere('o.createdAt < :end')
            ->setParameter('status', 'paid')
            ->setParameter('start', $start)
            ->setParameter('end', $end)
            ->getQuery()
            ->getSingleScalarResult();

        return (float) $result;
    }

    public function countPaidBetween(\DateTimeImmutable $start, \DateTimeImmutable $end): int
    {
        return (int) $this->createQueryBuilder('o')
            ->select('COUNT(o.id)')
            ->where('o.status = :status')
            ->andWhere('o.createdAt >= :start')
            ->andWhere('o.createdAt < :end')
            ->setParameter('status', 'paid')
            ->setParameter('start', $start)
            ->setParameter('end', $end)
            ->getQuery()
            ->getSingleScalarResult();
    }
}
