<?php

namespace App\Service;

use App\Entity\ClientDocument;
use App\Entity\Order;
use App\Entity\User;
use Symfony\Contracts\HttpClient\HttpClientInterface;

class MailjetService
{
    private const API_URL = 'https://api.mailjet.com/v3.1/send';
    private const SENDER_NAME = 'Traductions Légales';

    public function __construct(
        private readonly HttpClientInterface $httpClient,
        private readonly string $apiKey,
        private readonly string $apiSecret,
        private readonly int $confirmationTemplateId,
        private readonly int $credentialsTemplateId,
        private readonly int $contactTemplateId,
        private readonly int $processingTemplateId,
        private readonly int $translatedDocumentTemplateId,
        private readonly string $senderEmail,
        private readonly string $supportEmail,
        private readonly string $processingEmail,
        private readonly array $contactCcEmails,
        private readonly array $processingCcEmails,
        private readonly array $translatedDocumentCcEmails,
    ) {
    }

    public function sendOrderConfirmationEmail(Order $order): void
    {
        if ('' === $this->apiKey || '' === $this->apiSecret) {
            return;
        }

        $user = $order->getUser();
        if (!$user?->getEmail()) {
            return;
        }

        $this->sendTemplateEmail(
            (string) $user->getEmail(),
            $this->confirmationTemplateId,
            $this->sanitizeTemplateVariables($this->buildOrderConfirmationVariables($order)),
        );
    }

    public function sendAccountCredentialsEmail(User $user, string $plainPassword): void
    {
        if ('' === $this->apiKey || '' === $this->apiSecret || '' === $plainPassword) {
            return;
        }

        if (!$user->getEmail()) {
            return;
        }

        $this->sendTemplateEmail(
            (string) $user->getEmail(),
            $this->credentialsTemplateId,
            $this->sanitizeTemplateVariables($this->buildAccountCredentialsVariables($user, $plainPassword)),
        );
    }

    public function sendOrderProcessingNotification(Order $order): void
    {
        if ('' === $this->apiKey || '' === $this->apiSecret || 0 === $this->processingTemplateId || '' === $this->processingEmail) {
            return;
        }

        $user = $order->getUser();
        if (!$user?->getEmail()) {
            return;
        }

        $clientName = trim(sprintf('%s %s', (string) $user->getFirstName(), (string) $user->getLastName()));

        $this->sendTemplateEmail(
            $this->processingEmail,
            $this->processingTemplateId,
            $this->sanitizeTemplateVariables($this->buildOrderProcessingVariables($order)),
            '' !== $clientName ? $clientName : (string) $user->getEmail(),
            (string) $user->getEmail(),
            false,
            $this->processingCcEmails,
        );
    }

    public function sendTranslatedDocumentEmail(ClientDocument $document, string $siteBaseUrl): void
    {
        if ('' === $this->apiKey || '' === $this->apiSecret) {
            throw new \RuntimeException('La configuration Mailjet est incomplète.');
        }

        if (0 === $this->translatedDocumentTemplateId) {
            throw new \RuntimeException('Le modèle Mailjet du document traduit n\'est pas configuré.');
        }

        if (null === $document->getDocumentTraduit() || '' === $document->getDocumentTraduit()) {
            throw new \RuntimeException('Aucun document traduit n\'est disponible pour ce dossier.');
        }

        $user = $document->getUser();
        if (!$user?->getEmail()) {
            throw new \RuntimeException('Aucune adresse e-mail client n\'est associée à ce dossier.');
        }

        $this->sendTemplateEmail(
            (string) $user->getEmail(),
            $this->translatedDocumentTemplateId,
            $this->sanitizeTemplateVariables($this->buildTranslatedDocumentVariables($document, $siteBaseUrl)),
            copySupport: false,
            ccEmails: $this->translatedDocumentCcEmails,
            throwOnFailure: true,
        );
    }

    public function sendContactRequestNotification(
        string $nom,
        ?string $prenom,
        string $email,
        ?string $telephone,
        string $message,
        \DateTimeInterface $createdAt,
    ): void {
        if ('' === $this->apiKey || '' === $this->apiSecret || 0 === $this->contactTemplateId) {
            return;
        }

        $replyToName = trim(sprintf('%s %s', (string) $prenom, $nom));

        $this->sendTemplateEmail(
            $this->senderEmail,
            $this->contactTemplateId,
            $this->sanitizeTemplateVariables($this->buildContactRequestVariables(
                $nom,
                $prenom,
                $email,
                $telephone,
                $message,
                $createdAt,
            )),
            '' !== $replyToName ? $replyToName : $nom,
            $email,
            false,
            $this->contactCcEmails,
        );
    }

