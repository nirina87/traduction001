DROP TABLE IF EXISTS `app_order`;
CREATE TABLE IF NOT EXISTS `app_order` (
  `id` int NOT NULL AUTO_INCREMENT,
  `total` decimal(10,2) NOT NULL,
  `currency` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `stripe_session_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `invoice_number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_23FA1E55A76ED395` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `app_order_item`
--

DROP TABLE IF EXISTS `app_order_item`;
CREATE TABLE IF NOT EXISTS `app_order_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci,
  `quantity` int NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `order_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_4F1B4758D9F6D38` (`order_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `app_user`
--

DROP TABLE IF EXISTS `app_user`;
CREATE TABLE IF NOT EXISTS `app_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `roles` json NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_88BDF3E9E7927C74` (`email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `article`
--

DROP TABLE IF EXISTS `article`;
CREATE TABLE IF NOT EXISTS `article` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_id` int DEFAULT NULL,
  `title` longtext,
  `creation` date DEFAULT NULL,
  `metacription` longtext,
  `words` longtext,
  `content1` longtext,
  `content2` longtext,
  `images` longtext,
  `slug` varchar(191) NOT NULL,
  `banner_name` varchar(255) DEFAULT NULL,
  `featured_name` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_23A0E66989D9B62` (`slug`),
  KEY `IDX_23A0E6612469DE2` (`category_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `article`
--

INSERT INTO `article` (`id`, `category_id`, `title`, `creation`, `metacription`, `words`, `content1`, `content2`, `images`, `slug`, `banner_name`, `featured_name`, `updated_at`) VALUES
(4, 2, 'test', NULL, 'teste', '<div>test</div>', '<div>test</div>', '<div>test</div>', NULL, 'test', '653703827-959717273075533-2256641913046934436-n-69e397605b40b316670648.jpg', '503869136-24087296194201257-4476407947809583389-n-69e397605cd89732496164.jpg', '2026-04-18 14:38:24');

-- --------------------------------------------------------

--
-- Structure de la table `category`
--

DROP TABLE IF EXISTS `category`;
CREATE TABLE IF NOT EXISTS `category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `slug` longtext,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `category`
--

INSERT INTO `category` (`id`, `name`, `slug`) VALUES
(2, 'Services', 'services');

-- --------------------------------------------------------

--
-- Structure de la table `client_document`
--

DROP TABLE IF EXISTS `client_document`;
CREATE TABLE IF NOT EXISTS `client_document` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `language` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` int DEFAULT NULL,
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `uploaded_at` datetime DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `document_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_F68FBAB3A76ED395` (`user_id`),
  KEY `IDX_F68FBAB3C33F7837` (`document_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `contact`
--

DROP TABLE IF EXISTS `contact`;
CREATE TABLE IF NOT EXISTS `contact` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `telephone` varchar(50) DEFAULT NULL,
  `message` longtext,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Structure de la table `doctrine_migration_versions`
--

DROP TABLE IF EXISTS `doctrine_migration_versions`;
CREATE TABLE IF NOT EXISTS `doctrine_migration_versions` (
  `version` varchar(191) NOT NULL,
  `executed_at` datetime DEFAULT NULL,
  `execution_time` int DEFAULT NULL,
  PRIMARY KEY (`version`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Structure de la table `document`
--

DROP TABLE IF EXISTS `document`;
CREATE TABLE IF NOT EXISTS `document` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci,
  `category` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `base_price` int DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `image` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `document`
--

INSERT INTO `document` (`id`, `name`, `description`, `category`, `base_price`, `active`, `image`) VALUES
(1, 'ACTE DE NAISSANCE', '<div>Traduction assermentée d\'actes de naissance destinés aux démarches administratives, demandes de visa, naturalisation, études ou mariage à l\'étranger. Documents reconnus par les administrations, consulats et organismes officiels internationaux.&nbsp;</div>', 'Document', 28, 1, ''),
(2, 'ACTE DE MARIAGE', '<div>&nbsp;Traduction certifiée d\'actes de mariage pour les procédures de regroupement familial, immigration, naturalisation, succession ou reconnaissance d\'union à l\'étranger. Traductions conformes aux exigences des autorités compétentes.&nbsp;</div>', 'Document', 28, 1, ''),
(3, 'DIPLÔMES', '<div>&nbsp;Traduction officielle de diplômes universitaires, certificats de réussite et titres académiques. Indispensable pour les inscriptions universitaires, équivalences de diplômes et opportunités professionnelles à l\'international.&nbsp;</div>', 'Document', 28, 1, ''),
(4, 'CERTIFICATS', '<div>&nbsp;Traduction certifiée de certificats administratifs, médicaux, scolaires ou professionnels. Réalisée avec précision afin de garantir leur validité auprès des administrations et organismes étrangers.&nbsp;</div>', 'Document', 28, 1, ''),
(5, 'RELEVÉS DE NOTES', '<div>&nbsp;Traduction assermentée de relevés de notes et bulletins scolaires. Reconnue pour les candidatures universitaires, demandes de bourses, équivalences académiques et poursuites d\'études à l\'étranger.&nbsp;</div>', 'Document', 28, 1, ''),
(6, 'CASIERS JUDICIAIRES', '<div>&nbsp;Traduction officielle de casiers judiciaires et bulletins de non-condamnation. Acceptée pour les demandes de visa, immigration, emploi international et procédures administratives spécifiques.&nbsp;</div>', 'Document', 28, 1, ''),
(7, 'ATTESTATIONS', '<div>&nbsp;Traduction de toutes formes d\'attestations administratives, professionnelles ou personnelles. Documents traduits avec exactitude pour être présentés auprès d\'organismes publics ou privés.&nbsp;</div>', 'Document', 28, 1, ''),
(8, 'PERMIS DE CONDUIRE', '<div>&nbsp;Traduction certifiée de permis de conduire français ou étrangers. Reconnue pour les échanges de permis, demandes de résidence et formalités administratives internationales.&nbsp;</div>', 'Document', 28, 1, ''),
(9, 'CARTE NATIONALE D\'IDENTITÉ (CNI)', '<div>&nbsp;Traduction assermentée de cartes nationales d\'identité pour les démarches officielles, administratives, bancaires ou juridiques en France et à l\'international.&nbsp;</div>', 'Document', 28, 1, ''),
(10, 'EXTRAITS KBIS', '<div>&nbsp;Traduction professionnelle d\'extraits Kbis et documents d\'immatriculation. Essentielle pour les formalités commerciales, bancaires et partenariats internationaux.&nbsp;</div>', 'Document', 28, 1, ''),
(11, 'STATUTS DE SOCIÉTÉS', '<div>&nbsp;Traduction juridique des statuts d\'entreprises, modifications statutaires et documents de gouvernance. Réalisée avec une terminologie adaptée au droit des affaires.&nbsp;</div>', 'Document', 28, 1, ''),
(12, 'CONTRATS', '<div>&nbsp;Traduction précise de contrats commerciaux, de travail, de prestation de services ou de partenariat. Respect des clauses et de la terminologie juridique spécifique.&nbsp;</div>', 'Document', 28, 1, ''),
(13, 'CONVENTIONS', '<div>&nbsp;Traduction de conventions, accords et protocoles d\'entente. Documents adaptés aux besoins des entreprises, associations et institutions internationales.&nbsp;</div>', 'Document', 28, 1, ''),
(14, 'CESSIONS', '<div>&nbsp;Traduction d\'actes de cession de fonds de commerce, parts sociales, actions ou droits. Réalisée dans le respect des exigences juridiques et administratives.&nbsp;</div>', 'Document', 28, 1, ''),
(15, 'JUGEMENTS DE DIVORCE', '<div>&nbsp;Traduction assermentée de jugements de divorce et décisions judiciaires. Reconnue pour les procédures administratives, familiales et juridiques à l\'étranger.&nbsp;</div>', 'Document', 28, 1, ''),
(16, 'ASSIGNATIONS', '<div>&nbsp;Traduction certifiée d\'assignations, actes de procédure et documents judiciaires. Acceptée par les tribunaux, avocats et administrations compétentes.&nbsp;</div>', 'Document', 28, 1, ''),
(17, 'BILANS COMPTABLES', '<div>&nbsp;Traduction spécialisée de bilans financiers et comptables. Adaptée aux besoins des entreprises, investisseurs et organismes de contrôle internationaux.&nbsp;</div>', 'Document', 28, 1, ''),
(18, 'RAPPORTS', '<div>&nbsp;Traduction de rapports d\'activité, rapports financiers, audits et études professionnelles. Réalisée avec rigueur et terminologie sectorielle appropriée.&nbsp;</div>', 'Document', 28, 1, ''),
(19, 'LIASSES FISCALES', '<div>&nbsp;Traduction de liasses fiscales et documents déclaratifs destinés aux administrations, partenaires financiers et organismes internationaux. Conforme aux standards comptables et fiscaux.&nbsp;</div>', 'Document', 28, 1, 'logo-tl-1781540505.png');

-- --------------------------------------------------------

--
-- Structure de la table `messenger_messages`
--

DROP TABLE IF EXISTS `messenger_messages`;
CREATE TABLE IF NOT EXISTS `messenger_messages` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `headers` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue_name` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `available_at` datetime NOT NULL,
  `delivered_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_75EA56E0FB7336F0E3BD61CE16BA31DBBF396750` (`queue_name`,`available_at`,`delivered_at`,`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `product`
--

DROP TABLE IF EXISTS `product`;
CREATE TABLE IF NOT EXISTS `product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci,
  `issued_at` date DEFAULT NULL,
  `valid_until` date DEFAULT NULL,
  `status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `document_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `translation_rate`
--

DROP TABLE IF EXISTS `translation_rate`;
CREATE TABLE IF NOT EXISTS `translation_rate` (
  `id` int NOT NULL AUTO_INCREMENT,
  `language` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` int NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `document_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_F2CE9CA2C33F7837` (`document_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
COMMIT;
