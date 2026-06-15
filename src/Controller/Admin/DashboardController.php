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
use Doctrine\DBAL\Connection;
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
        private Connection $conn,
    ) {}

    public function index(): Response
    {
        // Récupérer les statistiques
        $totalCategories = count($this->categoryRepository->findAll());
        $totalArticles = count($this->articleRepository->findAll());
        $recentArticles = $this->articleRepository->findBy([], ['creation' => 'DESC'], 5);
        // Récupérer contacts
        $contacts = $this->conn->fetchAllAssociative(
            'SELECT * FROM contact ORDER BY created_at DESC LIMIT 5'
        );
        return $this->render('admin/dashboard.html.twig', [
            'totalCategories' => $totalCategories,
            'totalArticles' => $totalArticles,
            'recentArticles' => $recentArticles,
            'contacts' => $contacts,
        ]);
    }

    public function configureDashboard(): Dashboard
    {
        return Dashboard::new()
            ->setTitle('ADMIN - Admin');
    }

    public function configureAssets(): Assets
    {
        return Assets::new()
            ->addCssFile('css/admin.css');
    }

    public function configureMenuItems(): iterable
    {
        yield MenuItem::linkToDashboard('🏠 Dashboard', 'fa fa-home');
        yield MenuItem::linkToCrud('📁 Catégories', 'fas fa-folder', Category::class);
        yield MenuItem::linkToCrud('📄 Articles', 'fas fa-file', Article::class);
        yield MenuItem::linkToCrud('📚 Documents à traduire', 'fas fa-file-alt', Document::class);
        yield MenuItem::linkToCrud('🌍 Tarifs par langue', 'fas fa-language', TranslationRate::class);
        yield MenuItem::linkToCrud('📎 Documents clients', 'fas fa-cloud-upload-alt', ClientDocument::class);
        yield MenuItem::linkToCrud('📄 Documents administratifs', 'fas fa-file-alt', Product::class);
        yield MenuItem::linkToCrud('📩 Contacts', 'fas fa-envelope', Contact::class);
    }


}
