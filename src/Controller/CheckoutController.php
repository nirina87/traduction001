<?php

namespace App\Controller;

use App\Entity\Order;
use App\Entity\OrderItem;
use App\Entity\User;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Routing\Generator\UrlGeneratorInterface;

class CheckoutController extends AbstractController
{
    private function createStripeCheckoutSession(array $lineItems, string $customerEmail, string $successUrl, string $cancelUrl, string $stripeSecret, string $userId): array
    {
        $payload = json_encode([
            'mode' => 'payment',
            'customer_email' => $customerEmail,
            'success_url' => $successUrl,
            'cancel_url' => $cancelUrl,
            'metadata' => ['user_id' => $userId],
            'line_items' => $lineItems,
        ], JSON_THROW_ON_ERROR);

        $ch = curl_init('https://api.stripe.com/v1/checkout/sessions');
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Authorization: Bearer ' . $stripeSecret,
            'Content-Type: application/json',
            'Accept: application/json',
        ]);

        $response = curl_exec($ch);
        $error = curl_error($ch);
        $statusCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($response === false || $statusCode >= 400) {
            throw new \RuntimeException($error ?: 'Impossible de créer la session Stripe (HTTP ' . $statusCode . ').');
        }

        $decoded = json_decode($response, true, 512, JSON_THROW_ON_ERROR);

        if (!isset($decoded['id'], $decoded['url'])) {
            throw new \RuntimeException('Réponse Stripe invalide.');
        }

        return $decoded;
    }

    private function getCatalog(): array
    {
        return [
            1 => ['title' => 'Acte de naissance', 'description' => 'Traduction officielle pour démarches administratives, études ou visas.', 'image' => 'img/logos/logo-1.png', 'price' => 4500],
            2 => ['title' => 'Certificat de mariage', 'description' => 'Version traduite certifiée pour les procédures civiles et migratoires.', 'image' => 'img/logos/logo-2.png', 'price' => 4200],
            3 => ['title' => 'Acte de décès', 'description' => 'Traduction conforme pour succession, héritage et formalités officielles.', 'image' => 'img/logos/logo-3.png', 'price' => 4300],
            4 => ['title' => 'Diplôme universitaire', 'description' => 'Traduction assermentée pour admission, recrutement ou équivalence.', 'image' => 'img/logos/logo-4.png', 'price' => 4700],
            5 => ['title' => 'Relevé de notes', 'description' => 'Document académique traduit avec rigueur et précision.', 'image' => 'img/logos/logo-5.png', 'price' => 3900],
            6 => ['title' => 'Contrat de travail', 'description' => 'Traduction juridique pour expatriation, embauche ou démarches consulaires.', 'image' => 'img/logos/logo-6.png', 'price' => 5200],
            7 => ['title' => 'Statuts de société', 'description' => 'Version traduite pour création d’entreprise, immatriculation ou audit.', 'image' => 'img/projects/project-home-1.jpg', 'price' => 6500],
            8 => ['title' => 'Procès-verbal judiciaire', 'description' => 'Traduction officielle pour procédures légales et contentieux.', 'image' => 'img/projects/project-home-2.jpg', 'price' => 7000],
            9 => ['title' => 'Attestation de résidence', 'description' => 'Document administratif traduit pour établissement, visa ou résidences.', 'image' => 'img/projects/project-home-3.jpg', 'price' => 3800],
            10 => ['title' => 'Fiche de salaire', 'description' => 'Traduction utile pour banque, immigration, emploi ou démarches fiscales.', 'image' => 'img/clients/client-1.jpg', 'price' => 3500],
        ];
    }

    #[Route('/inscription', name: 'app_register')]
    public function register(Request $request, EntityManagerInterface $em, UserPasswordHasherInterface $hasher): Response
    {
        if ($request->isMethod('POST')) {
            $email = trim((string) $request->request->get('email', ''));
            $plainPassword = (string) $request->request->get('password', '');
            $firstName = trim((string) $request->request->get('firstName', ''));
            $lastName = trim((string) $request->request->get('lastName', ''));
            $company = trim((string) $request->request->get('company', ''));
            $phone = trim((string) $request->request->get('phone', ''));

            if (!filter_var($email, FILTER_VALIDATE_EMAIL) || strlen($plainPassword) < 8) {
                $this->addFlash('error', 'Veuillez fournir une adresse email valide et un mot de passe d’au moins 8 caractères.');

                return $this->render('security/register.html.twig');
            }

            $existing = $em->getRepository(User::class)->findOneBy(['email' => $email]);
            if ($existing) {
                $this->addFlash('error', 'Cet email est déjà utilisé.');

                return $this->render('security/register.html.twig');
            }

            $user = new User();
            $user->setEmail($email);
            $user->setPassword($hasher->hashPassword($user, $plainPassword));
            $user->setFirstName($firstName);
            $user->setLastName($lastName);
            $user->setCompany($company);
            $user->setPhone($phone);

            $em->persist($user);
            $em->flush();

            $this->addFlash('success', 'Votre compte a été créé. Vous pouvez maintenant finaliser votre commande.');

            return $this->redirectToRoute('app_user_login');
        }

        return $this->render('security/register.html.twig');
    }

    #[Route('/commande', name: 'commande')]
    public function commande(Request $request): Response
    {
        $cart = $request->getSession()->get('cart', []);

        return $this->render('page/commande.html.twig', [
            'cart' => $cart,
            'products' => $this->getCatalog(),
            'user' => $this->getUser(),
        ]);
    }

    #[Route('/commande/checkout', name: 'commande_checkout')]
    public function checkout(Request $request, EntityManagerInterface $em, UrlGeneratorInterface $router): RedirectResponse
    {
        $user = $this->getUser();
        if (!$user instanceof User) {
            return $this->redirectToRoute('app_user_login');
        }

        $cart = $request->getSession()->get('cart', []);
        if (!$cart) {
            $this->addFlash('error', 'Votre panier est vide.');

            return $this->redirectToRoute('panier');
        }

        $products = $this->getCatalog();
        $lineItems = [];
        $total = 0;

        foreach ($cart as $item) {
            $product = $products[$item['id']] ?? null;
            if (!$product) {
                continue;
            }
            $unitAmount = (int) ($product['price'] * 100 / 100);
            $quantity = (int) ($item['quantity'] ?? 1);
            $total += $product['price'] * $quantity;

            $lineItems[] = [
                'price_data' => [
                    'currency' => 'eur',
                    'product_data' => [
                        'name' => $product['title'],
                        'description' => substr($product['description'], 0, 200),
                    ],
                    'unit_amount' => $product['price'],
                ],
                'quantity' => $quantity,
            ];
        }

        if (!$lineItems) {
            $this->addFlash('error', 'Aucun produit valide n’est disponible pour le paiement.');

            return $this->redirectToRoute('panier');
        }

        $stripeSecret = $_ENV['STRIPE_SECRET_KEY'] ?? null;
        if (!$stripeSecret) {
            $this->addFlash('error', 'La clé Stripe n’est pas configurée.');

            return $this->redirectToRoute('commande');
        }

        $successUrl = $router->generate('commande_succes', ['session_id' => '{CHECKOUT_SESSION_ID}'], UrlGeneratorInterface::ABSOLUTE_URL);
        $cancelUrl = $router->generate('commande_annulee', [], UrlGeneratorInterface::ABSOLUTE_URL);

        $session = $this->createStripeCheckoutSession(
            $lineItems,
            (string) $user->getEmail(),
            $successUrl,
            $cancelUrl,
            $stripeSecret,
            (string) $user->getId(),
        );

        $order = new Order();
        $order->setUser($user);
        $order->setTotal((string) number_format($total / 100, 2, '.', ''));
        $order->setCurrency('EUR');
        $order->setStatus('pending');
        $order->setStripeSessionId($session['id']);
        $order->setInvoiceNumber('FACT-' . date('Ymd') . '-' . random_int(1000, 9999));

        foreach ($cart as $item) {
            $product = $products[$item['id']] ?? null;
            if (!$product) {
                continue;
            }
            $quantity = (int) ($item['quantity'] ?? 1);
            $unitPrice = (string) number_format($product['price'] / 100, 2, '.', '');
            $lineTotal = (string) number_format(($product['price'] * $quantity) / 100, 2, '.', '');

            $orderItem = new OrderItem();
            $orderItem->setProductId($item['id']);
            $orderItem->setTitle($product['title']);
            $orderItem->setDescription($product['description']);
            $orderItem->setQuantity($quantity);
            $orderItem->setUnitPrice($unitPrice);
            $orderItem->setTotal($lineTotal);
            $order->addItem($orderItem);
        }

        $em->persist($order);
        $em->flush();

        return $this->redirect($session['url'], 303);
    }

    #[Route('/commande/succes', name: 'commande_succes')]
    public function success(Request $request, EntityManagerInterface $em): Response
    {
        $sessionId = (string) $request->query->get('session_id', '');
        if (!$sessionId) {
            throw $this->createNotFoundException('Session Stripe introuvable.');
        }

        $order = $em->getRepository(Order::class)->findOneBy(['stripeSessionId' => $sessionId]);
        if ($order) {
            $order->setStatus('paid');
            $em->flush();
        }

        return $this->render('page/commande_succes.html.twig', [
            'order' => $order,
        ]);
    }

    #[Route('/commande/annulee', name: 'commande_annulee')]
    public function cancelled(): Response
    {
        return $this->render('page/commande_annulee.html.twig');
    }

    #[Route('/commande/facture/{id}', name: 'commande_facture')]
    public function facture(int $id, EntityManagerInterface $em): Response
    {
        $order = $em->getRepository(Order::class)->find($id);
        if (!$order || $order->getUser() !== $this->getUser()) {
            throw $this->createNotFoundException('Facture introuvable.');
        }

        return $this->render('page/facture.html.twig', ['order' => $order]);
    }
}
