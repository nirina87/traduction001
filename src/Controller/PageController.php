<?php

namespace App\Controller;

use App\Entity\Article;
use App\Entity\Category;
use App\Entity\Contact;
use App\Repository\ProductRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Mailer\MailerInterface;
use Symfony\Component\Mime\Email;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Mime\Address;

class PageController extends AbstractController
{
    public function __construct(
        private readonly ProductRepository $productRepository,
    ) {
    }

    private function getProductCatalog(): array
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

    #[Route('/', name: 'accueil')]
    public function accueil(EntityManagerInterface $em): Response
    {
        $articles = $em->getRepository(Article::class)->findBy(
            [],
            ['creation' => 'DESC']
        );    
        return $this->render('page/accueil.html.twig', ['articles' => $articles]);
    }

    #[Route('/produit/{id}', name: 'produit_detail')]
    public function produitDetail(int $id): Response
    {
        $products = $this->getProductCatalog();

        if (!isset($products[$id])) {
            throw $this->createNotFoundException('Produit non trouvé.');
        }

        return $this->render('page/produit_detail.html.twig', [
            'product' => $products[$id],
            'productId' => $id,
            'products' => $products,
        ]);
    }

    #[Route('/panier', name: 'panier')]
    public function panier(Request $request): Response
    {
        $cart = $request->getSession()->get('cart', []);

        return $this->render('page/panier.html.twig', [
            'cart' => $cart,
            'products' => $this->getProductCatalog(),
        ]);
    }

    #[Route('/panier/ajouter/{id}', name: 'panier_ajouter', methods: ['POST'])]
    public function ajouterAuPanier(int $id, Request $request): Response
    {
        $products = $this->getProductCatalog();

        if (!isset($products[$id])) {
            throw $this->createNotFoundException('Produit non trouvé.');
        }

        $session = $request->getSession();
        $cart = $session->get('cart', []);

        $cart[$id] = [
            'id' => $id,
            'title' => $products[$id]['title'],
            'description' => $products[$id]['description'],
            'image' => $products[$id]['image'],
            'quantity' => ($cart[$id]['quantity'] ?? 0) + 1,
        ];

        $session->set('cart', $cart);
        $this->addFlash('success', 'Le document a été ajouté au panier.');

        return $this->redirectToRoute('panier');
    }

    #[Route('/panier/modifier/{id}', name: 'panier_modifier', methods: ['POST'])]
    public function modifierQuantitePanier(int $id, Request $request): Response
    {
        if (!isset($this->getProductCatalog()[$id])) {
            throw $this->createNotFoundException('Produit non trouvé.');
        }

        $session = $request->getSession();
        $cart = $session->get('cart', []);

        if (!isset($cart[$id])) {
            $this->addFlash('error', 'Ce document n’est pas dans votre panier.');

            return $this->redirectToRoute('panier');
        }

        $quantity = max(1, min(99, (int) $request->request->get('quantity', 1)));
        $cart[$id]['quantity'] = $quantity;
        $session->set('cart', $cart);
        $this->addFlash('success', 'Quantité mise à jour.');

        return $this->redirectToRoute('panier');
    }

    #[Route('/panier/supprimer/{id}', name: 'panier_supprimer', methods: ['POST'])]
    public function supprimerDuPanier(int $id, Request $request): Response
    {
        $session = $request->getSession();
        $cart = $session->get('cart', []);

        if (!isset($cart[$id])) {
            $this->addFlash('error', 'Ce document n’est pas dans votre panier.');

            return $this->redirectToRoute('panier');
        }

        unset($cart[$id]);
        $session->set('cart', $cart);
        $this->addFlash('success', 'Le document a été retiré du panier.');

        return $this->redirectToRoute('panier');
    }

    #[Route('/services', name: 'services')]
    public function Services(EntityManagerInterface $em): Response
    {
        $articles = $em->getRepository(Article::class)->findBy(
            [],
            ['creation' => 'DESC']
        ); 
        return $this->render('page/nos_services.html.twig', ['articles' => $articles]);
    }

