<?php

namespace App\Entity;

use App\Repository\ClientDocumentRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\HttpFoundation\File\File;
use Vich\UploaderBundle\Mapping\Annotation as Vich;

#[ORM\Entity(repositoryClass: ClientDocumentRepository::class)]
#[ORM\Table(name: 'client_document')]
#[Vich\Uploadable]
class ClientDocument
{
    public const PAPER_DELIVERY_SURCHARGE_CENTS = 1500;

    public const STATUS_UNPAID = 'unpaid';
    public const STATUS_PAID = 'paid';
    public const STATUS_IN_TRANSLATION = 'in_translation';
    public const STATUS_TRANSLATION_COMPLETED = 'translation_completed';
    public const STATUS_DELIVERED = 'delivered';

    public const STATUSES = [
        self::STATUS_UNPAID,
        self::STATUS_PAID,
        self::STATUS_IN_TRANSLATION,
        self::STATUS_TRANSLATION_COMPLETED,
        self::STATUS_DELIVERED,
    ];

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

    #[ORM\ManyToOne(targetEntity: Order::class)]
    #[ORM\JoinColumn(nullable: true, onDelete: 'SET NULL')]
    private ?Order $order = null;

    #[ORM\Column(length: 150)]
    private ?string $title = null;

    #[ORM\Column(length: 100, nullable: true)]
    private ?string $language = null;

    #[ORM\Column(nullable: true)]
    private ?int $price = 0;

    #[ORM\Column(options: ['default' => 1])]
    private int $pageCount = 1;

    #[ORM\Column(options: ['default' => false])]
    private bool $receiveByPaper = false;

    #[ORM\Column(length: 30, options: ['default' => 'unpaid'])]
    private string $status = self::STATUS_UNPAID;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $fileName = null;

    #[ORM\Column(name: 'document_traduit', length: 255, nullable: true)]
    private ?string $documentTraduit = null;

    #[ORM\Column(type: Types::DATETIME_IMMUTABLE, nullable: true)]
    private ?\DateTimeImmutable $uploadedAt = null;

    #[Vich\UploadableField(mapping: 'client_documents', fileNameProperty: 'fileName')]
    private ?File $file = null;

    #[Vich\UploadableField(mapping: 'client_translated_documents', fileNameProperty: 'documentTraduit')]
    private ?File $translatedDocumentFile = null;

    /** @var Collection<int, ClientDocumentPaymentLink> */
    #[ORM\OneToMany(mappedBy: 'clientDocument', targetEntity: ClientDocumentPaymentLink::class, cascade: ['persist'])]
    #[ORM\OrderBy(['createdAt' => 'DESC'])]
    private Collection $paymentLinks;

    public function __construct()
    {
        $this->uploadedAt = new \DateTimeImmutable();
        $this->paymentLinks = new ArrayCollection();
    }

    public function getId(): ?int { return $this->id; }
    public function getUser(): ?User { return $this->user; }
    public function setUser(?User $user): static { $this->user = $user; return $this; }
    public function getDocument(): ?Document { return $this->document; }
    public function setDocument(?Document $document): static { $this->document = $document; return $this; }
    public function getOrder(): ?Order { return $this->order; }
    public function setOrder(?Order $order): static { $this->order = $order; return $this; }

    public function getPaymentStatus(): string
    {
        if (null === $this->order) {
            return 'none';
        }

        return 'paid' === $this->order->getStatus() ? 'paid' : 'pending';
    }

    public function getPaymentStatusLabel(): string
    {
        return match ($this->getPaymentStatus()) {
            'paid' => 'Payé',
            'pending' => 'Paiement en attente',
            default => 'Non rattaché',
        };
    }

    public function getStatus(): string
    {
        return $this->status;
    }

    public function setStatus(string $status): static
    {
        if (!\in_array($status, self::STATUSES, true)) {
            throw new \InvalidArgumentException(sprintf('Statut invalide : %s', $status));
        }

        $this->status = $status;

        return $this;
    }

    public function getWorkflowStatus(): string
    {
        if ('paid' !== $this->getPaymentStatus()) {
            return self::STATUS_UNPAID;
        }

        if (\in_array($this->status, [self::STATUS_IN_TRANSLATION, self::STATUS_TRANSLATION_COMPLETED, self::STATUS_DELIVERED], true)) {
            return $this->status;
        }

        return self::STATUS_PAID;
    }

