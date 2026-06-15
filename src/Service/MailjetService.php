<?php

namespace App\Service;

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
        private readonly string $senderEmail,
        private readonly string $supportEmail,
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

    /**
     * @param array<string, string> $variables
     */
    private function sendTemplateEmail(string $toEmail, int $templateId, array $variables): void
    {
        try {
            $this->httpClient->request('POST', self::API_URL, [
                'auth_basic' => [$this->apiKey, $this->apiSecret],
                'json' => [
                    'Messages' => [
                        [
                            'From' => [
                                'Email' => $this->senderEmail,
                                'Name' => self::SENDER_NAME,
                            ],
                            'To' => [
                                ['Email' => $toEmail],
                            ],
                            'Cc' => [
                                ['Email' => $this->supportEmail],
                            ],
                            'TemplateID' => $templateId,
                            'TemplateLanguage' => true,
                            'Variables' => $variables,
                        ],
                    ],
                ],
            ]);
        } catch (\Throwable) {
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
        return [
            'email' => (string) $order->getUser()?->getEmail(),
            'numero_commande' => (string) ($order->getInvoiceNumber() ?? ''),
            'montant_total' => (string) $order->getTotal(),
            'devise' => (string) $order->getCurrency(),
            'date_commande' => $this->formatOrderDate($order),
            'details_commande' => $this->buildOrderItemsHtml($order),
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
            $rows[] = sprintf(
                '<table role="presentation" cellpadding="0" cellspacing="0" border="0" width="100%%"><tr>'
                . '<td style="padding: 12px 0; border-bottom: 1px solid rgba(61,61,61,0.15);">'
                . '<p style="margin: 0 0 4px 0; font-size: 15px; font-weight: 600; color: #0b2047;">%s</p>'
                . '<p style="margin: 0; font-size: 13px; color: #3d3d3d;">Quantité : %d &middot; %s %s</p>'
                . '</td></tr></table>',
                htmlspecialchars((string) $item->getTitle(), ENT_QUOTES, 'UTF-8'),
                $item->getQuantity(),
                htmlspecialchars($item->getTotal(), ENT_QUOTES, 'UTF-8'),
                htmlspecialchars($order->getCurrency(), ENT_QUOTES, 'UTF-8'),
            );
        }

        return implode('', $rows);
    }
}
