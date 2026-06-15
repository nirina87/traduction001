<?php

namespace App\Entity;

use App\Repository\TranslationRateRepository;
use Doctrine\ORM\Mapping as ORM;
use App\Entity\Document;

#[ORM\Entity(repositoryClass: TranslationRateRepository::class)]
#[ORM\Table(name: 'translation_rate')]
class TranslationRate
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(targetEntity: Document::class, inversedBy: 'translationRates')]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private ?Document $document = null;

    #[ORM\Column(length: 80)]
    private ?string $language = null;

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

    public function getLanguage(): ?string
    {
        return $this->language;
    }

    public function setLanguage(string $language): static
    {
        $this->language = $language;

        return $this;
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
        return sprintf('%s (%s)', $this->language ?? 'Langue', $this->price ? $this->price . ' €' : 'prix libre');
    }
}