    /**
     * @param array<string, string>  $variables
     * @param list<string>           $ccEmails
     */
    private function sendTemplateEmail(
        string $toEmail,
        int $templateId,
        array $variables,
        ?string $replyToName = null,
        ?string $replyToEmail = null,
        bool $copySupport = true,
        array $ccEmails = [],
        bool $throwOnFailure = false,
    ): void {
        try {
            $message = [
                'From' => [
                    'Email' => $this->senderEmail,
                    'Name' => self::SENDER_NAME,
                ],
                'To' => [
                    ['Email' => $toEmail],
                ],
                'TemplateID' => $templateId,
                'TemplateLanguage' => true,
                'Variables' => $variables,
            ];

            $ccList = $ccEmails;
            if ($copySupport && '' !== $this->supportEmail) {
                $ccList[] = $this->supportEmail;
            }

            if ([] !== $ccList) {
                $message['Cc'] = array_map(
                    static fn (string $email): array => ['Email' => $email],
                    array_values(array_unique($ccList)),
                );
            }

            if (null !== $replyToEmail && '' !== $replyToEmail) {
                $message['ReplyTo'] = [
                    'Email' => $replyToEmail,
                    'Name' => $replyToName ?: $replyToEmail,
                ];
            }

            $response = $this->httpClient->request('POST', self::API_URL, [
                'auth_basic' => [$this->apiKey, $this->apiSecret],
                'json' => [
                    'Messages' => [$message],
                ],
            ]);

            if ($throwOnFailure) {
                $this->assertMailjetResponseIsSuccessful($response->toArray(false));
            }
        } catch (\Throwable $e) {
            if ($throwOnFailure) {
                if ($e instanceof \RuntimeException) {
                    throw $e;
                }

                throw new \RuntimeException('Impossible d\'envoyer l\'e-mail via Mailjet.', 0, $e);
            }

            // L'échec d'envoi ne doit pas bloquer la page de confirmation.
        }
    }

    /**
     * Empêche le moteur Mailjet de réinterpréter du contenu injecté comme du templating.
     *
     * @param array<string, string> $variables
     *
     * @return array<string, string>
     */
    private function sanitizeTemplateVariables(array $variables): array
    {
        $sanitized = [];

        foreach ($variables as $key => $value) {
            $sanitized[$key] = str_replace(
                ['{{', '}}', '{%', '%}'],
                ['&#123;&#123;', '&#125;&#125;', '&#123;%', '%&#125;'],
                $value,
            );
        }

        return $sanitized;
    }

    /**
     * @return array<string, string>
     */
    private function buildOrderConfirmationVariables(Order $order): array
    {
        $totalEuros = (float) $order->getTotal();

        return [
            'email' => (string) $order->getUser()?->getEmail(),
            'numero_commande' => (string) ($order->getInvoiceNumber() ?? ''),
            // Le template Mailjet divise ce montant par 100 : on envoie donc des centimes.
            'montant_total' => (string) (int) round($totalEuros * 100),
            'montant_total_affiche' => $this->formatMoney($totalEuros),
            'devise' => (string) $order->getCurrency(),
            'date_commande' => $this->formatOrderDate($order),
            'details_commande' => $this->buildOrderItemsHtml($order),
        ];
    }

    /**
     * @return array<string, string>
     */
    private function buildContactRequestVariables(
        string $nom,
        ?string $prenom,
        string $email,
        ?string $telephone,
        string $message,
        \DateTimeInterface $createdAt,
    ): array {
        return [
            'nom' => $nom,
            'prenom' => (string) $prenom,
            'email' => $email,
            'telephone' => $this->formatContactPhone($telephone),
            'message' => $this->formatContactMessage($message),
            'date_demande' => $this->formatContactDate($createdAt),
        ];
    }

    /**
     * @return array<string, string>
     */
    private function buildAccountCredentialsVariables(User $user, string $plainPassword): array
    {
        return [
            'email' => (string) $user->getEmail(),
            'mot_de_passe' => $plainPassword,
        ];
    }

    /**
     * @return array<string, string>
     */
    /**
     * @return array<string, string>
     */
    private function buildTranslatedDocumentVariables(ClientDocument $document, string $siteBaseUrl): array
    {
        $user = $document->getUser();
        $order = $document->getOrder();
        $downloadPath = $document->getDocumentTraduitUrl() ?? '';
        $downloadUrl = rtrim($siteBaseUrl, '/') . $downloadPath;

        return [
            'email' => (string) $user?->getEmail(),
            'prenom' => (string) $user?->getFirstName(),
            'nom' => (string) $user?->getLastName(),
            'numero_dossier' => sprintf('DC-%04d', $document->getId() ?? 0),
            'numero_commande' => (string) ($order?->getInvoiceNumber() ?? '—'),
            'titre_document' => (string) $document->getTitle(),
            'type_document' => (string) ($document->getDocument()?->getName() ?? '—'),
            'langue' => (string) ($document->getLanguage() ?? '—'),
            'nombre_pages' => (string) $document->getPageCount(),
            'mode_livraison' => $document->getReceiveByPaperLabel(),
            'date_livraison' => $this->formatDocumentDeliveryDate($document),
            'lien_telechargement' => $downloadUrl,
            'note_livraison' => $this->buildPaperDeliveryNoteHtml($document),
        ];
    }

