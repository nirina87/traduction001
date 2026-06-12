<?php

namespace App\Controller;

use App\Entity\Order;
use App\Entity\OrderItem;
use App\Entity\User;
use App\Repository\ProductRepository;
use App\Service\StripeCheckoutService;
use Doctrine\ORM\EntityManagerInterface;
use Stripe\Exception\ApiErrorException;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Bundle\SecurityBundle\Security;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Routing\Generator\UrlGeneratorInterface;

class CheckoutController extends AbstractController
{
    public function __construct(
        private readonly StripeCheckoutService $stripeCheckoutService,
        private readonly ProductRepository $productRepository,
    ) {
    }

    private function getCatalog(): array
    {
        $catalog = [];

        foreach ($this->productRepository->findCatalogProducts() as $product) {
            $id = $product->getId();
            if (null === $id) {
                continue;
            }

            $catalog[$id] = [
                'title' => $product->getTitle(),
                'description' => $product->getDescription(),
                'image' => $product->getImage(),
                'price' => $product->getPrice(),
            ];
        }

        return $catalog;
    }

    #[Route('/inscription', name: 'app_register')]
    public function register(Request $request, EntityManagerInterface $em, UserPasswordHasherInterface $hasher, Security $security): Response
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

            $security->login($user, null, 'main');

            $this->addFlash('success', 'Votre compte a été créé. Vous pouvez maintenant finaliser votre commande.');

            $targetPath = (string) ($request->request->get('_target_path') ?? $request->query->get('_target_path', ''));
            if ('' !== $targetPath && str_starts_with($targetPath, '/') && !str_starts_with($targetPath, '//')) {
                return $this->redirect($targetPath);
            }

            return $this->redirectToRoute('accueil');
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
            return $this->redirectToRoute('app_user_login', ['_target_path' => $this->generateUrl('commande')]);
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

        // Stripe exige le placeholder littéral {CHECKOUT_SESSION_ID} (non encodé en %7B...%7D).
        $successUrl = $router->generate(
            'commande_succes',
            [],
            UrlGeneratorInterface::ABSOLUTE_URL,
        ) . '?session_id={CHECKOUT_SESSION_ID}';
        $cancelUrl = $router->generate(
            'commande_annulee',
            [],
            UrlGeneratorInterface::ABSOLUTE_URL,
        );

        try {
            $session = $this->stripeCheckoutService->createCheckoutSession(
                $lineItems,
                (string) $user->getEmail(),
                $successUrl,
                $cancelUrl,
                (string) $user->getId(),
            );
        } catch (ApiErrorException $e) {
            $this->addFlash('error', 'Impossible d’initialiser le paiement Stripe. Veuillez réessayer.');

            return $this->redirectToRoute('commande');
        } catch (\RuntimeException $e) {
            $this->addFlash('error', $e->getMessage());

            return $this->redirectToRoute('commande');
        }

        $order = new Order();
        $order->setUser($user);
        $order->setTotal((string) number_format($total / 100, 2, '.', ''));
        $order->setCurrency('EUR');
        $order->setStatus('pending');
        $order->setStripeSessionId($session->id);
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

        return $this->redirect($session->url, 303);
    }

    #[Route('/commande/succes', name: 'commande_succes')]
    public function success(Request $request, EntityManagerInterface $em): Response
    {
        $sessionId = (string) $request->query->get('session_id', '');
        if ('' === $sessionId) {
            throw $this->createNotFoundException('Session Stripe introuvable.');
        }

        $order = $em->getRepository(Order::class)->findOneBy(['stripeSessionId' => $sessionId]);

        try {
            $stripeSession = $this->stripeCheckoutService->retrieveCheckoutSession($sessionId);
        } catch (ApiErrorException) {
            throw $this->createNotFoundException('Session Stripe introuvable ou invalide.');
        }

        if ($order && 'paid' === $stripeSession->payment_status) {
            $order->setStatus('paid');
            $em->flush();
            $request->getSession()->remove('cart');
        }

        return $this->render('page/commande_succes.html.twig', [
            'order' => $order,
            'paymentConfirmed' => 'paid' === $stripeSession->payment_status,
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
