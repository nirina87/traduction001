<?php

namespace App\Controller;

use App\Service\SitemapService;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Routing\Generator\UrlGeneratorInterface;

class SeoController extends AbstractController
{
    /**
     * @var list<string>
     */
    private const DISALLOWED_PATHS = [
        '/admin',
        '/login',
        '/connexion',
        '/inscription',
        '/logout',
        '/panier',
        '/commande',
        '/contact/ajax',
        '/modele',
        '/agroalimentaire',
    ];

    #[Route('/robots.txt', name: 'robots_txt', methods: ['GET'])]
    public function robots(UrlGeneratorInterface $router): Response
    {
        $sitemapUrl = $router->generate('sitemap_xml', [], UrlGeneratorInterface::ABSOLUTE_URL);

        $lines = [
            'User-agent: *',
            'Allow: /',
        ];

        foreach (self::DISALLOWED_PATHS as $path) {
            $lines[] = 'Disallow: ' . $path;
        }

        $lines[] = '';
        $lines[] = 'Sitemap: ' . $sitemapUrl;

        return new Response(
            implode("\n", $lines) . "\n",
            Response::HTTP_OK,
            [
                'Content-Type' => 'text/plain; charset=UTF-8',
                'Cache-Control' => 'public, max-age=86400',
            ],
        );
    }

    #[Route('/sitemap.xml', name: 'sitemap_xml', methods: ['GET'])]
    public function sitemap(SitemapService $sitemapService): Response
    {
        $response = $this->render('seo/sitemap.xml.twig', [
            'entries' => $sitemapService->getEntries(),
        ]);

        $response->headers->set('Content-Type', 'application/xml; charset=UTF-8');
        $response->setPublic();
        $response->setMaxAge(3600);

        return $response;
    }
}
