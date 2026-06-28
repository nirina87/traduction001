<?php

namespace App\Entity;

use App\Repository\TranslationRateRepository;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: TranslationRateRepository::class)]
#[ORM\Table(name: 'translation_rate')]
class TranslationRate
{
    private const PAIR_SEPARATOR = ' vers ';
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(targetEntity: Document::class, inversedBy: 'translationRates')]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private ?Document $document = null;

    #[ORM\Column(name: 'language_origine', length: 80)]
    private ?string $languageOrigine = null;

    #[ORM\Column(name: 'language_cible', length: 80)]
    private ?string $languageCible = null;

    #[ORM\Column(nullable: false)]
    private int $price = 0;

    #[ORM\Column(options: ['default' => true])]
    private bool $active = true;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getDocument(): ?Document
    {
        return $this->document;
    }

    public function setDocument(?Document $document): static
    {
        $this->document = $document;

        return $this;
    }

    public function getLanguageOrigine(): ?string
    {
        return $this->languageOrigine;
    }

    public function setLanguageOrigine(string $languageOrigine): static
    {
        $this->languageOrigine = $languageOrigine;

        return $this;
    }

    public function getLanguageCible(): ?string
    {
        return $this->languageCible;
    }

    public function setLanguageCible(string $languageCible): static
    {
        $this->languageCible = $languageCible;

        return $this;
    }

    public function getLanguagePair(): string
    {
        return self::formatLanguagePair(
            $this->languageOrigine ?? '',
            $this->languageCible ?? '',
        );
    }

    public static function formatLanguagePair(string $source, string $target): string
    {
        return $source . self::PAIR_SEPARATOR . $target;
    }

    /**
     * @return array{source: string, target: string}|null
     */
    public static function parseLanguagePair(string $pair): ?array
    {
        $parts = explode(self::PAIR_SEPARATOR, $pair, 2);
        if (2 !== \count($parts)) {
            return null;
        }

        $source = trim($parts[0]);
        $target = trim($parts[1]);
        if ('' === $source || '' === $target) {
            return null;
        }

        return [
            'source' => $source,
            'target' => $target,
        ];
    }

    public function getPrice(): int
    {
        return $this->price;
    }

    public function setPrice(int $price): static
    {
        $this->price = $price;

        return $this;
    }

    public function isActive(): bool
    {
        return $this->active;
    }

    public function setActive(bool $active): static
    {
        $this->active = $active;

        return $this;
    }

    public function __toString(): string
    {
        $pair = ($this->languageOrigine && $this->languageCible)
            ? $this->getLanguagePair()
            : 'Paire de langues';

        return sprintf('%s (%s)', $pair, $this->price ? $this->price . ' €' : 'prix libre');
    }
}
