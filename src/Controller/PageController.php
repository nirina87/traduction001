<?php

namespace App\Controller;

use App\Entity\Article;
use App\Entity\Category;
use App\Entity\ClientDocument;
use App\Entity\Contact;
use App\Entity\Document;
use App\Entity\User;
use App\Repository\DocumentRepository;
use App\Repository\TranslationRateRepository;
use App\Service\ClientDocumentOwnerService;
use App\Service\MailjetService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class PageController extends AbstractController
{
    public function __construct(
        private readonly DocumentRepository $documentRepository,
        private readonly TranslationRateRepository $translationRateRepository,
        private readonly ClientDocumentOwnerService $clientDocumentOwnerService,
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
            ['id' => 'ASC']
        );
        return $this->render('page/accueil.html.twig', ['products' => $documents]);
    }

    #[Route('/produit/{id}', name: 'produit_detail')]
    public function produitDetail(
        int $id,
        DocumentRepository $productRepository,
        EntityManagerInterface $em,
    ): Response {
        $product = $productRepository->find($id);

        if (!$product || !$product->isActive()) {
            throw $this->createNotFoundException('Produit non trouvé.');
        }

        $translationRates = [];
        foreach ($this->translationRateRepository->findActiveByDocument($product) as $rate) {
            $translationRates[$rate->getLanguagePair()] = $rate->getPrice();
        }

        $languagePairs = $this->translationRateRepository->buildPairsGroupedBySourceForDocument($product);

        return $this->render('page/produit_detail.html.twig', [
            'product' => $product,
            'languagePairs' => $languagePairs,
            'hasLanguagePairs' => [] !== $languagePairs,
            'translationRates' => $translationRates,
            'basePriceCents' => ((int) ($product->getBasePrice() ?? 0)) * 100,
        ]);
    }

    #[Route('/panier', name: 'panier')]
    public function panier(Request $request): Response
    {
        $cart = $request->getSession()->get('cart', []);

        return $this->render('page/panier.html.twig', [
            'cart' => $cart,
            'products' => $this->getDocumentCatalog(),
        ]);
    }

    #[Route('/panier/ajouter/{id}', name: 'panier_ajouter', methods: ['POST'])]
    public function ajouterAuPanier(
        int $id,
        Request $request,
        EntityManagerInterface $em,
        DocumentRepository $documentRepository,
    ): Response {
        $document = $documentRepository->find($id);
        if (!$document || !$document->isActive()) {
            throw $this->createNotFoundException('Document non trouvé.');
        }

        $uploadedFile = $request->files->get('documentFile');
        if (!$uploadedFile || !$uploadedFile->isValid()) {
            $this->addFlash('error', 'Veuillez joindre un document à traduire.');

            return $this->redirectToRoute('produit_detail', ['id' => $id]);
        }

        $language = trim((string) $request->request->get('language', ''));
        $hasLanguagePairs = [] !== $this->translationRateRepository->findActiveByDocument($document);

        if ($hasLanguagePairs) {
            $rate = $this->translationRateRepository->findActiveForDocumentAndPair($document, $language);
            if ('' === $language || null === $rate) {
                $this->addFlash('error', 'Veuillez sélectionner une paire de langues valide.');

                return $this->redirectToRoute('produit_detail', ['id' => $id]);
            }

            $unitPriceCents = $rate->getPrice();
        } else {
            $unitPriceCents = ((int) ($document->getBasePrice() ?? 0)) * 100;
            $language = '';
        }

        $pageCount = max(1, min(99, (int) $request->request->get('pageCount', 1)));
        $receiveByPaper = $request->request->has('receiveByPaper');
        $totalPriceCents = $unitPriceCents * $pageCount;
        if ($receiveByPaper) {
            $totalPriceCents += ClientDocument::PAPER_DELIVERY_SURCHARGE_CENTS;
        }

        $clientDocument = new ClientDocument();
        $clientDocument->setTitle($uploadedFile->getClientOriginalName());
        $clientDocument->setDocument($document);
        $clientDocument->setLanguage('' !== $language ? $language : null);
        $clientDocument->setPrice($totalPriceCents);
        $clientDocument->setReceiveByPaper($receiveByPaper);
        $clientDocument->setFile($uploadedFile);

        $user = $this->getUser();
        if ($user instanceof User) {
            $clientDocument->setUser($user);
        }

        $em->persist($clientDocument);
        $em->flush();

        $this->clientDocumentOwnerService->registerPendingDocumentId((int) $clientDocument->getId());

        $session = $request->getSession();
        $cart = $session->get('cart', []);

        $description = $document->getName();
        if ('' !== $language) {
            $description .= ' — traduction ' . $language;
        }
        $description .= ' — ' . $pageCount . ' page' . ($pageCount > 1 ? 's' : '');
        if ($receiveByPaper) {
            $description .= ' — réception par papier';
        }

        $cart[] = [
            'type' => 'client_upload',
            'id' => $clientDocument->getId(),
            'documentId' => $document->getId(),
            'title' => $clientDocument->getTitle(),
            'description' => $description,
            'price' => $unitPriceCents,
            'language' => '' !== $language ? $language : null,
            'pageCount' => $pageCount,
            'quantity' => $pageCount,
            'receiveByPaper' => $receiveByPaper,
            'paperSurchargeCents' => $receiveByPaper ? ClientDocument::PAPER_DELIVERY_SURCHARGE_CENTS : 0,
            'uploaded' => true,
        ];

        $session->set('cart', $cart);
        $this->addFlash('success', 'Votre document a bien été ajouté au panier pour traduction.');

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
        return $this->retirerLignePanier((string) $id, $request);
    }

    #[Route('/panier/retirer/{cartKey}', name: 'panier_retirer', methods: ['POST'])]
    public function retirerLignePanier(string $cartKey, Request $request): Response
    {
        $session = $request->getSession();
        $cart = $session->get('cart', []);

        $key = ctype_digit($cartKey) ? (int) $cartKey : $cartKey;

        if (!\array_key_exists($key, $cart)) {
            $this->addFlash('error', 'Ce document n’est pas dans votre panier.');

            return $this->redirectToRoute('panier');
        }

        unset($cart[$key]);
        $session->set('cart', $cart);
        $this->addFlash('success', 'Le document a été retiré du panier.');

        return $this->redirectToRoute('panier');
    }

    #[Route('/services', name: 'services')]
    public function Services(EntityManagerInterface $em): Response
    {
        $documents = $em->getRepository(Document::class)->findBy(
            [],
            ['id' => 'ASC']
        );
        return $this->render('page/nos_services.html.twig', ['products' => $documents]);
    }

    #[Route('/qui-sommes-nous', name: 'qui_sommes_nous')]
    public function quiSommesNous(EntityManagerInterface $em): Response
    {
        $documentCount = $em->getRepository(Document::class)->count(['active' => true]);

        return $this->render('page/qui_sommes_nous.html.twig', [
            'documentCount' => $documentCount,
        ]);
    }

    #[Route('/mentions-legales', name: 'mentions_legales')]
    public function mentionsLegales(): Response
    {
        return $this->render('page/mentions_legales.html.twig');
    }

    #[Route('/cgv', name: 'cgv')]
    public function cgv(): Response
    {
        return $this->render('page/cgv.html.twig');
    }

    #[Route('/politique-de-confidentialite', name: 'politique_confidentialite')]
    public function politiqueConfidentialite(): Response
    {
        return $this->render('page/politique_confidentialite.html.twig');
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
        return $this->render('page/contact.html.twig', [
            'languagePairs' => $this->translationRateRepository->buildPairsGroupedBySource(),
        ]);
    }

    #[Route('/modele', name: 'modele')]
    public function modele(): Response
    {
        return $this->render('page/modele.html.twig');
    }

    #[Route('/contact/ajax', name: 'contact_ajax', methods: ['POST'])]
    public function ajax(Request $request, EntityManagerInterface $em, MailjetService $mailjetService): JsonResponse
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
            $createdAt = new \DateTime();

            $contact = new Contact();
            $contact->setNom($nom);
            $contact->setPrenom($prenom);
            $contact->setEmail($email);
            $contact->setTelephone($telephone);
            $contact->setMessage($message);
            $contact->setCreatedAt($createdAt);

            $em->persist($contact);
            $em->flush();

            $mailjetService->sendContactRequestNotification(
                (string) $nom,
                $prenom ? (string) $prenom : null,
                (string) $email,
                $telephone ? (string) $telephone : null,
                (string) $message,
                $createdAt,
            );

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