<?php

namespace App\Support;

final class TargetLanguages
{
    private const SEPARATOR = ' vers ';

    /**
     * @return list<string>
     */
    public static function languages(): array
    {
        return [
            'Français',
            'Anglais',
            'Arabe',
            'Espagnol',
            'Italien',
            'Allemand',
            'Portugais',
            'Russe',
            'Chinois',
            'Japonais',
            'Turc',
            'Néerlandais',
            'Suédois',
            'Polonais',
            'Coréen',
            'Hindi',
            'Ukrainien',
            'Persan',
            'Swahili',
        ];
    }

    /**
     * @return list<string>
     */
    public static function all(): array
    {
        $pairs = [];

        foreach (self::languages() as $source) {
            foreach (self::languages() as $target) {
                if ($source === $target) {
                    continue;
                }

                $pairs[] = self::formatPair($source, $target);
            }
        }

        return $pairs;
    }

    /**
     * @return array<string, list<string>>
     */
    public static function pairsGroupedBySource(): array
    {
        $grouped = [];

        foreach (self::languages() as $source) {
            $grouped[$source] = [];

            foreach (self::languages() as $target) {
                if ($source === $target) {
                    continue;
                }

                $grouped[$source][] = self::formatPair($source, $target);
            }
        }

        return $grouped;
    }

    public static function formatPair(string $source, string $target): string
    {
        return $source . self::SEPARATOR . $target;
    }

    public static function isValid(string $pair): bool
    {
        return \in_array($pair, self::all(), true);
    }
}
