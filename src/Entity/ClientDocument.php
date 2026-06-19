<?php

namespace App\Entity;

use App\Repository\ClientDocumentRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\HttpFoundation\File\File;
use Vich\UploaderBundle\Mapping\Annotation as Vich;

#[ORM\Entity(repositoryClass: ClientDocumentRepository::class)]
#[ORM\Table(name: 'client_document')]
#[Vich\Uploadable]
class ClientDocument
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(targetEntity: User::class)]
    #[ORM\JoinColumn(nullable: true, onDelete: 'SET NULL')]
    private ?User $user = null;

    #[ORM\ManyToOne(targetEntity: Document::class)]
    #[ORM\JoinColumn(nullable: true, onDelete: 'SET NULL')]
    private ?Document $document = null;

    #[ORM\Column(length: 150)]
    private ?string $title = null;

    #[ORM\Column(length: 100, nullable: true)]
    private ?string $language = null;

    #[ORM\Column(nullable: true)]
    private ?int $price = 0;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $fileName = null;

    #[ORM\Column(type: Types::DATETIME_IMMUTABLE, nullable: true)]
    private ?\DateTimeImmutable $uploadedAt = null;

    #[Vich\UploadableField(mapping: 'client_documents', fileNameProperty: 'fileName')]
    private ?File $file = null;

    public function __construct()
    {
        $this->uploadedAt = new \DateTimeImmutable();
    }

    public function getId(): ?int { return $this->id; }
    public function getUser(): ?User { return $this->user; }
    public function setUser(?User $user): static { $this->user = $user; return $this; }
    public function getDocument(): ?Document { return $this->document; }
    public function setDocument(?Document $document): static { $this->document = $document; return $this; }
    public function getTitle(): ?string { return $this->title; }
    public function setTitle(string $title): static { $this->title = $title; return $this; }
    public function getLanguage(): ?string { return $this->language; }
    public function setLanguage(?string $language): static { $this->language = $language; return $this; }
    public function getPrice(): ?int { return $this->price; }
    public function setPrice(?int $price): static { $this->price = $price; return $this; }
    public function getFileName(): ?string { return $this->fileName; }
    public function setFileName(?string $fileName): static { $this->fileName = $fileName; return $this; }
    public function getUploadedAt(): ?\DateTimeImmutable { return $this->uploadedAt; }
    public function setUploadedAt(?\DateTimeImmutable $uploadedAt): static { $this->uploadedAt = $uploadedAt; return $this; }
    public function getFile(): ?File { return $this->file; }
    public function setFile(?File $file = null): void { $this->file = $file; if (null !== $file) { $this->uploadedAt = new \DateTimeImmutable(); } }

    public function getFileUrl(): ?string
    {
        if (null === $this->fileName || '' === $this->fileName) {
            return null;
        }

        return '/uploads/client-documents/' . $this->fileName;
    }

    public function __toString(): string
    {
        return $this->title ?? 'Document client';
    }
}
