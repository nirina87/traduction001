-- Catalogue produits (table product)
-- Équivalent de l'ancienne fonction getProductCatalog().
-- Exécuter une seule fois. Les prix sont en centimes d'euro (ex. 4500 = 45,00 €).
--
-- Étape 1 : synchroniser le schéma Doctrine (colonnes image et price sur product)
--   php bin/console doctrine:schema:update --force
--
-- Étape 2 : exécuter ce script SQL

INSERT INTO product (id, title, type, description, status, image, price) VALUES
(1, 'Acte de naissance', 'Certificat', 'Traduction officielle pour démarches administratives, études ou visas.', 'Actif', 'img/logos/logo-1.png', 4500),
(2, 'Certificat de mariage', 'Certificat', 'Version traduite certifiée pour les procédures civiles et migratoires.', 'Actif', 'img/logos/logo-2.png', 4200),
(3, 'Acte de décès', 'Certificat', 'Traduction conforme pour succession, héritage et formalités officielles.', 'Actif', 'img/logos/logo-3.png', 4300),
(4, 'Diplôme universitaire', 'Certificat', 'Traduction assermentée pour admission, recrutement ou équivalence.', 'Actif', 'img/logos/logo-4.png', 4700),
(5, 'Relevé de notes', 'Attestation', 'Document académique traduit avec rigueur et précision.', 'Actif', 'img/logos/logo-5.png', 3900),
(6, 'Contrat de travail', 'Attestation', 'Traduction juridique pour expatriation, embauche ou démarches consulaires.', 'Actif', 'img/logos/logo-6.png', 5200),
(7, 'Statuts de société', 'Attestation', 'Version traduite pour création d’entreprise, immatriculation ou audit.', 'Actif', 'img/projects/project-home-1.jpg', 6500),
(8, 'Procès-verbal judiciaire', 'Rapport', 'Traduction officielle pour procédures légales et contentieux.', 'Actif', 'img/projects/project-home-2.jpg', 7000),
(9, 'Attestation de résidence', 'Attestation', 'Document administratif traduit pour établissement, visa ou résidences.', 'Actif', 'img/projects/project-home-3.jpg', 3800),
(10, 'Fiche de salaire', 'Attestation', 'Traduction utile pour banque, immigration, emploi ou démarches fiscales.', 'Actif', 'img/clients/client-1.jpg', 3500);
