<?php

namespace App\Entity;

use App\Repository\DocumentRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
#[ORM\Entity(repositoryClass: DocumentRepository::class)]
#[ORM\Table(name: 'document')]
class Document
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 150)]
    private ?string $name = null;

    #[ORM\Column(type: Types::TEXT, nullable: true)]
    private ?string $description = null;

    #[ORM\Column(length: 80, nullable: true)]
    private ?string $category = null;

    #[ORM\Column(nullable: true)]
    private ?int $basePrice = 0;

    #[ORM\Column(options: ['default' => true])]
    private bool $active = true;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $image = null;

    #[ORM\OneToMany(mappedBy: 'document', targetEntity: TranslationRate::class, cascade: ['persist', 'remove'])]
    private Collection $translationRates;

    public function __construct()
    {
        $this->translationRates = new ArrayCollection();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getName(): ?string
    {
        return $this->name;
    }

    public function setName(string $name): static
    {
        $this->name = $name;

        return $this;
    }

    public function getDescription(): ?string
    {
        return $this->description;
    }

    public function setDescription(?string $description): static
    {
        $this->description = $description;

        return $this;
    }

    public function getCategory(): ?string
    {
        return $this->category;
    }

    public function setCategory(?string $category): static
    {
        $this->category = $category;

        return $this;
    }

    public function getBasePrice(): ?int
    {
        return $this->basePrice;
    }

    public function setBasePrice(?int $basePrice): static
    {
        $this->basePrice = $basePrice;

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

    /**
     * @return Collection<int, TranslationRate>
     */
    public function getTranslationRates(): Collection
    {
        return $this->translationRates;
    }

    public function addTranslationRate(TranslationRate $translationRate): static
    {
        if (!$this->translationRates->contains($translationRate)) {
            $this->translationRates->add($translationRate);
            $translationRate->setDocument($this);
        }

        return $this;
    }

    public function removeTranslationRate(TranslationRate $translationRate): static
    {
        if ($this->translationRates->removeElement($translationRate)) {
            if ($translationRate->getDocument() === $this) {
                $translationRate->setDocument(null);
            }
        }

        return $this;
    }

    public function __toString(): string
    {
        return $this->name ?? 'Document';
    }

    public function getImage(): ?string
    {
        return $this->image;
    }

    public function setImage(?string $image): static
    {
        $this->image = $image;
        return $this;
    }
}
