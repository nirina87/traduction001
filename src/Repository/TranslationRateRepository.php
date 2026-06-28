<?php

namespace App\Repository;

use App\Entity\Document;
use App\Entity\TranslationRate;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

class TranslationRateRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, TranslationRate::class);
    }

    /**
     * @return list<TranslationRate>
     */
    public function findActiveByDocument(Document $document): array
    {
        return $this->findBy(
            ['document' => $document, 'active' => true],
            ['languageOrigine' => 'ASC', 'languageCible' => 'ASC'],
        );
    }

    /**
     * @return array<string, list<string>>
     */
    public function buildPairsGroupedBySourceForDocument(Document $document): array
    {
        $grouped = [];

        foreach ($this->findActiveByDocument($document) as $rate) {
            $source = $rate->getLanguageOrigine();
            if (null === $source || '' === $source) {
                continue;
            }

            $grouped[$source][] = $rate->getLanguagePair();
        }

        return $grouped;
    }

    /**
     * @return array<string, list<string>>
     */
    public function buildPairsGroupedBySource(): array
    {
        $grouped = [];

        foreach ($this->findBy(['active' => true], ['languageOrigine' => 'ASC', 'languageCible' => 'ASC']) as $rate) {
            $source = $rate->getLanguageOrigine();
            if (null === $source || '' === $source) {
                continue;
            }

            $pair = $rate->getLanguagePair();
            if (!\in_array($pair, $grouped[$source] ?? [], true)) {
                $grouped[$source][] = $pair;
            }
        }

        return $grouped;
    }

    public function findActiveForDocumentAndPair(Document $document, string $languagePair): ?TranslationRate
    {
        $parsed = TranslationRate::parseLanguagePair($languagePair);
        if (null === $parsed) {
            return null;
        }

        return $this->findOneBy([
            'document' => $document,
            'languageOrigine' => $parsed['source'],
            'languageCible' => $parsed['target'],
            'active' => true,
        ]);
    }
}
