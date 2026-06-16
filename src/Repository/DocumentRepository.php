<?php

namespace App\Repository;

use App\Entity\Document;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

class DocumentRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Document::class);
    }

    /**
     * @return array<int, array{title: string, description: ?string, image: string, price: int}>
     */
    public function buildCatalog(): array
    {
        $catalog = [];

        foreach ($this->findBy(['active' => true], ['id' => 'ASC']) as $document) {
            $id = $document->getId();
            if (null === $id) {
                continue;
            }

            $catalog[$id] = [
                'title' => (string) $document->getName(),
                'description' => $document->getDescription(),
                'image' => $document->getImage()
                    ? 'uploads/' . $document->getImage()
                    : 'img/logos/logo-1.png',
                // basePrice is stored in euros for Document; convert to cents for cart/Stripe.
                'price' => ((int) ($document->getBasePrice() ?? 0)) * 100,
            ];
        }

        return $catalog;
    }
}
