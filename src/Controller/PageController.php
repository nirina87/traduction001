<?php

namespace App\Controller;

use App\Entity\Article;
use App\Entity\Category;
use App\Entity\ClientDocument;
use App\Entity\Contact;
use App\Entity\Document;
use App\Entity\TranslationRate;
use App\Repository\DocumentRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Mailer\MailerInterface;
use Symfony\Component\Mime\Address;
use Symfony\Component\Mime\Email;
use Symfony\Component\Routing\Annotation\Route;

class PageController extends AbstractController
{
    public function __construct(
        private readonly DocumentRepository $documentRepository,
    ) {
    }

    private function getDocumentCatalog(): array
    {
        return $this->documentRepository->buildCatalog();
    }

    #[Route('/', name: 'accueil')]
    public function accueil(EntityManagerInterface $em): Response
    {
        $documents = $em->getRepository(Document::class)->findBy(
            [],
            ['id' => 'DESC']
        );    
        return $this->render('page/accueil.html.twig', ['products' => $documents]);
    }

   #[Route('/produit/{id}', name: 'produit_detail')]
    public function produitDetail(
        int $id,
        DocumentRepository $productRepository
    ): Response
    {
        $product = $productRepository->find($id);

        if (!$product) {
            throw $this->createNotFoundException('Produit non trouvé.');
        }

        return $this->render('page/produit_detail.html.twig', [
            'product' => $product,
        ]);
    }

    #[Route('/panier', name: 'panier')]
    public function panier(Request $request, EntityManagerInterface $em): Response
    {
        $cart = $request->getSession()->get('cart', []);
        $documents = $em->getRepository(Document::class)->findBy(['active' => true]);
        $translationRates = $em->getRepository(TranslationRate::class)->findBy(['active' => true]);

        return $this->render('page/panier.html.twig', [
            'cart' => $cart,
            'documents' => $documents,
            'translationRates' => $translationRates,
            'products' => $this->getDocumentCatalog(),
        ]);
    }

    #[Route('/panier/ajouter-document', name: 'panier_ajouter_document', methods: ['POST'])]
    public function ajouterDocumentClient(
        Request $request,
        EntityManagerInterface $em,
        DocumentRepository $documentRepository,
    ): Response {
        $uploadedFile = $request->files->get('documentFile');
        if (!$uploadedFile || !$uploadedFile->isValid()) {
            $this->addFlash('error', 'Veuillez joindre un document à traduire.');

            return $this->redirectToRoute('panier');
        }

        $documentId = (int) $request->request->get('documentId', 0);
        $language = trim((string) $request->request->get('language', ''));

        if ($documentId <= 0 || '' === $language) {
            $this->addFlash('error', 'Veuillez sélectionner un type de document et une langue cible.');

            return $this->redirectToRoute('panier');
        }

        $document = $documentRepository->find($documentId);
        if (!$document || !$document->isActive()) {
            $this->addFlash('error', 'Le document sélectionné est introuvable ou indisponible.');

            return $this->redirectToRoute('panier');
        }

        $rate = $em->getRepository(TranslationRate::class)->findOneBy([
            'document' => $document,
            'language' => $language,
            'active' => true,
        ]);

        $priceCents = $rate ? $rate->getPrice() : ((int) ($document->getBasePrice() ?? 0)) * 100;

        $clientDocument = new ClientDocument();
        $clientDocument->setTitle($uploadedFile->getClientOriginalName());
        $clientDocument->setDocument($document);
        $clientDocument->setLanguage($language);
        $clientDocument->setPrice($priceCents);
        $clientDocument->setFile($uploadedFile);
        $clientDocument->setUser($this->getUser());

        $em->persist($clientDocument);
        $em->flush();

        $session = $request->getSession();
        $cart = $session->get('cart', []);

        $cart[] = [
            'type' => 'client_upload',
            'id' => $clientDocument->getId(),
            'documentId' => $document->getId(),
            'title' => $clientDocument->getTitle(),
            'description' => $document->getName() . ' — traduction ' . $language,
            'price' => $priceCents,
            'language' => $language,
            'quantity' => 1,
            'uploaded' => true,
        ];

        $session->set('cart', $cart);
        $this->addFlash('success', 'Votre document a bien été ajouté au panier pour traduction.');

        return $this->redirectToRoute('panier');
    }

    #[Route('/panier/ajouter/{id}', name: 'panier_ajouter', methods: ['POST'])]
    public function ajouterAuPanier(int $id, Request $request): Response
    {
        $catalog = $this->getDocumentCatalog();

        if (!isset($catalog[$id])) {
            throw $this->createNotFoundException('Document non trouvé.');
        }

        $session = $request->getSession();
        $cart = $session->get('cart', []);

        $cart[$id] = [
            'id' => $id,
            'title' => $catalog[$id]['title'],
            'description' => $catalog[$id]['description'],
            'image' => $catalog[$id]['image'],
            'price' => $catalog[$id]['price'],
            'quantity' => ($cart[$id]['quantity'] ?? 0) + 1,
        ];

        $session->set('cart', $cart);
        $this->addFlash('success', 'Le document a été ajouté au panier.');

        return $this->redirectToRoute('panier');
    }

    #[Route('/panier/modifier/{id}', name: 'panier_modifier', methods: ['POST'])]
    public function modifierQuantitePanier(int $id, Request $request): Response
    {
        if (!isset($this->getDocumentCatalog()[$id])) {
            throw $this->createNotFoundException('Document non trouvé.');
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
        $documents = $em->getRepository(Document::class)->findBy(
            [],
            ['id' => 'DESC']
        );    
        return $this->render('page/nos_services.html.twig', ['products' => $documents]);
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