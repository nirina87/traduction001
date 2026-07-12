<?php

namespace App\Entity;

use App\Repository\ClientDocumentPaymentLinkRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: ClientDocumentPaymentLinkRepository::class)]
#[ORM\Table(name: 'client_document_payment_link')]
class ClientDocumentPaymentLink
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(targetEntity: ClientDocument::class, inversedBy: 'paymentLinks')]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private ?ClientDocument $clientDocument = null;

    #[ORM\Column(length: 100)]
    private ?string $stripePriceId = null;

    #[ORM\Column(length: 100)]
    private ?string $stripePaymentLinkId = null;

    #[ORM\Column(length: 500)]
    private ?string $url = null;

    #[ORM\Column]
    private int $amountCents = 0;

    #[ORM\Column(length: 10, options: ['default' => 'EUR'])]
    private string $currency = 'EUR';

    #[ORM\Column(type: Types::DATETIME_IMMUTABLE)]
    private ?\DateTimeImmutable $createdAt = null;

    #[ORM\Column(length: 100, nullable: true)]
    private ?string $stripeCheckoutSessionId = null;

    #[ORM\Column(type: Types::DATETIME_IMMUTABLE, nullable: true)]
    private ?\DateTimeImmutable $paidAt = null;

    public function __construct()
    {
        $this->createdAt = new \DateTimeImmutable();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getClientDocument(): ?ClientDocument
    {
        return $this->clientDocument;
    }

    public function setClientDocument(?ClientDocument $clientDocument): static
    {
        $this->clientDocument = $clientDocument;

        return $this;
    }

    public function getStripePriceId(): ?string
    {
        return $this->stripePriceId;
    }

    public function setStripePriceId(string $stripePriceId): static
    {
        $this->stripePriceId = $stripePriceId;

        return $this;
    }

    public function getStripePaymentLinkId(): ?string
    {
        return $this->stripePaymentLinkId;
    }

    public function setStripePaymentLinkId(string $stripePaymentLinkId): static
    {
        $this->stripePaymentLinkId = $stripePaymentLinkId;

        return $this;
    }

    public function getUrl(): ?string
    {
        return $this->url;
    }

    public function setUrl(string $url): static
    {
        $this->url = $url;

        return $this;
    }

    public function getAmountCents(): int
    {
        return $this->amountCents;
    }

    public function setAmountCents(int $amountCents): static
    {
        $this->amountCents = $amountCents;

        return $this;
    }

    public function getCurrency(): string
    {
        return $this->currency;
    }

    public function setCurrency(string $currency): static
    {
        $this->currency = $currency;

        return $this;
    }

    public function getCreatedAt(): ?\DateTimeImmutable
    {
        return $this->createdAt;
    }

    public function getStripeCheckoutSessionId(): ?string
    {
        return $this->stripeCheckoutSessionId;
    }

    public function setStripeCheckoutSessionId(?string $stripeCheckoutSessionId): static
    {
        $this->stripeCheckoutSessionId = $stripeCheckoutSessionId;

        return $this;
    }

    public function getPaidAt(): ?\DateTimeImmutable
    {
        return $this->paidAt;
    }

    public function setPaidAt(?\DateTimeImmutable $paidAt): static
    {
        $this->paidAt = $paidAt;

        return $this;
    }

    public function isPaid(): bool
    {
        return null !== $this->paidAt;
    }
}