    private function buildOrderProcessingVariables(Order $order): array
    {
        $user = $order->getUser();
        $company = trim((string) $user?->getCompany());

        return array_merge($this->buildOrderConfirmationVariables($order), [
            'nom' => (string) $user?->getLastName(),
            'prenom' => (string) $user?->getFirstName(),
            'telephone' => $this->formatContactPhone($user?->getPhone()),
            'societe' => '' !== $company ? $company : 'Non renseignée',
        ]);
    }

    private function formatOrderDate(Order $order): string
    {
        $createdAt = $order->getCreatedAt();
        if (!$createdAt) {
            return '';
        }

        if (class_exists(\IntlDateFormatter::class)) {
            $formatter = new \IntlDateFormatter('fr_FR', \IntlDateFormatter::LONG, \IntlDateFormatter::NONE);
            $formatted = $formatter->format($createdAt);
            if (false !== $formatted) {
                return $formatted;
            }
        }

        return $createdAt->format('d/m/Y');
    }

    private function buildOrderItemsHtml(Order $order): string
    {
        $rows = [];

        foreach ($order->getItems() as $item) {
            $lineTotal = $this->formatMoney((float) $item->getTotal());
            $rows[] = sprintf(
                '<table role="presentation" cellpadding="0" cellspacing="0" border="0" width="100%%"><tr>'
                . '<td style="padding: 12px 0; border-bottom: 1px solid rgba(61,61,61,0.15);">'
                . '<p style="margin: 0 0 4px 0; font-size: 15px; font-weight: 600; color: #0b2047;">%s</p>'
                . '<p style="margin: 0; font-size: 13px; color: #3d3d3d;">Quantité : %d &middot; %s</p>'
                . '</td></tr></table>',
                htmlspecialchars((string) $item->getTitle(), ENT_QUOTES, 'UTF-8'),
                $item->getQuantity(),
                htmlspecialchars($lineTotal, ENT_QUOTES, 'UTF-8'),
            );
        }

        return implode('', $rows);
    }

    private function formatMoney(float $amount): string
    {
        return number_format($amount, 2, ',', ' ') . ' €';
    }

    private function formatContactPhone(?string $telephone): string
    {
        $telephone = trim((string) $telephone);

        return '' !== $telephone ? $telephone : 'Non renseigné';
    }

    private function formatContactMessage(string $message): string
    {
        return nl2br(htmlspecialchars($message, ENT_QUOTES, 'UTF-8'));
    }

    private function formatContactDate(\DateTimeInterface $createdAt): string
    {
        if (class_exists(\IntlDateFormatter::class)) {
            $dateFormatter = new \IntlDateFormatter('fr_FR', \IntlDateFormatter::LONG, \IntlDateFormatter::NONE);
            $formattedDate = $dateFormatter->format($createdAt);
            if (false !== $formattedDate) {
                return sprintf('%s à %s', $formattedDate, $createdAt->format('H:i'));
            }
        }

        return $createdAt->format('d/m/Y à H:i');
    }

    private function formatDocumentDeliveryDate(ClientDocument $document): string
    {
        $uploadedAt = $document->getUploadedAt();
        if (!$uploadedAt) {
            return '';
        }

        if (class_exists(\IntlDateFormatter::class)) {
            $formatter = new \IntlDateFormatter('fr_FR', \IntlDateFormatter::LONG, \IntlDateFormatter::NONE);
            $formatted = $formatter->format($uploadedAt);
            if (false !== $formatted) {
                return $formatted;
            }
        }

        return $uploadedAt->format('d/m/Y');
    }

    private function buildPaperDeliveryNoteHtml(ClientDocument $document): string
    {
        if (!$document->isReceiveByPaper()) {
            return '';
        }

        return '<table role="presentation" cellpadding="0" cellspacing="0" border="0" width="100%" style="background-color: rgba(11,32,71,0.06); border-radius: 12px;">'
            . '<tr><td style="padding: 20px 24px;">'
            . '<p style="margin: 0 0 6px 0; font-size: 15px; font-weight: 600; color: #0b2047;">Livraison par courrier</p>'
            . '<p style="margin: 0; font-size: 14px; line-height: 1.6; color: #3d3d3d;">'
            . 'Vous avez choisi une réception papier. Votre document traduit vous sera également expédié par courrier postal à l\'adresse indiquée lors de votre commande.'
            . '</p></td></tr></table>';
    }

    /**
     * @param array<string, mixed> $payload
     */
    private function assertMailjetResponseIsSuccessful(array $payload): void
    {
        foreach ($payload['Messages'] ?? [] as $message) {
            if (($message['Status'] ?? '') === 'success') {
                continue;
            }

            $errors = $message['Errors'] ?? [];
            $errorMessage = $errors[0]['ErrorMessage'] ?? 'Erreur inconnue lors de l\'envoi Mailjet.';

            throw new \RuntimeException((string) $errorMessage);
        }
    }
}