    public function getWorkflowStatusLabel(): string
    {
        return match ($this->getWorkflowStatus()) {
            self::STATUS_PAID => 'Payé',
            self::STATUS_IN_TRANSLATION => 'En traduction',
            self::STATUS_TRANSLATION_COMPLETED => 'Traduction terminée',
            self::STATUS_DELIVERED => 'Livré',
            default => 'Non-payé',
        };
    }

    public function getWorkflowStatusPillClass(): string
    {
        return match ($this->getWorkflowStatus()) {
            self::STATUS_PAID => 'pill-paid',
            self::STATUS_IN_TRANSLATION => 'pill-progress',
            self::STATUS_TRANSLATION_COMPLETED => 'pill-completed',
            self::STATUS_DELIVERED => 'pill-signed',
            default => 'pill-unpaid',
        };
    }

    public static function getStatusChoices(): array
    {
        return [
            'Non-payé' => self::STATUS_UNPAID,
            'Payé' => self::STATUS_PAID,
            'En traduction' => self::STATUS_IN_TRANSLATION,
            'Traduction terminée' => self::STATUS_TRANSLATION_COMPLETED,
            'Livré' => self::STATUS_DELIVERED,
        ];
    }

    public function getTitle(): ?string { return $this->title; }
    public function setTitle(string $title): static { $this->title = $title; return $this; }
    public function getLanguage(): ?string { return $this->language; }
    public function setLanguage(?string $language): static { $this->language = $language; return $this; }
    public function getPrice(): ?int { return $this->price; }
    public function setPrice(?int $price): static { $this->price = $price; return $this; }
    public function getPageCount(): int { return $this->pageCount; }
    public function setPageCount(int $pageCount): static { $this->pageCount = $pageCount; return $this; }
    public function isReceiveByPaper(): bool { return $this->receiveByPaper; }
    public function setReceiveByPaper(bool $receiveByPaper): static { $this->receiveByPaper = $receiveByPaper; return $this; }
    public function getReceiveByPaperLabel(): string
    {
        return $this->receiveByPaper ? 'Par courrier' : 'Numérique';
    }
    public function getFileName(): ?string { return $this->fileName; }
    public function setFileName(?string $fileName): static { $this->fileName = $fileName; return $this; }
    public function getUploadedAt(): ?\DateTimeImmutable { return $this->uploadedAt; }
    public function setUploadedAt(?\DateTimeImmutable $uploadedAt): static { $this->uploadedAt = $uploadedAt; return $this; }
    public function getFile(): ?File { return $this->file; }
    public function setFile(?File $file = null): void { $this->file = $file; if (null !== $file) { $this->uploadedAt = new \DateTimeImmutable(); } }
    public function getDocumentTraduit(): ?string { return $this->documentTraduit; }
    public function setDocumentTraduit(?string $documentTraduit): static { $this->documentTraduit = $documentTraduit; return $this; }
    public function getTranslatedDocumentFile(): ?File { return $this->translatedDocumentFile; }
    public function setTranslatedDocumentFile(?File $file = null): void
    {
        $this->translatedDocumentFile = $file;
        if (null !== $file) {
            $this->status = self::STATUS_TRANSLATION_COMPLETED;
            $this->uploadedAt = new \DateTimeImmutable();
        }
    }

    public function getFileUrl(): ?string
    {
        if (null === $this->fileName || '' === $this->fileName) {
            return null;
        }

        return '/uploads/client-documents/' . $this->fileName;
    }

    public function getDocumentTraduitUrl(): ?string
    {
        if (null === $this->documentTraduit || '' === $this->documentTraduit) {
            return null;
        }

        return '/uploads/client-translated-documents/' . $this->documentTraduit;
    }

    /**
     * @return Collection<int, ClientDocumentPaymentLink>
     */
    public function getPaymentLinks(): Collection
    {
        return $this->paymentLinks;
    }

    public function addPaymentLink(ClientDocumentPaymentLink $paymentLink): static
    {
        if (!$this->paymentLinks->contains($paymentLink)) {
            $this->paymentLinks->add($paymentLink);
            $paymentLink->setClientDocument($this);
        }

        return $this;
    }

    public function __toString(): string
    {
        return $this->title ?? 'Document client';
    }
}
