<?php

namespace App\Service;

use App\Entity\Article;
use App\Entity\Document;
use App\Repository\DocumentRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Routing\Generator\UrlGeneratorInterface;

final class SitemapService
{
    public function __construct(
        private readonly UrlGeneratorInterface $router,
        private readonly DocumentRepository $documentRepository,
        private readonly EntityManagerInterface $entityManager,
    ) {
    }

    /**
     * @return list<array{loc: string, lastmod: ?string, changefreq: string, priority: string}>
     */
    public function getEntries(): array
    {
        $entries = [];

        foreach ($this->getStaticPages() as $page) {
            $entries[] = [
                'loc' => $this->absoluteUrl($page['route']),
                'lastmod' => null,
                'changefreq' => $page['changefreq'],
                'priority' => $page['priority'],
            ];
        }

        foreach ($this->documentRepository->findBy(['active' => true], ['id' => 'ASC']) as $document) {
            $entries[] = [
                'loc' => $this->absoluteUrl('produit_detail', ['id' => $document->getId()]),
                'lastmod' => null,
                'changefreq' => 'weekly',
                'priority' => '0.7',
            ];
        }

        foreach ($this->entityManager->getRepository(Article::class)->findAll() as $article) {
            $category = $article->getCategory();
            $slug = $article->getSlug();

            if (null === $category || null === $slug || '' === $category->getSlug()) {
                continue;
            }

            $entries[] = [
                'loc' => $this->absoluteUrl('article_show', [
                    'category' => $category->getSlug(),
                    'slug' => $slug,
                ]),
                'lastmod' => $article->getCreation()?->format('Y-m-d'),
                'changefreq' => 'monthly',
                'priority' => '0.6',
            ];
        }

        return $entries;
    }

    /**
     * @return list<array{route: string, changefreq: string, priority: string}>
     */
    private function getStaticPages(): array
    {
        return [
            ['route' => 'accueil', 'changefreq' => 'weekly', 'priority' => '1.0'],
            ['route' => 'services', 'changefreq' => 'weekly', 'priority' => '0.9'],
            ['route' => 'qui_sommes_nous', 'changefreq' => 'monthly', 'priority' => '0.8'],
            ['route' => 'contact', 'changefreq' => 'monthly', 'priority' => '0.8'],
            ['route' => 'cgv', 'changefreq' => 'yearly', 'priority' => '0.3'],
            ['route' => 'politique_confidentialite', 'changefreq' => 'yearly', 'priority' => '0.3'],
        ];
    }

    /**
     * @param array<string, int|string> $parameters
     */
    private function absoluteUrl(string $route, array $parameters = []): string
    {
        return $this->router->generate(
            $route,
            $parameters,
            UrlGeneratorInterface::ABSOLUTE_URL,
        );
    }
}
