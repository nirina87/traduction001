-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : sam. 27 juin 2026 à 19:59
-- Version du serveur : 11.4.12-MariaDB
-- Version de PHP : 8.4.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `ibkz2229_traductionl`
--

-- --------------------------------------------------------

--
-- Structure de la table `app_order`
--

CREATE TABLE `app_order` (
  `id` int(11) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `currency` varchar(10) NOT NULL,
  `status` varchar(30) NOT NULL,
  `stripe_session_id` varchar(100) DEFAULT NULL,
  `invoice_number` varchar(100) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `app_order`
--

INSERT INTO `app_order` (`id`, `total`, `currency`, `status`, `stripe_session_id`, `invoice_number`, `created_at`, `user_id`) VALUES
(8, 28.00, 'EUR', 'paid', 'cs_test_a17jgwEZzNlLd3ZeQIQoFuOP314JcXvxKM0Qn2516g0w8AczldyOoUSkLj', 'FACT-20260623-2672', '2026-06-23 11:12:02', 7),
(9, 28.00, 'EUR', 'pending', 'cs_live_a1BFox1SlJWpvEkVewPfTXaCLfNtNfqwAVvuhlZxIX4RynmNyA7aciAOxV', 'FACT-20260623-5027', '2026-06-23 12:00:37', 7),
(10, 84.00, 'EUR', 'pending', 'cs_live_a1pbcTiUiSCu8vM3IABkHYAU6XMpCgOvBYtSyNNuXGZtiTxXwWtILrGj7s', 'FACT-20260624-6116', '2026-06-24 14:17:03', 7),
(11, 51.00, 'EUR', 'pending', 'cs_live_b1FLtcTGa6UO0pmeDYPrhWGmUWY2UNPbirD0KarZQZse9xBBVAEpPTPjDf', 'FACT-20260626-3327', '2026-06-26 20:10:13', 7),
(12, 37.00, 'EUR', 'pending', 'cs_live_a1yEFtL1uCnhkCofX4EmxdmdIlDZufeeqS35n3jfCQRrEFmrnyEilq771X', 'FACT-20260627-1180', '2026-06-27 09:56:52', 7),
(13, 36.00, 'EUR', 'pending', 'cs_live_a1a4Q3sz47wf36z6CCQDCHgkCaMUk0p0ohs1F9YmB4VqPgs3Ahb5HmBwDj', 'FACT-20260627-7030', '2026-06-27 11:47:39', 7);

-- --------------------------------------------------------

--
-- Structure de la table `app_order_item`
--

CREATE TABLE `app_order_item` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` longtext DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `order_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `app_order_item`
--

INSERT INTO `app_order_item` (`id`, `product_id`, `title`, `description`, `quantity`, `unit_price`, `total`, `order_id`) VALUES
(8, 13, 'ACTE.png', 'ACTE DE NAISSANCE — traduction Italien', 1, 28.00, 28.00, 8),
(9, 14, 'ACTE.png', 'DIPLÔMES — traduction Espagnol', 1, 28.00, 28.00, 9),
(10, 16, 'Capture d’écran du 2026-06-24 13-09-04.png', 'ACTE DE MARIAGE — traduction Français vers Italien — 3 pages', 3, 28.00, 84.00, 10),
(11, 17, 'MARIAGE.png', 'ACTE DE MARIAGE — traduction Français vers Néerlandais — 1 page — réception par papier', 1, 36.00, 51.00, 11),
(12, 18, '17825469758403375953009524811478.jpg', 'JUGEMENTS — traduction Français vers Russe — 1 page', 1, 37.00, 37.00, 12),
(13, 19, 'MARIAGE.png', 'ACTE DE MARIAGE — traduction Français vers Italien — 1 page', 1, 36.00, 36.00, 13);

-- --------------------------------------------------------

--
-- Structure de la table `app_user`
--

CREATE TABLE `app_user` (
  `id` int(11) NOT NULL,
  `email` varchar(180) NOT NULL,
  `roles` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`roles`)),
  `password` varchar(255) NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `company` varchar(100) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `app_user`