    #[Route('/qui-sommes-nous', name: 'qui_sommes_nous')]
    public function quiSommesNous(): Response
    {
        return $this->render('page/qui_sommes_nous.html.twig');
    }

    #[Route('/mentions-legales', name: 'mentions_legales')]
    public function mentionsLegales(): Response
    {
        return $this->render('page/mentions_legales.html.twig');
    }

    #[Route('/agroalimentaire', name: 'agroalimentaire')]
    public function agroalimentaire(EntityManagerInterface $em): Response
    {
        
        $articles = $em->getRepository(Article::class)->findBy(
            [],
            ['creation' => 'DESC']
        ); 
        return $this->render('page/agroalimentaire.html.twig', ['articles' => $articles]);
    }

    #[Route('/contact', name: 'contact')]
    public function contact(): Response
    {
        return $this->render('page/contact.html.twig');
    }

    #[Route('/contact/ajax', name: 'contact_ajax', methods: ['POST'])]
    public function ajax(Request $request, EntityManagerInterface $em, MailerInterface $mailer): JsonResponse
    {
        $nom = $request->request->get('nom');
        $prenom = $request->request->get('prenom');
        $email = $request->request->get('email');
        $telephone = $request->request->get('telephone');
        $message = $request->request->get('message');

        if (!$nom || !$message || !$email) {
            return new JsonResponse([
                'success' => false
            ]);
        }

        try {
            // ✅ ENREGISTREMENT
            $contact = new Contact();
            $contact->setNom($nom);
            $contact->setPrenom($prenom);
            $contact->setEmail($email);
            $contact->setTelephone($telephone);
            $contact->setMessage($message);
            $contact->setCreatedAt(new \DateTime());

            $em->persist($contact);
            $em->flush();

            // ✅ EMAIL
            $mail = (new Email())
                ->from(new Address('all@ibkz2229.odns.fr', 'ESPACE HYGIENE 3D'))
                ->to(new Address('contact@espacehygiene3d.com'))
                ->addTo(new Address('contact@espacehygiene3d.fr'))
                ->replyTo($email)
                ->subject('Nouveau message de contact')
                ->html("
                    <h2>Nouveau message</h2>
                    <p><strong>Nom :</strong> {$nom}</p>
                    <p><strong>Prénom :</strong> {$prenom}</p>
                    <p><strong>Email :</strong> {$email}</p>
                    <p><strong>Téléphone :</strong> {$telephone}</p>
                    <p><strong>Message :</strong><br>{$message}</p>
                    <p><strong>Date :</strong> " . (new \DateTime())->format('d/m/Y H:i') . "</p>
                ");

            $mailer->send($mail);

            return new JsonResponse([
                'success' => true
            ]);

        } catch (\Exception $e) {
            return new JsonResponse([
                'success' => false,
                'error' => $e->getMessage()
            ]);
        }
    }


    //affiche page details
    #[Route('/{category}/{slug}', name: 'article_show')]
    public function show(string $category, string $slug, EntityManagerInterface $em): Response
    {
        $categoryEntity = $em->getRepository(Category::class)->findOneBy([
            'slug' => $category
        ]);

        if (!$categoryEntity) {
            throw $this->createNotFoundException('Catégorie non trouvée');
        }

        $article = $em->getRepository(Article::class)->findOneBy([
            'slug' => $slug,
            'category' => $categoryEntity
        ]);

        $articles = $em->getRepository(Article::class)->findBy(
            ['category' => $categoryEntity],
            ['creation' => 'ASC'],
            6 // limite à 3 articles
        );

        if (!$article) {
            throw $this->createNotFoundException('Article non trouvé');
        }

        return $this->render('page/show.html.twig', [
            'article' => $article,
            'articles' => $articles
        ]);
    }
}