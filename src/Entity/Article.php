<?php

namespace App\Entity;

use App\Repository\ArticleRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\String\Slugger\SluggerInterface;
use Vich\UploaderBundle\Mapping\Annotation as Vich;
use Symfony\Component\HttpFoundation\File\File;

#[ORM\Entity(repositoryClass: ArticleRepository::class)]
#[Vich\Uploadable]

class Article
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(inversedBy: 'articles')]
    private ?Category $category = null;

    #[ORM\Column(type: Types::TEXT, nullable: true)]
    private ?string $title = null;

    #[ORM\Column(length: 255, unique: true)]
    private ?string $slug = null;

    #[ORM\Column(type: Types::DATE_MUTABLE, nullable: true)]
    private ?\DateTime $creation = null;

    #[ORM\Column(type: Types::TEXT, nullable: true)]
    private ?string $metacription = null;

    #[ORM\Column(type: Types::TEXT, nullable: true)]
    private ?string $words = null;

    #[ORM\Column(type: Types::TEXT, nullable: true)]
    private ?string $content1 = null;

    #[ORM\Column(type: Types::TEXT, nullable: true)]
    private ?string $content2 = null;

    #[ORM\Column(type: Types::TEXT, nullable: true)]
    private ?string $images = null;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getTitle(): ?string
    {
        return $this->title;
    }

    public function setTitle(?string $title): static
    {
        $this->title = $title;

        return $this;
    }

    public function getSlug(): ?string
    {
        return $this->slug;
    }

    public function setSlug(string $slug): static
    {
        $this->slug = $slug;
        return $this;
    }

    public function getCreation(): ?\DateTime
    {
        return $this->creation;
    }

    public function setCreation(?\DateTime $creation): static
    {
        $this->creation = $creation;

        return $this;
    }

    public function getMetacription(): ?string
    {
        return $this->metacription;
    }

    public function setMetacription(?string $metacription): static
    {
        $this->metacription = $metacription;

        return $this;
    }

    public function getWords(): ?string
    {
        return $this->words;
    }

    public function setWords(?string $words): static
    {
        $this->words = $words;

        return $this;
    }

    public function getContent1(): ?string
    {
        return $this->content1;
    }

    public function setContent1(?string $content1): static
    {
        $this->content1 = $content1;

        return $this;
    }

    public function getContent2(): ?string
    {
        return $this->content2;
    }

    public function setContent2(?string $content2): static
    {
        $this->content2 = $content2;

        return $this;
    }

    public function getImages(): ?string
    {
        return $this->images;
    }

    public function setImages(?string $images): static
    {
        $this->images = $images;

        return $this;
    }

    public function getCategory(): ?Category
    {
        return $this->category;
    }

    public function setCategory(?Category $category): static
    {
        $this->category = $category;

        return $this;
    }

    public function __toString(): string
    {
        return $this->title ?? 'Article';
    }
    public function generateSlug(SluggerInterface $slugger): void
    {
        if ($this->title) {
            $this->slug = strtolower($slugger->slug($this->title));
        }
    }

    #[Vich\UploadableField(mapping: 'article_images', fileNameProperty: 'bannerName')]
    private ?File $bannerFile = null;

    #[ORM\Column(nullable: true)]
    private ?string $bannerName = null;

    #[Vich\UploadableField(mapping: 'article_images', fileNameProperty: 'featuredName')]
    private ?File $featuredFile = null;

    #[ORM\Column(nullable: true)]
    private ?string $featuredName = null;

    #[ORM\Column(nullable: true)]
    private ?\DateTimeImmutable $updatedAt = null;

    // ===== BANNIERE =====
    public function setBannerFile(?File $file = null): void
    {
        $this->bannerFile = $file;

        if ($file) {
            $this->updatedAt = new \DateTimeImmutable();
        }
    }

    public function getBannerFile(): ?File
    {
        return $this->bannerFile;
    }

    public function getBannerName(): ?string
    {
        return $this->bannerName;
    }

    public function setBannerName(?string $bannerName): void
    {
        $this->bannerName = $bannerName;
    }

    // ===== IMAGE MISE EN AVANT =====
    public function setFeaturedFile(?File $file = null): void
    {
        $this->featuredFile = $file;

        if ($file) {
            $this->updatedAt = new \DateTimeImmutable();
        }
    }

    public function getFeaturedFile(): ?File
    {
        return $this->featuredFile;
    }

    public function getFeaturedName(): ?string
    {
        return $this->featuredName;
    }

    public function setFeaturedName(?string $featuredName): void
    {
        $this->featuredName = $featuredName;
    }
}