--

INSERT INTO `app_user` (`id`, `email`, `roles`, `password`, `first_name`, `last_name`, `company`, `phone`, `created_at`) VALUES
(7, 'franckieandriamalala@gmail.com', '[\"ROLE_USER\"]', '$2y$13$YeBDgt8VQo5LX3O7wwEUxOwfJnNFUy2nZWPYjqBeIsK4ND0S0v/aq', 'FRANCKIE', 'ANTONNIO', 'EASY TECHNOLOGY', '06 12 16 09 02', '2026-06-23 11:11:46');

-- --------------------------------------------------------

--
-- Structure de la table `article`
--

CREATE TABLE `article` (
  `id` int(11) NOT NULL,
  `title` longtext DEFAULT NULL,
  `slug` varchar(191) NOT NULL,
  `creation` date DEFAULT NULL,
  `metacription` longtext DEFAULT NULL,
  `words` longtext DEFAULT NULL,
  `content1` longtext DEFAULT NULL,
  `content2` longtext DEFAULT NULL,
  `images` longtext DEFAULT NULL,
  `banner_name` varchar(255) DEFAULT NULL,
  `featured_name` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `article`
--

INSERT INTO `article` (`id`, `title`, `slug`, `creation`, `metacription`, `words`, `content1`, `content2`, `images`, `banner_name`, `featured_name`, `updated_at`, `category_id`) VALUES
(4, 'test', 'test', NULL, 'teste', '<div>test</div>', '<div>test</div>', '<div>test</div>', NULL, '653703827-959717273075533-2256641913046934436-n-69e397605b40b316670648.jpg', '503869136-24087296194201257-4476407947809583389-n-69e397605cd89732496164.jpg', '2026-04-18 14:38:24', 2);

-- --------------------------------------------------------

--
-- Structure de la table `category`
--

CREATE TABLE `category` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `slug` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `category`
--

INSERT INTO `category` (`id`, `name`, `slug`) VALUES
(2, 'Services', 'services');

-- --------------------------------------------------------

--
-- Structure de la table `client_document`
--

CREATE TABLE `client_document` (
  `id` int(11) NOT NULL,
  `title` varchar(150) NOT NULL,
  `language` varchar(100) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `uploaded_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `document_id` int(11) DEFAULT NULL,
  `receive_by_paper` tinyint(1) NOT NULL DEFAULT 0,
  `order_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `contact`
--

CREATE TABLE `contact` (
  `id` int(11) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `telephone` varchar(50) DEFAULT NULL,
  `message` longtext DEFAULT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `contact`
--

INSERT INTO `contact` (`id`, `nom`, `prenom`, `email`, `telephone`, `message`, `created_at`) VALUES
(1, 'Daydou', 'Jean', 'daydoujean@gmail.com', '', 'Type de document : Diplôme / relevé de notes\r\nLangue souhaitée : Français vers Anglais\r\n\r\nBonjour, \r\n\r\nIl s\'agit de la confirmation de réussite du passage du Diplome National d\'Art. Une page. \r\n\r\n', '2026-06-26 15:39:22');

-- --------------------------------------------------------

--
-- Structure de la table `doctrine_migration_versions`
--

CREATE TABLE `doctrine_migration_versions` (
  `version` varchar(191) NOT NULL,
  `executed_at` datetime DEFAULT NULL,
  `execution_time` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `doctrine_migration_versions`
--

INSERT INTO `doctrine_migration_versions` (`version`, `executed_at`, `execution_time`) VALUES
('DoctrineMigrations\\Version20260616130436', '2026-06-16 15:04:41', 720),
('DoctrineMigrations\\Version20260624145203', '2026-06-24 17:13:45', 74),
('DoctrineMigrations\\Version20260627120000', '2026-06-27 11:21:33', 270);

-- --------------------------------------------------------

--
-- Structure de la table `document`
--

CREATE TABLE `document` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` longtext DEFAULT NULL,
  `category` varchar(80) DEFAULT NULL,
  `base_price` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `document`
--

INSERT INTO `document` (`id`, `name`, `description`, `category`, `base_price`, `active`, `image`) VALUES
(1, 'ACTE DE NAISSANCE', '<div>Traduction assermentée d\'actes de naissance destinés aux démarches administratives, demandes de visa, naturalisation, études ou mariage à l\'étranger. Documents reconnus par les administrations, consulats et organismes officiels internationaux.&nbsp;</div>', 'Document', 30, 1, 'ese-1781858782.jpg'),
(2, 'ACTE DE MARIAGE', '<div>&nbsp;Traduction certifiée d\'actes de mariage pour les procédures de regroupement familial, immigration, naturalisation, succession ou reconnaissance d\'union à l\'étranger. Traductions conformes aux exigences des autorités compétentes.&nbsp;</div>', 'Document', 36, 1, 'serm-1781858662.jpg'),
(3, 'DIPLÔMES', '<div>&nbsp;Traduction officielle de diplômes universitaires, certificats de réussite et titres académiques. Indispensable pour les inscriptions universitaires, équivalences de diplômes et opportunités professionnelles à l\'international.&nbsp;</div>', 'Document', 28, 1, 'ope-1781858597.jpg'),
(4, 'CERTIFICATS', '<div>&nbsp;Traduction certifiée de certificats administratifs, médicaux, scolaires ou professionnels. Réalisée avec précision afin de garantir leur validité auprès des administrations et organismes étrangers.&nbsp;</div>', 'Document', 28, 1, 'certificat-1781862293.jpg'),
(5, 'RELEVÉS DE NOTES', '<div>&nbsp;Traduction assermentée de relevés de notes et bulletins scolaires. Reconnue pour les candidatures universitaires, demandes de bourses, équivalences académiques et poursuites d\'études à l\'étranger.&nbsp;</div>', 'Document', 28, 1, 'xx-1781858876.jpg'),
(6, 'CASIERS JUDICIAIRES', '<div>&nbsp;Traduction officielle de casiers judiciaires et bulletins de non-condamnation. Acceptée pour les demandes de visa, immigration, emploi international et procédures administratives spécifiques.&nbsp;</div>', 'Document', 28, 1, 'casier-judiciaire-1781858932.jpg'),
(7, 'ATTESTATIONS', '<div>&nbsp;Traduction de toutes formes d\'attestations administratives, professionnelles ou personnelles. Documents traduits avec exactitude pour être présentés auprès d\'organismes publics ou privés.&nbsp;</div>', 'Document', 30, 1, 'attestations-1781862242.jpg'),
(8, 'PERMIS DE CONDUIRE', '<div>&nbsp;Traduction certifiée de permis de conduire français ou étrangers. Reconnue pour les échanges de permis, demandes de résidence et formalités administratives internationales.&nbsp;</div>', 'Document', 28, 1, 'permis-1781858982.jpg'),
(9, 'CARTE NATIONALE D\'IDENTITÉ (CNI)', '<div>&nbsp;Traduction assermentée de cartes nationales d\'identité pour les démarches officielles, administratives, bancaires ou juridiques en France et à l\'international.&nbsp;</div>', 'Document', 28, 1, 'cin-1781858324.jpg'),
(10, 'EXTRAITS KBIS', '<div>Traduction professionnelle d\'extraits Kbis et documents d\'immatriculation. Essentielle pour les formalités commerciales, bancaires et partenariats internationaux.&nbsp;</div>', 'Document', 28, 1, 'kbis-1781858241.jpg'),
(11, 'STATUTS DE SOCIÉTÉS', '<div>&nbsp;Traduction juridique des statuts d\'entreprises, modifications statutaires et documents de gouvernance. Réalisée avec une terminologie adaptée au droit des affaires.&nbsp;</div>', 'Document', 28, 1, 'status-1781616172.jpg'),
(12, 'CONTRATS', '<div>&nbsp;Traduction précise de contrats commerciaux, de travail, de prestation de services ou de partenariat. Respect des clauses et de la terminologie juridique spécifique.&nbsp;</div>', 'Document', 28, 1, 'contrats-1781616226.jpg'),
(13, 'CONVENTIONS', '<div>&nbsp;Traduction de conventions, accords et protocoles d\'entente. Documents adaptés aux besoins des entreprises, associations et institutions internationales.&nbsp;</div>', 'Document', 28, 1, 'conventions-1781616088.jpg'),
(14, 'CESSIONS', '<div>&nbsp;Traduction d\'actes de cession de fonds de commerce, parts sociales, actions ou droits. Réalisée dans le respect des exigences juridiques et administratives.&nbsp;</div>', 'Document', 28, 1, 'cessions-1781615975.jpg'),
(15, 'JUGEMENTS', '<div>&nbsp;Traduction assermentée de jugements et décisions judiciaires. Reconnue pour les procédures administratives, familiales et juridiques à l\'étranger.&nbsp;</div>', 'Document', 37, 1, 'jugement-1781615952.jpg'),
(16, 'ASSIGNATIONS', '<div>&nbsp;Traduction certifiée d\'assignations, actes de procédure et documents judiciaires. Acceptée par les tribunaux, avocats et administrations compétentes.&nbsp;</div>', 'Document', 28, 1, 'assign-1781616409.png'),
(17, 'BILANS COMPTABLES', '<div>&nbsp;Traduction spécialisée de bilans financiers et comptables. Adaptée aux besoins des entreprises, investisseurs et organismes de contrôle internationaux.&nbsp;</div>', 'Document', 28, 1, 'bilan-1781615372.png'),
(18, 'RAPPORTS', '<div>&nbsp;Traduction de rapports d\'activité, rapports financiers, audits et études professionnelles. Réalisée avec rigueur et terminologie sectorielle appropriée.&nbsp;</div>', 'Document', 28, 1, 'rapports-1781615607.png'),
(19, 'LIASSES FISCALES', '<div>&nbsp;Traduction de liasses fiscales et documents déclaratifs destinés aux administrations, partenaires financiers et organismes internationaux. Conforme aux standards comptables et fiscaux.&nbsp;</div>', 'Document', 28, 1, 'liasses-fiscales-1781615531.png'),
(20, 'ACTE DE DÉCÈS', '<div>Document officiel délivré par une autorité administrative attestant le décès d’une personne. Il précise l’identité du défunt, la date, l’heure et le lieu du décès, ainsi que les informations d’état civil nécessaires aux démarches administratives, juridiques et successorales. Ce document est souvent requis pour les procédures de succession, la résiliation de contrats, les formalités bancaires et diverses démarches auprès des administrations nationales et internationales.<br><br></div>', 'Document', 32, 1, 'dec-1782392981.jpg');

-- --------------------------------------------------------

--
-- Structure de la table `messenger_messages`
--

CREATE TABLE `messenger_messages` (
  `id` bigint(20) NOT NULL,
  `body` longtext NOT NULL,
  `headers` longtext NOT NULL,
  `queue_name` varchar(190) NOT NULL,
  `created_at` datetime NOT NULL,
  `available_at` datetime NOT NULL,
  `delivered_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `messenger_messages`
--

INSERT INTO `messenger_messages` (`id`, `body`, `headers`, `queue_name`, `created_at`, `available_at`, `delivered_at`) VALUES
(1, 'O:36:\\\"Symfony\\\\Component\\\\Messenger\\\\Envelope\\\":2:{s:44:\\\"\\0Symfony\\\\Component\\\\Messenger\\\\Envelope\\0stamps\\\";a:1:{s:46:\\\"Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\\";a:1:{i:0;O:46:\\\"Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\\":1:{s:55:\\\"\\0Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\0busName\\\";s:21:\\\"messenger.bus.default\\\";}}}s:45:\\\"\\0Symfony\\\\Component\\\\Messenger\\\\Envelope\\0message\\\";O:51:\\\"Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\\":2:{s:60:\\\"\\0Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\0message\\\";O:28:\\\"Symfony\\\\Component\\\\Mime\\\\Email\\\":6:{i:0;N;i:1;N;i:2;s:637:\\\"\n                    <h2>Nouveau message</h2>\n                    <p><strong>Nom :</strong> Daydou</p>\n                    <p><strong>Prénom :</strong> Jean</p>\n                    <p><strong>Email :</strong> daydoujean@gmail.com</p>\n                    <p><strong>Téléphone :</strong> </p>\n                    <p><strong>Message :</strong><br>Type de document : Diplôme / relevé de notes\r\nLangue souhaitée : Français vers Anglais\r\n\r\nBonjour, \r\n\r\nIl s\\\'agit de la confirmation de réussite du passage du Diplome National d\\\'Art. Une page. \r\n\r\n</p>\n                    <p><strong>Date :</strong> 26/06/2026 15:39</p>\n                \\\";i:3;s:5:\\\"utf-8\\\";i:4;a:0:{}i:5;a:2:{i:0;O:37:\\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\\":2:{s:46:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\0headers\\\";a:4:{s:4:\\\"from\\\";a:1:{i:0;O:47:\\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\\":5:{s:50:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\\";s:4:\\\"From\\\";s:56:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\\";i:76;s:50:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\\";N;s:53:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\\";s:5:\\\"utf-8\\\";s:58:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\0addresses\\\";a:1:{i:0;O:30:\\\"Symfony\\\\Component\\\\Mime\\\\Address\\\":2:{s:39:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0address\\\";s:30:\\\"contact@traductions-legales.fr\\\";s:36:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0name\\\";s:18:\\\"Traduction Légale\\\";}}}}s:2:\\\"to\\\";a:1:{i:0;O:47:\\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\\":5:{s:50:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\\";s:2:\\\"To\\\";s:56:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\\";i:76;s:50:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\\";N;s:53:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\\";s:5:\\\"utf-8\\\";s:58:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\0addresses\\\";a:1:{i:0;O:30:\\\"Symfony\\\\Component\\\\Mime\\\\Address\\\":2:{s:39:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0address\\\";s:30:\\\"contact@traductions-legales.fr\\\";s:36:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0name\\\";s:0:\\\"\\\";}}}}s:8:\\\"reply-to\\\";a:1:{i:0;O:47:\\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\\":5:{s:50:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\\";s:8:\\\"Reply-To\\\";s:56:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\\";i:76;s:50:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\\";N;s:53:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\\";s:5:\\\"utf-8\\\";s:58:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\0addresses\\\";a:1:{i:0;O:30:\\\"Symfony\\\\Component\\\\Mime\\\\Address\\\":2:{s:39:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0address\\\";s:20:\\\"daydoujean@gmail.com\\\";s:36:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0name\\\";s:0:\\\"\\\";}}}}s:7:\\\"subject\\\";a:1:{i:0;O:48:\\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\UnstructuredHeader\\\":5:{s:50:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\\";s:7:\\\"Subject\\\";s:56:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\\";i:76;s:50:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\\";N;s:53:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\\";s:5:\\\"utf-8\\\";s:55:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\UnstructuredHeader\\0value\\\";s:49:\\\"Nouveau message de contact — Traduction Légale\\\";}}}s:49:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\0lineLength\\\";i:76;}i:1;N;}}s:61:\\\"\\0Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\0envelope\\\";N;}}', '[]', 'default', '2026-06-26 13:39:22', '2026-06-26 13:39:22', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `product`
--

CREATE TABLE `product` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `reference` varchar(100) DEFAULT NULL,
  `type` varchar(100) NOT NULL,
  `description` longtext DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `issued_at` date DEFAULT NULL,
  `valid_until` date DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `document_name` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `translation_rate`
--

CREATE TABLE `translation_rate` (
  `id` int(11) NOT NULL,
  `language` varchar(80) NOT NULL,
  `price` int(11) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `document_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `app_order`
--
ALTER TABLE `app_order`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_23FA1E55A76ED395` (`user_id`);

--
-- Index pour la table `app_order_item`
--
ALTER TABLE `app_order_item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_4F1B4758D9F6D38` (`order_id`);

--
-- Index pour la table `app_user`
--
ALTER TABLE `app_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_88BDF3E9E7927C74` (`email`);

--
-- Index pour la table `article`
--
ALTER TABLE `article`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_23A0E66989D9B62` (`slug`),
  ADD KEY `IDX_23A0E6612469DE2` (`category_id`);

--
-- Index pour la table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `client_document`
--
ALTER TABLE `client_document`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_F68FBAB3A76ED395` (`user_id`),
  ADD KEY `IDX_F68FBAB3C33F7837` (`document_id`),
  ADD KEY `IDX_F68FBAB38D9F6D38` (`order_id`);

--
-- Index pour la table `contact`
--
ALTER TABLE `contact`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `doctrine_migration_versions`
--
ALTER TABLE `doctrine_migration_versions`
  ADD PRIMARY KEY (`version`);

--
-- Index pour la table `document`
--
ALTER TABLE `document`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `messenger_messages`
--
ALTER TABLE `messenger_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_75EA56E0FB7336F0E3BD61CE16BA31DBBF396750` (`queue_name`,`available_at`,`delivered_at`,`id`);

--
-- Index pour la table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `translation_rate`
--
ALTER TABLE `translation_rate`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_F2CE9CA2C33F7837` (`document_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `app_order`
--
ALTER TABLE `app_order`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT pour la table `app_order_item`
--
ALTER TABLE `app_order_item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT pour la table `app_user`
--
ALTER TABLE `app_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `article`
--
ALTER TABLE `article`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `category`
--
ALTER TABLE `category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `client_document`
--
ALTER TABLE `client_document`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT pour la table `contact`
--
ALTER TABLE `contact`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `document`
--
ALTER TABLE `document`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT pour la table `messenger_messages`
--
ALTER TABLE `messenger_messages`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `product`
--
ALTER TABLE `product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `translation_rate`
--
ALTER TABLE `translation_rate`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `app_order`
--
ALTER TABLE `app_order`
  ADD CONSTRAINT `FK_23FA1E55A76ED395` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`);

--
-- Contraintes pour la table `app_order_item`
--
ALTER TABLE `app_order_item`
  ADD CONSTRAINT `FK_4F1B4758D9F6D38` FOREIGN KEY (`order_id`) REFERENCES `app_order` (`id`);

--
-- Contraintes pour la table `article`
--
ALTER TABLE `article`
  ADD CONSTRAINT `FK_23A0E6612469DE2` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`);

--
-- Contraintes pour la table `client_document`
--
ALTER TABLE `client_document`
  ADD CONSTRAINT `FK_F68FBAB38D9F6D38` FOREIGN KEY (`order_id`) REFERENCES `app_order` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_F68FBAB3A76ED395` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_F68FBAB3C33F7837` FOREIGN KEY (`document_id`) REFERENCES `document` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `translation_rate`
--
ALTER TABLE `translation_rate`
  ADD CONSTRAINT `FK_F2CE9CA2C33F7837` FOREIGN KEY (`document_id`) REFERENCES `document` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
