<?php

namespace App\Controller\Admin;

use App\Entity\Article;
use App\Entity\Category;
use App\Entity\ClientDocument;
use App\Entity\Contact;
use App\Entity\Document;
use App\Entity\Product;
use App\Entity\TranslationRate;
use App\Repository\ArticleRepository;
use App\Repository\CategoryRepository;
use App\Repository\ClientDocumentRepository;
use App\Repository\ContactRepository;
use App\Repository\DocumentRepository;
use App\Repository\OrderRepository;
use App\Repository\ProductRepository;
use App\Repository\TranslationRateRepository;
use EasyCorp\Bundle\EasyAdminBundle\Attribute\AdminDashboard;
use EasyCorp\Bundle\EasyAdminBundle\Config\Assets;
use EasyCorp\Bundle\EasyAdminBundle\Config\Dashboard;
use EasyCorp\Bundle\EasyAdminBundle\Config\MenuItem;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractDashboardController;
use Symfony\Component\HttpFoundation\Response;

#[AdminDashboard(routePath: '/admin', routeName: 'admin')]
class DashboardController extends AbstractDashboardController
{
    public function __construct(
        private CategoryRepository $categoryRepository,
        private ArticleRepository $articleRepository,
        private ContactRepository $contactRepository,
        private ClientDocumentRepository $clientDocumentRepository,
        private DocumentRepository $documentRepository,
        private TranslationRateRepository $translationRateRepository,
        private ProductRepository $productRepository,
        private OrderRepository $orderRepository,
    ) {}

    public function index(): Response
    {
        $monthStart = new \DateTimeImmutable('first day of this month midnight');
        $monthEnd = $monthStart->modify('first day of next month');

        return $this->render('admin/dashboard.html.twig', [
            'stats' => [
                'categories' => $this->categoryRepository->count([]),
                'articles' => $this->articleRepository->count([]),
                'contacts' => $this->contactRepository->count([]),
                'clientDocuments' => $this->clientDocumentRepository->count([]),
                'documents' => $this->documentRepository->count([]),
                'translationRates' => $this->translationRateRepository->count([]),
                'products' => $this->productRepository->count([]),
                'monthlyRevenue' => $this->orderRepository->sumPaidTotalBetween($monthStart, $monthEnd),
                'monthlyPaidOrders' => $this->orderRepository->countPaidBetween($monthStart, $monthEnd),
            ],
            'recentContacts' => $this->contactRepository->findBy([], ['createdAt' => 'DESC'], 5),
            'recentClientDocuments' => $this->clientDocumentRepository->findRecentWithOrder(5),
            'recentArticles' => $this->articleRepository->findBy([], ['creation' => 'DESC'], 5),
        ]);
    }

    public function configureDashboard(): Dashboard
    {
        return Dashboard::new()
            ->setTitle('Traductions Légales');
    }

    public function configureAssets(): Assets
    {
        return Assets::new()
            ->addCssFile('https://fonts.googleapis.com/css2?family=Fraunces:ital,wght@0,300;0,400;0,500;0,600;1,400;1,500&family=Source+Sans+3:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500&display=swap')
            ->addCssFile('css/style.css')
            ->addCssFile('css/admin.css');
    }

    public function configureMenuItems(): iterable
    {
        yield MenuItem::linkToDashboard('Tableau de bord', 'fas fa-gauge-high');

        yield MenuItem::section('Contenu du site');
        yield MenuItem::linkToCrud('Catégories', 'fas fa-folder', Category::class);
        yield MenuItem::linkToCrud('Articles', 'fas fa-newspaper', Article::class);

        yield MenuItem::section('Traduction');
        yield MenuItem::linkToCrud('Documents à traduire', 'fas fa-file-lines', Document::class);
        yield MenuItem::linkToCrud('Tarifs par langue', 'fas fa-language', TranslationRate::class);

        $clientDocsItem = MenuItem::linkToCrud('Documents clients', 'fas fa-cloud-arrow-up', ClientDocument::class);
        $clientDocsCount = $this->clientDocumentRepository->count([]);
        if ($clientDocsCount > 0) {
            $clientDocsItem->setBadge($clientDocsCount, 'primary');
        }
        yield $clientDocsItem;

        yield MenuItem::section('Relations clients');
        $contactsItem = MenuItem::linkToCrud('Messages reçus', 'fas fa-inbox', Contact::class);
        $contactsCount = $this->contactRepository->count([]);
        if ($contactsCount > 0) {
            $contactsItem->setBadge($contactsCount, 'danger');
        }
        yield $contactsItem;

        yield MenuItem::section('Administration');
        yield MenuItem::linkToCrud('Documents administratifs', 'fas fa-file-contract', Product::class);

        yield MenuItem::section();
        yield MenuItem::linkToRoute('Voir le site public', 'fas fa-arrow-up-right-from-square', 'accueil')
            ->setLinkTarget('_blank')
            ->setCssClass('ea-menu-external-link');
    }
}
