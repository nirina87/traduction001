-- Mise à jour des slugs document (format : traduction-{name-slugified})
-- À exécuter après la migration Version20260713141500

UPDATE document SET slug = 'traduction-acte-de-naissance' WHERE id = 1;
UPDATE document SET slug = 'traduction-acte-de-mariage' WHERE id = 2;
UPDATE document SET slug = 'traduction-diplomes' WHERE id = 3;
UPDATE document SET slug = 'traduction-certificats' WHERE id = 4;
UPDATE document SET slug = 'traduction-releves-de-notes' WHERE id = 5;
UPDATE document SET slug = 'traduction-casiers-judiciaires' WHERE id = 6;
UPDATE document SET slug = 'traduction-attestations' WHERE id = 7;
UPDATE document SET slug = 'traduction-permis-de-conduire' WHERE id = 8;
UPDATE document SET slug = 'traduction-carte-nationale-d-identite' WHERE id = 9;
UPDATE document SET slug = 'traduction-extraits-kbis' WHERE id = 10;
UPDATE document SET slug = 'traduction-statuts-de-societes' WHERE id = 11;
UPDATE document SET slug = 'traduction-contrats' WHERE id = 12;
UPDATE document SET slug = 'traduction-conventions' WHERE id = 13;
UPDATE document SET slug = 'traduction-cessions' WHERE id = 14;
UPDATE document SET slug = 'traduction-jugements' WHERE id = 15;
UPDATE document SET slug = 'traduction-assignations' WHERE id = 16;
UPDATE document SET slug = 'traduction-bilans-comptables' WHERE id = 17;
UPDATE document SET slug = 'traduction-rapports' WHERE id = 18;
UPDATE document SET slug = 'traduction-liasses-fiscales' WHERE id = 19;
UPDATE document SET slug = 'traduction-acte-de-deces' WHERE id = 20;
UPDATE document SET slug = 'traduction-passeport' WHERE id = 21;
UPDATE document SET slug = 'traduction-apostille' WHERE id = 22;
