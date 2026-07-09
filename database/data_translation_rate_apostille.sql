-- Import des tarifs de traduction pour APOSTILLE (document_id = 22)
-- Généré le 2026-07-08
--
-- Correspondance CSV → table document :
--   TRADUCTION DE L'APOSTILLE → document.id = 22 (APOSTILLE)
--
-- Source : ml_traduction_documents_langues_tarif.csv
-- Lignes insérées : 60
-- Prix stockés en centimes (EUR × 100)
--
-- Note : le CSV contient 2 lignes Slovaque → Français (30 € et 34 €)

INSERT INTO `translation_rate` (`language_origine`, `language_cible`, `price`, `active`, `document_id`) VALUES
('Français', 'Anglais', 3000, 1, 22),
('Français', 'Allemand', 3000, 1, 22),
('Français', 'Italien', 3000, 1, 22),
('Français', 'Espagnol', 3000, 1, 22),
('Français', 'Roumain', 3400, 1, 22),
('Français', 'Arabe', 3000, 1, 22),
('Français', 'Turc', 3400, 1, 22),
('Français', 'Russe', 3000, 1, 22),
('Français', 'Albanais', 3400, 1, 22),
('Français', 'Chinois', 4500, 1, 22),
('Français', 'Portugais', 3400, 1, 22),
('Français', 'Japonais', 4500, 1, 22),
('Français', 'Grec', 4500, 1, 22),
('Français', 'Néerlandais', 3400, 1, 22),
('Français', 'Tchèque', 3400, 1, 22),
('Français', 'Slovaque', 3400, 1, 22),
('Français', 'Hongrois', 3400, 1, 22),
('Français', 'Cantonais', 7000, 1, 22),
('Français', 'Mandarin', 7000, 1, 22),
('Français', 'Polonais', 3400, 1, 22),
('Français', 'Serbe', 4500, 1, 22),
('Français', 'Vietnamien', 4500, 1, 22),
('Français', 'Coréen', 4500, 1, 22),
('Français', 'Danois', 4500, 1, 22),
('Français', 'Suédois', 3400, 1, 22),
('Français', 'Thaïlandais', 4500, 1, 22),
('Français', 'Croate', 3400, 1, 22),
('Anglais', 'Français', 3000, 1, 22),
('Allemand', 'Français', 3000, 1, 22),
('Italien', 'Français', 3000, 1, 22),
('Espagnol', 'Français', 3000, 1, 22),
('Roumain', 'Français', 3400, 1, 22),
('Arabe', 'Français', 3000, 1, 22),
('Portugais', 'Français', 3000, 1, 22),
('Néerlandais', 'Français', 3000, 1, 22),
('Turc', 'Français', 3000, 1, 22),
('Chinois', 'Français', 4500, 1, 22),
('Chinois', 'Anglais', 4500, 1, 22),
('Russe', 'Français', 3000, 1, 22),
('Albanais', 'Français', 3400, 1, 22),
('Ukrainien', 'Français', 3000, 1, 22),
('Slovaque', 'Français', 3000, 1, 22),
('Serbe', 'Français', 4500, 1, 22),
('Grec', 'Français', 3400, 1, 22),
('Japonais', 'Français', 4500, 1, 22),
('Polonais', 'Français', 3000, 1, 22),
('Mandarin', 'Français', 7000, 1, 22),
('Cantonais', 'Français', 7000, 1, 22),
('Hongrois', 'Français', 3400, 1, 22),
('Géorgien', 'Français', 3400, 1, 22),
('Tchèque', 'Français', 3400, 1, 22),
('Slovaque', 'Français', 3400, 1, 22),
('Vietnamien', 'Français', 4500, 1, 22),
('Coréen', 'Français', 4500, 1, 22),
('Danois', 'Français', 4500, 1, 22),
('Suédois', 'Français', 3400, 1, 22),
('Thaïlandais', 'Français', 4500, 1, 22),
('Croate', 'Français', 3400, 1, 22),
('Portugais', 'Espagnol', 3400, 1, 22),
('Espagnol', 'Portugais', 3400, 1, 22);
