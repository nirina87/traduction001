-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : lun. 13 juil. 2026 à 11:53
-- Version du serveur : 11.4.12-MariaDB
-- Version de PHP : 8.4.22

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
(13, 36.00, 'EUR', 'pending', 'cs_live_a1a4Q3sz47wf36z6CCQDCHgkCaMUk0p0ohs1F9YmB4VqPgs3Ahb5HmBwDj', 'FACT-20260627-7030', '2026-06-27 11:47:39', 7),
(14, 58.00, 'EUR', 'paid', 'cs_live_b1AifNBRuWhmAK1JNkK5icZXR4P0g72f0pdqPhl55OOqSJcCP3IXrYD057', 'FACT-20260629-3508', '2026-06-29 15:44:16', 8),
(15, 28.00, 'EUR', 'paid', 'cs_live_a1adgzsciW7n2M6dJhx7uKvv6Xs0jfWj5D4kjZgOUSs2fXulHR3NwP3ML2', 'FACT-20260629-7592', '2026-06-29 19:14:33', 9),
(16, 84.00, 'EUR', 'paid', 'cs_live_b18wcob3DYtbkI10z7oxcjsSdTQ4GTh9ZeFKRgYu1oT749fmce00AZNXKx', 'FACT-20260629-5456', '2026-06-29 21:53:00', 10),
(17, 28.00, 'EUR', 'paid', 'cs_live_a1vc6nbP4AV35cbneMd4o5bMAHLr6bf1XCcLO3P7FB1YDv1dCVBau4zpd8', 'FACT-20260630-8501', '2026-06-30 17:35:19', 11),
(18, 28.00, 'EUR', 'paid', 'cs_live_a15UUTzVNOcyBi209EmYLHw7BMmhG3cwtgn0UuUeakUOQeLpqH0ILqg3yx', 'FACT-20260702-6734', '2026-07-02 05:40:54', 12),
(19, 435.00, 'EUR', 'pending', 'cs_live_b1iVRvAcFWOzT6ijjVi34i2YEKqzT7Ct8XdwAvZFY5YOURXdyuvCFV7L3I', 'FACT-20260702-7649', '2026-07-02 17:45:54', 13),
(20, 28.00, 'EUR', 'paid', 'cs_live_a1XuDvGvh0s5hZ7wwerlURJy5Y8FJJd4ADitPorSjpjwd5dsvE3ufEEJWv', 'FACT-20260702-3541', '2026-07-02 17:46:37', 12),
(21, 28.00, 'EUR', 'paid', 'cs_live_a1eS08aK4hTMBfZEeBZtEfKx0XBokCcJg2zkuTqLlcYvBXVWwiFbZRduAr', 'FACT-20260703-3427', '2026-07-03 10:46:41', 14),
(22, 435.00, 'EUR', 'pending', 'cs_live_b11YnxuB2wzAQkNfLrw31PEL4tHIvWUVfREt7XmHBOFXA62ha2R1O9cNcr', 'FACT-20260703-5049', '2026-07-03 14:56:26', 13),
(23, 435.00, 'EUR', 'pending', 'cs_live_b1cIDbs0CbFcjn0JdfLbb7e0kaudFrYjnVT2eGwV7nXe22txftrD7SbQxH', 'FACT-20260703-1960', '2026-07-03 15:58:48', 13),
(24, 435.00, 'EUR', 'pending', 'cs_live_b1WPKS9X8QiVO2NkV9O2kVLuDyuNe5oVW5SlQ3nswsWWfZIcizIU12UQ6d', 'FACT-20260703-8561', '2026-07-03 16:08:02', 13),
(25, 435.00, 'EUR', 'paid', 'cs_live_b1AbAGSZ3PvVzd60CMAB8EFd12uu5Y7Morl77VnCU9W9jTOHnciEr2aOPi', 'FACT-20260703-6099', '2026-07-03 16:17:56', 13),
(26, 450.00, 'EUR', 'paid', NULL, 'FACT-20260703-4505', '2026-07-03 17:26:45', 13),
(27, 450.00, 'EUR', 'paid', NULL, 'FACT-20260703-1672', '2026-07-03 18:21:46', 13),
(28, 37.00, 'EUR', 'paid', 'cs_live_a1xH1VvvNkhArIhIPY9K7sGrCS58GPodYX7KbFfNxOTtD7yfd2mOgxxLMH', 'FACT-20260703-3619', '2026-07-03 22:09:03', 15),
(29, 141.00, 'EUR', 'pending', 'cs_live_b1qWqbKvmnBCbrCzXAkkGEXkvolVg2u6hn0ktkVruiirrHWzJsQVEWicXr', 'FACT-20260705-7306', '2026-07-05 12:56:11', 7),
(30, 90.00, 'EUR', 'paid', 'cs_live_a14UnOriBLTB2MW06tNy7Ez6JbBurd2mpPu5VtpDuJ6yUhO9PFsIkzPdZv', 'FACT-20260706-8995', '2026-07-06 11:09:29', 16),
(31, 111.00, 'EUR', 'paid', 'cs_live_a1b7eWh2gf248KwIq9lrIpeWU1SxpIo7KBnfZpKP97CgtRxGUbGj604dzU', 'FACT-20260707-6835', '2026-07-07 11:22:06', 17),
(32, 43.00, 'EUR', 'paid', 'cs_live_b1AzZiNbthykRABFanPrTjnTQweTDx1a4Dba6NzE59KftGefXiQIW5iLtT', 'FACT-20260707-2761', '2026-07-07 17:52:00', 18),
(33, 56.00, 'EUR', 'paid', 'cs_live_a1XR7MalPNpe3gR9gx6i3l15jZwpABCu0rXPmbtn1aAnBbv4xl4jpKZF6l', 'FACT-20260708-7109', '2026-07-08 09:34:02', 19),
(34, 204.00, 'EUR', 'paid', 'cs_live_a1qQQlAN7XvhPU84GhSf3LA0i3Qc4hfacMVvyPIdeVILPrGkhrRadgt53Z', 'FACT-20260708-9932', '2026-07-08 10:49:59', 20),
(35, 150.00, 'EUR', 'paid', 'cs_live_b1CbVbVnXdPRgZuTNe6kdqhr8Ug7HyYnDdpMWjKw9AgSeaKoC4ucA1UM0B', 'FACT-20260708-5748', '2026-07-08 16:34:25', 21),
(36, 30.00, 'EUR', 'paid', 'cs_live_a1Ses2c0uFnbrRMQvgMAOaIacDYLR3qcKYjFp7U225GcAtLHaP6bb7ekDd', 'FACT-20260709-5322', '2026-07-09 10:27:24', 22),
(37, 30.00, 'EUR', 'paid', NULL, 'FACT-20260709-8664', '2026-07-09 10:50:30', 22),
(38, 45.00, 'EUR', 'paid', 'cs_live_a1i98hQIFU0KPHawcMD1r07wGp2SvEzpxpV7BKEtGqLwIURkFphwPmD6AC', 'FACT-20260709-4941', '2026-07-09 15:28:39', 23),
(39, 28.00, 'EUR', 'paid', 'cs_live_a1bkO53hJmAPsiyVDVdqhLh47SABG8bq2pBZMl0ygKofF1Iyp6oSi8wmrB', 'FACT-20260709-8088', '2026-07-09 16:29:32', 24),
(40, 28.00, 'EUR', 'paid', 'cs_live_a1FTgyHrXHi8ld4DkoYOTCaFnWLo6wh3rNVWakUgIC0yaLEkNCbzvwGkcN', 'FACT-20260709-5495', '2026-07-09 16:39:40', 24),
(41, 47.00, 'EUR', 'paid', 'cs_live_b1ZDH4nL6sX6vTNOZaTsu5obWlpPrVnwfx0JpUTGIRXCnjeGE0x4s8VdAr', 'FACT-20260709-3362', '2026-07-09 18:16:19', 7),
(42, 30.00, 'EUR', 'paid', 'cs_live_a1ir9XLl46BavGMJJnBuMXHHus7pxCFmBXEmuuEtZGb0YLACqm1F4F9P12', 'FACT-20260709-1353', '2026-07-09 22:43:10', 25),
(43, 30.00, 'EUR', 'paid', 'cs_live_a1kxwniG9PwbJmNpWWYGxkdIZtgNsGI2iPHXOhUw5eZo4OnKkodo6a0X9G', 'FACT-20260710-7577', '2026-07-10 17:21:56', 26),
(44, 56.00, 'EUR', 'paid', 'cs_live_b1HqNwMnUpAu2t0ikvUNb3nzqRpOWbUZEqcuPZMh4ZeV60VUck8a401CtG', 'FACT-20260711-5894', '2026-07-11 21:33:32', 27),
(45, 42.00, 'EUR', 'pending', 'cs_live_a1nofltSWqVdNvvJpLO5un40OmP4MgaA5Ru7XA2XqLWGX5t3ydRHiThlOx', 'FACT-20260712-3752', '2026-07-12 15:33:51', 7),
(46, 57.00, 'EUR', 'pending', 'cs_live_b1mcXya6t1s2hxUjevzEDTW1UdcWFNwWkpSDWJhwMzDeoIRS9m7DLoFRLv', 'FACT-20260712-3803', '2026-07-12 15:36:16', 7),
(47, 57.00, 'EUR', 'paid', NULL, 'FACT-20260712-9467', '2026-07-12 15:54:48', 7);

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
(13, 19, 'MARIAGE.png', 'ACTE DE MARIAGE — traduction Français vers Italien — 1 page', 1, 36.00, 36.00, 13),
(14, 22, 'CamScanner 29-06-2026 14.25_1.jpeg', 'ACTE DE NAISSANCE — traduction Français vers Allemand — 1 page', 1, 30.00, 30.00, 14),
(15, 23, 'CamScanner 29-06-2026 14.25_2.jpeg', 'DIPLÔMES — traduction Français vers Allemand — 1 page', 1, 28.00, 28.00, 14),
(16, 24, 'att.xXX2FM5PMXedyTX0NbmVqaS8YzqFBb4YS29P99HT7Wc.pdf', 'PASSEPORT — traduction Anglais vers Français — 1 page', 1, 28.00, 28.00, 15),
(17, 25, '1er anneé.pdf', 'DIPLÔMES — traduction Arabe vers Français — 1 page', 1, 28.00, 28.00, 16),
(18, 26, '2 ème anneé.pdf', 'DIPLÔMES — traduction Arabe vers Français — 1 page', 1, 28.00, 28.00, 16),
(19, 27, '3ème année.pdf', 'DIPLÔMES — traduction Arabe vers Français — 1 page', 1, 28.00, 28.00, 16),
(20, 28, 'daydou_jean_attestation_diplome.pdf', 'DIPLÔMES — traduction Anglais vers Français — 1 page', 1, 28.00, 28.00, 17),
(21, 30, 'permis pdf.pdf.pdf', 'PERMIS DE CONDUIRE — traduction Arabe vers Français — 1 page', 1, 28.00, 28.00, 18),
(22, 31, 'Assignation HABIBULLAH à traduire.pdf', 'ASSIGNATIONS — traduction Français vers Anglais — 15 pages — réception par papier', 15, 28.00, 435.00, 19),
(23, 32, 'permis pdf.pdf.pdf', 'PERMIS DE CONDUIRE — traduction Arabe vers Français — 1 page', 1, 28.00, 28.00, 20),
(24, 33, 'Diplome BAC__Victorien_Cambourian__juin 2021.pdf', 'DIPLÔMES — traduction Français vers Anglais — 1 page', 1, 28.00, 28.00, 21),
(25, 34, 'Assignation HABIBULLAH à traduire.pdf', 'CERTIFICATS — traduction Français vers Anglais — 15 pages — réception par papier', 15, 28.00, 435.00, 22),
(26, 34, 'Assignation HABIBULLAH à traduire.pdf', 'CERTIFICATS — traduction Français vers Anglais — 15 pages — réception par papier', 15, 28.00, 435.00, 23),
(27, 34, 'Assignation HABIBULLAH à traduire.pdf', 'CERTIFICATS — traduction Français vers Anglais — 15 pages — réception par papier', 15, 28.00, 435.00, 24),
(28, 34, 'Assignation HABIBULLAH à traduire.pdf', 'CERTIFICATS — traduction Français vers Anglais — 15 pages — réception par papier', 15, 28.00, 435.00, 25),
(29, 37, 'jugement de divorce  (1).pdf', 'JUGEMENTS — traduction Arabe vers Français — 1 page', 1, 37.00, 37.00, 28),
(30, 38, 'TEST_ACTE-MARIAGE.png', 'ACTE DE MARIAGE — traduction Albanais vers Français — 3 pages — réception par papier', 3, 42.00, 141.00, 29),
(31, 40, 'DOC060726-06072026110304.pdf', 'ACTE DE NAISSANCE — traduction Italien vers Français — 3 pages', 3, 30.00, 90.00, 30),
(32, 42, 'Dossier Amar SADADOU (1).pdf', 'JUGEMENTS — traduction Arabe vers Français — 3 pages', 3, 37.00, 111.00, 31),
(33, 43, 'Releve_de_Notes_224840035000005.pdf', 'RELEVÉS DE NOTES — traduction Français vers Anglais — 1 page — réception par papier', 1, 28.00, 43.00, 32),
(34, 44, 'Kbis dernière version.pdf', 'EXTRAITS KBIS — traduction Français vers Anglais — 2 pages', 2, 28.00, 56.00, 33),
(35, 46, 'carte-grise-tcheque.pdf', 'ATTESTATIONS — traduction Tchèque vers Français — 6 pages', 6, 34.00, 204.00, 34),
(36, 48, 'Certificat celibat.pdf', 'ACTE DE NAISSANCE — traduction Thaïlandais vers Français — 3 pages — réception par papier', 3, 45.00, 150.00, 35),
(37, 49, '20260709_005259.jpg', 'ACTE DE NAISSANCE — traduction Arabe vers Français — 1 page', 1, 30.00, 30.00, 36),
(38, 53, '20260605_155339.jpg', 'ACTE DE NAISSANCE — traduction Thaïlandais vers Français — 1 page', 1, 45.00, 45.00, 38),
(39, 54, 'Releve_de_Notes_Boyer LORENA.pdf', 'RELEVÉS DE NOTES — traduction Français vers Italien — 1 page', 1, 28.00, 28.00, 39),
(40, 55, 'Releve_de_Notes_Boyer LORENA.pdf', 'RELEVÉS DE NOTES — traduction Français vers Italien — 1 page', 1, 28.00, 28.00, 40),
(41, 56, 'DOC.png', 'CASIERS JUDICIAIRES — traduction Français vers Arabe — 1 page — réception par papier', 1, 32.00, 47.00, 41),
(42, 58, 'شهادة الميلاد_1783618298319.pdf', 'ACTE DE NAISSANCE — traduction Arabe vers Français — 1 page', 1, 30.00, 30.00, 42),
(43, 59, ', ADEN BOEVET OSAGIE.pdf', 'ACTE DE NAISSANCE — traduction Anglais vers Français — 1 page', 1, 30.00, 30.00, 43),
(44, 60, 'IMG_9311.jpeg', 'PERMIS DE CONDUIRE — traduction Français vers Anglais — 1 page', 1, 28.00, 28.00, 44),
(45, 61, 'IMG_9312.jpeg', 'PERMIS DE CONDUIRE — traduction Français vers Anglais — 1 page', 1, 28.00, 28.00, 44),
(46, 63, 'ACTE.png', 'ACTE DE MARIAGE — traduction Français vers Néerlandais — 1 page', 1, 42.00, 42.00, 45),
(47, 64, 'ACTE.png', 'ACTE DE MARIAGE — traduction Français vers Néerlandais — 1 page — réception par papier', 1, 42.00, 57.00, 46);

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
(7, 'franckieandriamalala@gmail.com', '[\"ROLE_USER\"]', '$2y$13$YeBDgt8VQo5LX3O7wwEUxOwfJnNFUy2nZWPYjqBeIsK4ND0S0v/aq', 'FRANCKIE', 'ANTONNIO', 'EASY TECHNOLOGY', '06 12 16 09 02', '2026-06-23 11:11:46'),
(8, 'lixxystar@live.fr', '[\"ROLE_USER\"]', '$2y$13$R06Wj6ti2PEJAuVeiQjwfeLu3Fx8ygtoWQYZcG0Ai8eVRgnJkVPZG', 'Lucienne', 'Fouda', '', '613363843', '2026-06-29 15:44:09'),
(9, 'abidi.souhir92@gmail.com', '[\"ROLE_USER\"]', '$2y$13$PXe4O15BccV3kTu6PzRa3uyr2iEP6Dm3BtWAH3usDi8i/Yu8Ek7FO', 'Souhir', 'Abidi', 'CHU de Lille', '0676411852', '2026-06-29 19:14:17'),
(10, 'asmarafraf86@gmail.com', '[\"ROLE_USER\"]', '$2y$13$EbHNqhWJ.MLl4XbwkS8UnOTWMH1VlS68NKCYjhW4ZemmZ9zVgHnxa', 'Asma', 'RAFRAF', '', '0605583664', '2026-06-29 21:52:39'),
(11, 'daydoujean@gmail.com', '[\"ROLE_USER\"]', '$2y$13$j8iv4Tqwjpk7rQuI4J/FB.ggfjXCZTbcBbIecBFmwVED2NQ1luBu6', 'Jean', 'Daydou', '', '', '2026-06-30 17:35:16'),
(12, 'maleklatrous99@gmail.com', '[\"ROLE_USER\"]', '$2y$13$llJkkXOEwc.TyyYUjCiE5e6hVOX1UC.2v/Rz9kagtcooXVhFRvvfm', 'Abdelmalek', 'Latrous', '', '+33766839189', '2026-07-02 05:40:30'),
(13, 'habi41@yahoo.fr', '[\"ROLE_USER\"]', '$2y$13$CA8oCd1lMzQxUq1k/a7MvuQ9dBS2GEc0Umrmsn6HPJjowM7mS2tRi', 'Naouchatebe', 'HABIBULLAH', '', '+33695526061', '2026-07-02 17:45:02'),
(14, 'vic.cambourian@gmail.com', '[\"ROLE_USER\"]', '$2y$13$TvERhg76rO0kcyTRKOBXD./oU.nnqBsP1XRpl1qongfDjixdK3/BW', 'Pierre', 'Cambourian', '', '06.60.98.35.53', '2026-07-03 10:46:25'),
(15, 'farouk.boudra1970@gmail.com', '[\"ROLE_USER\"]', '$2y$13$TuXSIoCfF4XVvhtYkBdrVO4yLSinKxs2Bk/a6LwPWBIyocKKJ69FG', 'Farouk', 'Boudra', '', '0650013686', '2026-07-03 22:08:15'),
(16, 'ndobozendi@lelien.app', '[\"ROLE_USER\"]', '$2y$13$jvygtt3CR0TfRwpHAulTOuYbDqgn3jVpGNhQn5d7MFMbmm3.6sZ3.', 'KANKOE', 'AYI', 'ayi kankoe', '+33631092752', '2026-07-06 11:08:58'),
(17, 'nasritakicom@gmail.com', '[\"ROLE_USER\"]', '$2y$13$kNv55KCJpD..TRyU9dwHIOulhDOH1DZ4lwhJy3epTCXPlZIM0RiHG', 'Taki Eddine', 'NASRI', '', '+33758263087', '2026-07-07 11:21:43'),
(18, 'laura.petiot@gmail.com', '[\"ROLE_USER\"]', '$2y$13$lJ6fYUvMd7UqQWxo7WhZX.tM.tWah0bvjm5uwQN60LgA15CT0Hmu6', 'Laura', 'Niel', '', '0699086190', '2026-07-07 17:51:19'),
(19, 'mcclaquin@lescce.org', '[\"ROLE_USER\"]', '$2y$13$CdZ73Mt4TX/.zC1kdv1GKudIkGtdT317CyPjMjtnOgIiCXTNob0b6', 'Marie-christine', 'CLAQUIN', 'CCE COMMUNICATION', '0788941761', '2026-07-08 09:33:52'),
(20, 'emeltopal5@gmail.com', '[\"ROLE_USER\"]', '$2y$13$JX0p1GrXjsB3ev1r/kABaOnhyE15nZakKDHTTIQl6QQ4/ij4yTXTS', 'Emel', 'Topal', '', '0660835179', '2026-07-08 10:49:54'),
(21, 'contactlejackpot@gmail.com', '[\"ROLE_USER\"]', '$2y$13$sHL8VdPsvcNdZN/2EQxbfugP4CuwWLEHz.9mdQdbKRRcuCs.nTCVG', 'Patrice', 'VIANO', '', '0623274243', '2026-07-08 16:34:20'),
(22, 'bouhenafkhadra13@gmail.com', '[\"ROLE_USER\"]', '$2y$13$P0SsMJyOgzqzCLEdXAq/a.tOki6s8oDlLkOMw6HsKftsA3G6/gBQa', 'Khadra', 'Bouhenaf', 'Presidente dassociations', '+33681369724', '2026-07-09 10:24:29'),
(23, 'farkilsung6@gmail.com', '[\"ROLE_USER\"]', '$2y$13$YelG/t6kyM4nUlcJep1BhO1r5ZhLVwmkasb3Ael/qT7VRlPctUQCi', 'Farkil', 'Sung', 'Farkil Sung', '', '2026-07-09 15:28:34'),
(24, 'yanboyer@gmail.com', '[\"ROLE_USER\"]', '$2y$13$zGi7ZQe7qU/lVwbd7cNV3OuEUjjU.Qoyw2HtkEMI.bMAz/rMtlJpi', 'Yannick', 'BOYER', '', '+262692516129', '2026-07-09 16:29:26'),
(25, 'Elhadjbelbey@gmail.com', '[\"ROLE_USER\"]', '$2y$13$QhyWhHtCX2GpBBXk1dp3s.dhXVgq/hCl.klui7fvzFsBoHJhJ/lMu', 'Elhadj', 'Belbey', '', '0659787480', '2026-07-09 22:42:13'),
(26, 'emotan89@gmail.com', '[\"ROLE_USER\"]', '$2y$13$ZjdYlenWUUc7Vl04tLrKzeenFilABmM0so7W12Dy/AtIDNuclSLZe', 'Aden Boevet', 'Osagie', '', '0748669891', '2026-07-10 17:21:41'),
(27, 'evaferriol@sfr.fr', '[\"ROLE_USER\"]', '$2y$13$zdRP0DPvoQAWYHqutecZSeIYf.ENH6eJ.xfBcVWb9DPLc77xPT75i', 'Eva', 'Ferriol', '', '+33626890855', '2026-07-11 21:33:19'),
(28, 'kmcom20@yahoo.fr', '[\"ROLE_USER\"]', '$2y$13$aJcMZ16Lv39Y9mogcH/4Xe0MMmpDM/Qa/y.meXW7u8ybRmmdO5v5u', 'mo', 'lo', NULL, '0606060606', '2026-07-12 17:34:45'),
(29, 'inanc93700@gmail.com', '[\"ROLE_USER\"]', '$2y$13$q3ZCh66xnW5UNcI9ZwpeVO5uIeFKJ7Iqt1/NEN3ch4WbyQExjGqfK', 'Denis', 'Kutlu', 'TEST', '0658622465', '2026-07-12 20:10:32');

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
  `order_id` int(11) DEFAULT NULL,
  `page_count` int(11) NOT NULL DEFAULT 1,
  `status` varchar(30) NOT NULL DEFAULT 'unpaid',
  `document_traduit` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `page_after_translation` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `client_document`
--

INSERT INTO `client_document` (`id`, `title`, `language`, `price`, `file_name`, `uploaded_at`, `user_id`, `document_id`, `receive_by_paper`, `order_id`, `page_count`, `status`, `document_traduit`, `updated_at`, `page_after_translation`) VALUES
(20, 'Fichier_01.pdf', 'Français vers Russe', 4700, 'fichier-01-6a414bdd05b6b203227448.pdf', '2026-06-28 18:29:17', NULL, 20, 1, NULL, 1, 'unpaid', NULL, NULL, 1),
(21, 'Fichier_01.pdf', 'Français vers Russe', 7900, 'fichier-01-6a414c8c10ff9953530427.pdf', '2026-06-28 18:32:12', NULL, 20, 1, NULL, 1, 'unpaid', NULL, NULL, 1),
(22, 'CamScanner 29-06-2026 14.25_1.jpeg', 'Français vers Allemand', 3000, 'camscanner-29-06-2026-14-25-1-6a4276593f0ae383698656.jpg', '2026-06-29 15:42:49', 8, 1, 0, 14, 1, 'delivered', NULL, NULL, 1),
(23, 'CamScanner 29-06-2026 14.25_2.jpeg', 'Français vers Allemand', 2800, 'camscanner-29-06-2026-14-25-2-6a42767bf09ac659406872.jpg', '2026-06-29 15:43:23', 8, 3, 0, 14, 1, 'delivered', NULL, NULL, 1),
(24, 'att.xXX2FM5PMXedyTX0NbmVqaS8YzqFBb4YS29P99HT7Wc.pdf', 'Anglais vers Français', 2800, 'att-xxx2fm5pmxedytx0nbmvqas8yzqfbb4ys29p99ht7wc-6a42a7b200f94091517999.pdf', '2026-06-29 19:13:22', 9, 21, 0, 15, 1, 'delivered', NULL, NULL, 1),
(25, '1er anneé.pdf', 'Arabe vers Français', 2800, '1er-annee-6a42cbcd32c00848067632.pdf', '2026-06-29 21:47:25', 10, 3, 0, 16, 1, 'delivered', NULL, NULL, 1),
(26, '2 ème anneé.pdf', 'Arabe vers Français', 2800, '2-eme-annee-6a42cc1fbf940034096898.pdf', '2026-06-29 21:48:47', 10, 3, 0, 16, 1, 'delivered', NULL, NULL, 1),
(27, '3ème année.pdf', 'Arabe vers Français', 2800, '3eme-annee-6a42cc337a2c2937621793.pdf', '2026-06-29 21:49:07', 10, 3, 0, 16, 1, 'delivered', NULL, NULL, 1),
(28, 'daydou_jean_attestation_diplome.pdf', 'Anglais vers Français', 2800, 'daydou-jean-attestation-diplome-6a43e21261b87632352419.pdf', '2026-06-30 17:34:42', 11, 3, 0, 17, 1, 'delivered', NULL, NULL, 1),
(29, '17829196681308387165933507465772.jpg', 'Français vers Espagnol', 3200, '17829196681308387165933507465772-6a45326b81164841994659.jpg', '2026-07-01 17:29:47', NULL, 20, 0, NULL, 1, 'unpaid', NULL, NULL, 1),
(30, 'permis pdf.pdf.pdf', 'Arabe vers Français', 2800, 'permis-pdf-pdf-6a45dd84bb725866409106.pdf', '2026-07-02 05:39:48', 12, 8, 0, 18, 1, 'delivered', NULL, NULL, 1),
(32, 'permis pdf.pdf.pdf', 'Arabe vers Français', 2800, 'permis-pdf-pdf-6a4687a681a2b307864595.pdf', '2026-07-02 17:45:42', 12, 8, 0, 20, 1, 'delivered', NULL, NULL, 1),
(33, 'Diplome BAC__Victorien_Cambourian__juin 2021.pdf', 'Français vers Anglais', 2800, 'diplome-bac-victorien-cambourian-juin-2021-6a477684433d5258171497.pdf', '2026-07-03 10:44:52', 14, 3, 0, 21, 1, 'delivered', NULL, NULL, 1),
(35, 'Assignation HABIBULLAH à traduire.pdf', 'Français vers Anglais', 43500, 'assignation-habibullah-a-traduire-6a47bfeb6845c912231571.pdf', '2026-07-03 15:58:03', 13, 16, 1, 27, 1, 'delivered', NULL, NULL, 1),
(37, 'jugement de divorce  (1).pdf', 'Arabe vers Français', 3700, 'jugement-de-divorce-1-6a48163ad6c4e007050565.pdf', '2026-07-03 22:06:18', 15, 15, 0, 28, 1, 'delivered', NULL, NULL, 1),
(40, 'DOC060726-06072026110304.pdf', 'Italien vers Français', 9000, 'doc060726-06072026110304-6a4b6ffd5bbbd097700977.pdf', '2026-07-06 11:06:05', 16, 1, 0, 30, 3, 'delivered', NULL, NULL, 1),
(42, 'Dossier Amar SADADOU (1).pdf', 'Arabe vers Français', 11100, 'dossier-amar-sadadou-1-6a4cc466a6c31444849670.pdf', '2026-07-07 11:18:30', 17, 15, 0, 31, 3, 'delivered', NULL, NULL, 1),
(43, 'Releve_de_Notes_224840035000005.pdf', 'Français vers Anglais', 4300, 'releve-de-notes-224840035000005-6a4d203280065389941910.pdf', '2026-07-07 17:50:10', 18, 5, 1, 32, 1, 'delivered', NULL, NULL, 1),
(44, 'Kbis dernière version.pdf', 'Français vers Anglais', 5600, 'kbis-derniere-version-6a4df9d485380916166157.pdf', '2026-07-08 09:18:44', 19, 10, 0, 33, 2, 'delivered', NULL, NULL, 1),
(46, 'carte-grise-tcheque.pdf', 'Tchèque vers Français', 20400, 'carte-grise-tcheque-6a4e0ecd3090b859617139.pdf', '2026-07-08 10:48:13', 20, 7, 0, 34, 6, 'delivered', NULL, NULL, 1),
(48, 'Certificat celibat.pdf', 'Thaïlandais vers Français', 15000, 'certificat-celibat-6a4e5f4954689077033983.pdf', '2026-07-08 16:31:37', 21, 1, 1, 35, 3, 'delivered', NULL, NULL, 1),
(51, '20260709_101030.jpg', 'Arabe vers Français', 3000, '20260709-101030-6a4f59615eb8e692623377.jpg', '2026-07-09 10:18:41', 22, 1, 0, 37, 1, 'delivered', NULL, NULL, 1),
(53, '20260605_155339.jpg', 'Birman vers Français', 6000, '20260605-155339-6a4fa1815e7e5938636441.jpg', '2026-07-09 15:26:25', 23, 1, 1, 38, 1, 'delivered', NULL, NULL, 1),
(54, 'Releve_de_Notes_Boyer LORENA.pdf', 'Français vers Italien', 2800, 'releve-de-notes-boyer-lorena-6a4fb019a785f267339928.pdf', '2026-07-09 16:28:41', 24, 5, 0, 39, 1, 'delivered', NULL, NULL, 1),
(55, 'Releve_de_Notes_Boyer LORENA.pdf', 'Français vers Italien', 2800, 'releve-de-notes-boyer-lorena-6a4fb29902b67044075886.pdf', '2026-07-09 18:00:42', 24, 5, 0, 40, 1, 'delivered', 'traduzione-it-boyer-completa-6a53a98e83a77798344318.pdf', '2026-07-12 16:49:50', 1),
(58, 'شهادة الميلاد_1783618298319.pdf', 'Arabe vers Français', 3000, 'shhadt-almylad-1783618298319-6a5007cf19284703088976.pdf', '2026-07-09 22:42:55', 25, 1, 0, 42, 1, 'delivered', 'traduction-fr-acte-naissance-belbey-elhadj-1page-6a53a2ed7e414124455346.pdf', '2026-07-12 16:21:33', 1),
(59, ', ADEN BOEVET OSAGIE.pdf', 'Anglais vers Français', 3000, 'aden-boevet-osagie-6a510d1964e36374865926.pdf', '2026-07-12 15:20:29', 26, 1, 0, 43, 1, 'delivered', 'traduction-fr-affidavit-aden-boevet-osagie-signee-6a53949de1f1e581132635.pdf', NULL, 1),
(60, 'IMG_9311.jpeg', 'Français vers Anglais', 2800, 'img-9311-6a5299ab2c688868739162.jpg', '2026-07-11 21:29:47', 27, 8, 0, 44, 1, 'delivered', NULL, '2026-07-12 16:19:01', 1),
(61, 'IMG_9312.jpeg', 'Français vers Anglais', 2800, 'img-9312-6a529a426e8e6212737841.jpg', '2026-07-11 21:32:18', 27, 8, 0, 44, 1, 'delivered', 'traduction-en-permis-courcet-laurent-recto-verso-6a53a9f53fec6074821004.pdf', '2026-07-12 16:51:33', 1);

-- --------------------------------------------------------

--
-- Structure de la table `client_document_payment_link`
--

CREATE TABLE `client_document_payment_link` (
  `id` int(11) NOT NULL,
  `stripe_price_id` varchar(100) NOT NULL,
  `stripe_payment_link_id` varchar(100) NOT NULL,
  `url` varchar(500) NOT NULL,
  `amount_cents` int(11) NOT NULL,
  `currency` varchar(10) NOT NULL DEFAULT 'EUR',
  `created_at` datetime NOT NULL,
  `client_document_id` int(11) NOT NULL,
  `stripe_checkout_session_id` varchar(100) DEFAULT NULL,
  `paid_at` datetime DEFAULT NULL
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
(1, 'Daydou', 'Jean', 'daydoujean@gmail.com', '', 'Type de document : Diplôme / relevé de notes\r\nLangue souhaitée : Français vers Anglais\r\n\r\nBonjour, \r\n\r\nIl s\'agit de la confirmation de réussite du passage du Diplome National d\'Art. Une page. \r\n\r\n', '2026-06-26 15:39:22'),
(3, 'Lucienne', 'Fouda ', 'lixxystar@live.fr', '+33613363843', 'Type de document : Acte d\'état civil\r\nLangue souhaitée : Français vers Allemand\r\n\r\nJ’ai plusieurs documents à faire traduire en allemand, acte de naissance, diplôme aide soignant ', '2026-06-28 06:58:16'),
(4, 'RAFRAF', 'Asma', 'asmarafraf86@gmail.com', '+33605583664', 'Type de document : Diplôme / relevé de notes\r\nLangue souhaitée : Arabe vers Français\r\n\r\nJ\'ai des relevé de notes, je souhaitrais à traduire de Arabe vers français.\r\nS\'il vous plais ?', '2026-06-29 15:30:34'),
(5, 'RAFRAF', 'Asma', 'asmarafraf86@gmail.com', '+33605583664', 'Type de document : Diplôme / relevé de notes\r\nLangue souhaitée : Arabe vers Français\r\n\r\nJ\'ai trois relevé de notes que je souhaitrais à traduire d\'Arabe vers Français.\r\nS\'ils vous plais?', '2026-06-29 15:32:49'),
(6, 'Abidi', 'Souhir', 'abidi.souhir92@gmail.com', '0676411852', 'Type de document : Pièce d\'identité\r\nLangue souhaitée : Anglais vers Français\r\n\r\nTraduction en français de la première page de passeport ', '2026-06-29 17:24:27'),
(7, 'Souhir', 'Abidi', 'abidi.souhir92@gmail.com', '0676411852', 'Type de document : Pièce d\'identité\r\n\r\nBonjour,\r\n\r\nJ’ai besoin d’une traduction assermentée en français de la page d’identité de mon passeport tunisien (écrit en anglais) pour une démarche administrative .\r\n\r\nPourriez-vous me préciser :\r\n\r\n* le délai de réalisation le plus court possible ;\r\n* le tarif ;\r\n* s’il est possible de procéder entièrement à distance (envoi d’un scan du passeport) ;\r\n* si la traduction sera réalisée par un traducteur expert près d’une cour d’appel en France.', '2026-06-29 19:07:50'),
(8, 'EL OUARDI OUADOUD ', 'MOHAMED', 'momo03031964@gmail.com', '0753299029', 'Type de document : Autre document\r\nLangue souhaitée : Français vers Espagnol\r\n\r\nCopie integrale- Acte de décès ', '2026-07-01 17:18:19'),
(9, 'hanna', 'firel', 'firelha@yahoo.fr', '0652468720', 'Type de document : Diplôme / relevé de notes\r\nLangue souhaitée : Français vers Roumain\r\n\r\nBonjour,\r\n\r\nJ\'aimerais faire traduire en roumain les documents suivants :\r\n\r\nMon diplôme du baccalauréat ;\r\nMon relevé de notes du baccalauréat ;\r\nMes relevés de notes du secondaire (de la 9ᵉ à la 12ᵉ/13ᵉ année, selon le système scolaire) ;\r\nMon acte de naissance.\r\n\r\nPourriez-vous me confirmer si vous pouvez effectuer ces traductions, m\'indiquer le délai de réalisation ainsi que le tarif ?\r\n\r\nJe vous remercie par avance pour votre retour.\r\n\r\nCordialement,', '2026-07-01 23:32:42'),
(10, 'Bara', 'Zahir', 'zahir.bara70@gmail.com', '', 'Type de document : Autre document\r\nLangue souhaitée : Arabe vers Français\r\n\r\nPermis de conduire \r\nPlus vite possible ', '2026-07-02 20:16:11'),
(11, 'CARNEIRO', 'Arthur', 'arth93@yahoo.fr', '06 16 81 06 83', 'Type de document : Acte d\'état civil\r\nLangue souhaitée : Français vers Portugais\r\n\r\nBonjour,\r\n\r\nIl faudrait une traduction certifiée en Portugais de mon acte de divorce afin de régulariser ma situation au consulat du Portugal.\r\n\r\nIl y a 9 pages.\r\n\r\nCordialement', '2026-07-03 15:19:02'),
(12, 'Rachdi', 'Mounir', 'mounir-rachdi@outlook.fr', '+33751803425', 'Type de document : Diplôme / relevé de notes\r\nLangue souhaitée : Arabe vers Français', '2026-07-03 20:39:45'),
(13, 'Chevalier', 'Mike', 'mikaelsevres@gmail.com', '0695804184', 'Type de document : Acte d\'état civil\r\nLangue souhaitée : Roumain vers Français\r\n\r\nTranscrire en français l acte de naissance plurilingue pour l administration et ambassade française et a nantes', '2026-07-04 15:23:45'),
(14, 'Gavriloff', 'Alexia', 'alexiagavrilov@gmail.com', '+33633168785', 'Type de document : Autre document\r\nLangue souhaitée : Croate vers Français\r\n\r\nBonjour, \r\n\r\nJe souhaiterais traduire une conversation messenger du serbe vers le français. Je ne connais pas le nombre de pages exact. Comment puis-je obtenir un devis ? L\'échéance est rapprochée\r\nCordialement, \r\nAlexia Gavriloff', '2026-07-05 09:37:41'),
(15, 'Addoun ', 'Ismahene ', 'ismahan86@yahoo.fr', '0745445686', 'Type de document : Jugement / décision de justice\r\nLangue souhaitée : Arabe vers Français\r\n\r\nBonjour, \r\nbesoin de faire une traduction dans les plus brefs délais.\r\nMerci ', '2026-07-06 12:53:05'),
(16, 'Robaszewska', 'Bogumila', 'anathelle123@gmail.com', '+33781477171', 'Type de document : Acte d\'état civil\r\nLangue souhaitée : Polonais vers Français\r\n\r\nBonjour,\r\nJe souhaiterais obtenir un devis pour la traduction par un traducteur assermenté des deux documents suivants :\r\n- une copie intégrale de l\'acte de naissance ;\r\nune copie intégrale de l\'acte de mariage.\r\nLa traduction n\'est pas urgente, je n\'ai donc pas de contrainte particulière de délai.\r\nCordialement,', '2026-07-06 20:11:49'),
(17, 'Topal', 'Emel', 'emeltopal5@gmail.com', '0660835179', 'Type de document : Autre document\nLangue souhaitée : Tchèque vers Français\n\nBonjour,\nJ\'ai plusieurs documents à traduire du Tchèque au Français.\n- une carte grise Tchèque (recto verso, c\'est une grande feuille, plus grand que A4)\n- une petite carte grise\n- une facture\n\nFaites vous des traductions pour ces documents ? \nVos traductions sont-elles certifiées ? J\'en ai besoin pour le quitus fiscal.\nSi oui, pouvez-vous me communiquer vos délais ainsi que vos tarifs ?\n\nBien cordialement', '2026-07-07 16:26:27'),
(18, 'Bouchentouf ', 'Taib', 'taibbouchentouf03@gmail.com', '0784749781', 'Type de document : Jugement / décision de justice\r\nLangue souhaitée : Arabe vers Français\r\n\r\nJugement de divorce contenant une page rect verso.', '2026-07-07 17:37:56'),
(19, 'VIANO', 'Patrice', 'contactlejackpot@gmail.com', '0623274243', 'Type de document : Acte d\'état civil\r\nLangue souhaitée : Thaïlandais vers Français\r\n\r\nil y a 3 pages\r\n_ acte de naissance original\r\n_ acte de changement de nom\r\n_ certificat de celibat\r\ndélais raisonnable no pression\r\nmerci pour votre réponse\r\nCordialement ', '2026-07-08 08:20:08'),
(20, 'CLAQUIN', 'Marie-Christine', 'mcclaquin@lescce.org', '0788941761', 'Type de document : Autre document\r\nLangue souhaitée : Anglais vers Français\r\n\r\nBonjour, \r\nJe souhaiterais faire traduire un extrait de Kbis en anglais.\r\nCette demande est faite dans un cadre professionnel.\r\nMerci beaucoup.\r\nTrès bonne journée,', '2026-07-08 09:10:46'),
(21, 'Amirat', 'Aksel', 'amirataksel@gmail.com', '', 'Type de document : Autre document\r\n\r\nJe souhaite traduire mon permis de conduire français vers georgien ', '2026-07-08 13:38:51'),
(22, 'Osagie ', 'Aden Boevet ', 'emotan89@gmail.com', '0748669891', 'Type de document : Acte d\'état civil\r\nLangue souhaitée : Anglais vers Français\r\n\r\nTraduction en français. Le plus vite  possible ', '2026-07-08 15:07:31'),
(23, 'DONDON', 'JIMMY SYLVIE', 'jsdambas@hotmail.com', '+33619916908', 'Type de document : Diplôme / relevé de notes\r\nLangue souhaitée : Français vers Anglais\r\n\r\nTraduction relevés notes du baccalauréat du français vers l’anglais', '2026-07-08 17:15:51'),
(24, 'Ben Halima', 'Ouassila', 'wasben24@yahoo.fr', '', 'Type de document : Autre document\r\nLangue souhaitée : Arabe vers Français\r\n\r\nC est une convocation au tribunal pour divorce à l amiable (2pages)\r\nMerci de m envoyer votre devis', '2026-07-08 19:22:20'),
(25, 'Tenzin', 'Damdhul', 'damdhultenzin2000@gmail.com', '07 81 71 54 61', 'Type de document : Acte d\'état civil\r\nLangue souhaitée : Anglais vers Français', '2026-07-08 20:43:16'),
(26, 'Seng', 'Amandine', 'amandine.seng@gmail.com', '', 'Type de document : Diplôme / relevé de notes\r\nLangue souhaitée : Espagnol vers Français\r\n\r\nje souhaiterais faire traduire mon diplôme provisoire obtenu en espagne (1 page) et mon casier judiciaire espagnol (2 pages)', '2026-07-09 19:12:12'),
(27, 'Lilleas', 'Ase', 'aselilleas@gmail.com', '+33608158013', 'Type de document : Acte d\'état civil\r\nLangue souhaitée : Anglais vers Français\r\n\r\nBonjour,\r\npouvez vous me donner un devis pour la traduction assermenté des documents suivants:\r\nActe de Naissance (écrit en plusieurs langues, dont l\'anglais)\r\n1 page d\'extrait casier judiciaire (établi en anglais)\r\n\r\nPuis, la traduction \'simple\' de 2 actes de naissance(écrit en plusieurs langues, dont l\'anglais)\r\n\r\nDans l\'attente de votre devis. \r\n\r\nCordialement,\r\n\r\nAse Lilleas', '2026-07-09 19:44:05'),
(28, 'ABIDAR', 'amina', 'amina_abidar@live.fr', '0666552820', 'Type de document : Acte d\'état civil\r\nLangue souhaitée : Arabe vers Français\r\n\r\nBonjour, \r\n\r\nJ\'aimerais traduire la copie intégrale de mon acte de mariage.\r\n\r\ncordialement,', '2026-07-10 10:31:52'),
(29, 'Boulierac', 'louna ', 'lounaboulierac@gmail.com', '0673837844', 'Type de document : Autre document\r\nLangue souhaitée : Français vers Anglais\r\n\r\nBonjour Madame, Monsieur,\r\nJe souhaite faire traduire une attestation de contrat EDF (qui me servira de justificatif de domicile). Le document fait une page. J\'aurais besoin de la version numérique de la traduction pour le 28/07 si cela est possible.\r\nBien cordialement, \r\nLouna Boulierac', '2026-07-10 11:21:12'),
(30, 'miladinovic', 'zoran', 'miladinoviczoran09@gmail.com', '+33610473727', 'Type de document : Autre document\r\nLangue souhaitée : Français vers Serbe\r\n\r\nPROCURATIONT ', '2026-07-10 15:14:00'),
(31, 'Nedjar ', 'Yazid', 'asma_ned@yahoo.fr', '+33695363779', 'Type de document : Autre document\r\nLangue souhaitée : Thaïlandais vers Français\r\n\r\nJe voudrais une traduction de mon permis de conduire \r\nMerci, cordialement ', '2026-07-12 00:19:43'),
(32, 'Brandao', 'Pascal', 'plorab@gmail.com', '+33769867749', 'Type de document : Acte d\'état civil\r\nLangue souhaitée : Français vers Portugais\r\n\r\nBonjour, je voudrais traduire une copie intégrale d\'acte de naissance française en portugais.', '2026-07-12 23:37:08');

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
('DoctrineMigrations\\Version20260627120000', '2026-06-27 11:21:33', 270),
('DoctrineMigrations\\Version20260628131609', '2026-06-28 17:24:34', 172),
('DoctrineMigrations\\Version20260705123000', '2026-07-05 12:53:13', 62),
('DoctrineMigrations\\Version20260705130000', '2026-07-05 12:53:20', 37),
('DoctrineMigrations\\Version20260705140000', '2026-07-05 12:53:26', 37),
('DoctrineMigrations\\Version20260712091947', '2026-07-12 12:08:35', 104),
('DoctrineMigrations\\Version20260712104113', '2026-07-12 13:08:37', 39),
('DoctrineMigrations\\Version20260712141134', '2026-07-12 16:17:58', 44),
('DoctrineMigrations\\Version20260713113800', '2026-07-13 11:44:22', 64);

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
(20, 'ACTE DE DÉCÈS', '<div>Document officiel délivré par une autorité administrative attestant le décès d’une personne. Il précise l’identité du défunt, la date, l’heure et le lieu du décès, ainsi que les informations d’état civil nécessaires aux démarches administratives, juridiques et successorales. Ce document est souvent requis pour les procédures de succession, la résiliation de contrats, les formalités bancaires et diverses démarches auprès des administrations nationales et internationales.<br><br></div>', 'Document', 32, 1, 'dec-1782392981.jpg'),
(21, 'PASSEPORT', '<div>Document officiel de voyage délivré par une autorité administrative attestant de l’identité et de la nationalité de son titulaire. Il permet de voyager à l’international et sert de justificatif d’identité auprès des administrations, des autorités frontalières et de nombreux organismes. Le passeport précise notamment l’identité du titulaire, sa date et son lieu de naissance, sa nationalité, son numéro de passeport, ainsi que ses dates de délivrance et d’expiration. Ce document est fréquemment requis pour les formalités de voyage, les demandes de visa, les démarches administratives et les procédures d’identification en France comme à l’étranger.<br><br></div>', 'Document', 28, 1, 'passeport-1782748173.png'),
(22, 'APOSTILLE', '<div>Traduction assermentée d\'apostilles destinée aux démarches administratives, procédures juridiques, demandes de visa, naturalisation, études, travail ou reconnaissance de documents à l\'étranger. Documents reconnus par les administrations, consulats, tribunaux et organismes officiels internationaux.</div>', 'DOCUMENT', 30, 1, 'apostile-1783522419.jpg');

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
  `price` int(11) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `document_id` int(11) NOT NULL,
  `language_origine` varchar(80) NOT NULL,
  `language_cible` varchar(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `translation_rate`
--

INSERT INTO `translation_rate` (`id`, `price`, `active`, `document_id`, `language_origine`, `language_cible`) VALUES
(1, 3000, 1, 1, 'Français', 'Anglais'),
(2, 3000, 1, 1, 'Français', 'Allemand'),
(3, 3000, 1, 1, 'Français', 'Italien'),
(4, 3000, 1, 1, 'Français', 'Espagnol'),
(5, 3400, 1, 1, 'Français', 'Roumain'),
(6, 3000, 1, 1, 'Français', 'Arabe'),
(7, 3400, 1, 1, 'Français', 'Turc'),
(8, 3000, 1, 1, 'Français', 'Russe'),
(9, 3400, 1, 1, 'Français', 'Albanais'),
(10, 4500, 1, 1, 'Français', 'Chinois'),
(11, 3400, 1, 1, 'Français', 'Portugais'),
(12, 4500, 1, 1, 'Français', 'Grec'),
(13, 4500, 1, 1, 'Français', 'Japonais'),
(14, 3400, 1, 1, 'Français', 'Néerlandais'),
(15, 3400, 1, 1, 'Français', 'Tchèque'),
(16, 3400, 1, 1, 'Français', 'Slovaque'),
(17, 3400, 1, 1, 'Français', 'Hongrois'),
(18, 7000, 1, 1, 'Français', 'Cantonais'),
(19, 7000, 1, 1, 'Français', 'Mandarin'),
(20, 3400, 1, 1, 'Français', 'Polonais'),
(21, 4500, 1, 1, 'Français', 'Serbe'),
(22, 4500, 1, 1, 'Français', 'Vietnamien'),
(23, 4500, 1, 1, 'Français', 'Coréen'),
(24, 4500, 1, 1, 'Français', 'Danois'),
(25, 3400, 1, 1, 'Français', 'Suédois'),
(26, 4500, 1, 1, 'Français', 'Thaïlandais'),
(27, 3400, 1, 1, 'Français', 'Croate'),
(28, 3000, 1, 1, 'Anglais', 'Français'),
(29, 3000, 1, 1, 'Allemand', 'Français'),
(30, 3000, 1, 1, 'Italien', 'Français'),
(31, 3000, 1, 1, 'Espagnol', 'Français'),
(32, 3400, 1, 1, 'Roumain', 'Français'),
(33, 3000, 1, 1, 'Arabe', 'Français'),
(34, 3000, 1, 1, 'Portugais', 'Français'),
(35, 3000, 1, 1, 'Néerlandais', 'Français'),
(36, 3000, 1, 1, 'Turc', 'Français'),
(37, 4500, 1, 1, 'Chinois', 'Français'),
(38, 4500, 1, 1, 'Chinois', 'Anglais'),
(39, 3000, 1, 1, 'Russe', 'Français'),
(40, 3400, 1, 1, 'Albanais', 'Français'),
(41, 3000, 1, 1, 'Ukrainien', 'Français'),
(42, 3000, 1, 1, 'Slovaque', 'Français'),
(43, 4500, 1, 1, 'Serbe', 'Français'),
(44, 3400, 1, 1, 'Grec', 'Français'),
(45, 4500, 1, 1, 'Japonais', 'Français'),
(46, 3000, 1, 1, 'Polonais', 'Français'),
(47, 7000, 1, 1, 'Mandarin', 'Français'),
(48, 7000, 1, 1, 'Cantonais', 'Français'),
(49, 3400, 1, 1, 'Hongrois', 'Français'),
(50, 3400, 1, 1, 'Géorgien', 'Français'),
(51, 3400, 1, 1, 'Tchèque', 'Français'),
(52, 4500, 1, 1, 'Vietnamien', 'Français'),
(53, 4500, 1, 1, 'Coréen', 'Français'),
(54, 4500, 1, 1, 'Danois', 'Français'),
(55, 3400, 1, 1, 'Suédois', 'Français'),
(56, 4500, 1, 1, 'Thaïlandais', 'Français'),
(57, 3400, 1, 1, 'Croate', 'Français'),
(58, 3400, 1, 1, 'Portugais', 'Espagnol'),
(59, 3400, 1, 1, 'Espagnol', 'Portugais'),
(60, 2800, 1, 5, 'Français', 'Anglais'),
(61, 2800, 1, 5, 'Français', 'Allemand'),
(62, 2800, 1, 5, 'Français', 'Italien'),
(63, 2800, 1, 5, 'Français', 'Espagnol'),
(64, 3400, 1, 5, 'Français', 'Roumain'),
(65, 2800, 1, 5, 'Français', 'Arabe'),
(66, 3400, 1, 5, 'Français', 'Turc'),
(67, 2800, 1, 5, 'Français', 'Russe'),
(68, 3400, 1, 5, 'Français', 'Albanais'),
(69, 4500, 1, 5, 'Français', 'Chinois'),
(70, 3400, 1, 5, 'Français', 'Portugais'),
(71, 4500, 1, 5, 'Français', 'Grec'),
(72, 4500, 1, 5, 'Français', 'Japonais'),
(73, 3400, 1, 5, 'Français', 'Néerlandais'),
(74, 3400, 1, 5, 'Français', 'Tchèque'),
(75, 3400, 1, 5, 'Français', 'Slovaque'),
(76, 7000, 1, 5, 'Français', 'Mandarin'),
(77, 7000, 1, 5, 'Français', 'Cantonais'),
(78, 3400, 1, 5, 'Français', 'Hongrois'),
(79, 3400, 1, 5, 'Français', 'Polonais'),
(80, 4500, 1, 5, 'Français', 'Serbe'),
(81, 4500, 1, 5, 'Français', 'Vietnamien'),
(82, 4500, 1, 5, 'Français', 'Coréen'),
(83, 4500, 1, 5, 'Français', 'Danois'),
(84, 3400, 1, 5, 'Français', 'Suédois'),
(85, 4500, 1, 5, 'Français', 'Thaïlandais'),
(86, 3400, 1, 5, 'Français', 'Croate'),
(87, 2800, 1, 5, 'Anglais', 'Français'),
(88, 2800, 1, 5, 'Allemand', 'Français'),
(89, 2800, 1, 5, 'Italien', 'Français'),
(90, 2800, 1, 5, 'Espagnol', 'Français'),
(91, 3400, 1, 5, 'Roumain', 'Français'),
(92, 2800, 1, 5, 'Arabe', 'Français'),
(93, 2800, 1, 5, 'Portugais', 'Français'),
(94, 2800, 1, 5, 'Néerlandais', 'Français'),
(95, 2800, 1, 5, 'Turc', 'Français'),
(96, 4500, 1, 5, 'Chinois', 'Français'),
(97, 4500, 1, 5, 'Chinois', 'Anglais'),
(98, 2800, 1, 5, 'Russe', 'Français'),
(99, 3400, 1, 5, 'Albanais', 'Français'),
(100, 2800, 1, 5, 'Ukrainien', 'Français'),
(101, 2800, 1, 5, 'Slovaque', 'Français'),
(102, 4500, 1, 5, 'Serbe', 'Français'),
(103, 3400, 1, 5, 'Grec', 'Français'),
(104, 4500, 1, 5, 'Japonais', 'Français'),
(105, 2800, 1, 5, 'Polonais', 'Français'),
(106, 7000, 1, 5, 'Mandarin', 'Français'),
(107, 7000, 1, 5, 'Cantonais', 'Français'),
(108, 3400, 1, 5, 'Hongrois', 'Français'),
(109, 3400, 1, 5, 'Géorgien', 'Français'),
(110, 3400, 1, 5, 'Tchèque', 'Français'),
(111, 4500, 1, 5, 'Vietnamien', 'Français'),
(112, 4500, 1, 5, 'Coréen', 'Français'),
(113, 4500, 1, 5, 'Danois', 'Français'),
(114, 3400, 1, 5, 'Suédois', 'Français'),
(115, 4500, 1, 5, 'Thaïlandais', 'Français'),
(116, 3400, 1, 5, 'Croate', 'Français'),
(117, 3400, 1, 5, 'Espagnol', 'Portugais'),
(118, 3400, 1, 5, 'Portugais', 'Espagnol'),
(119, 2800, 1, 3, 'Français', 'Anglais'),
(120, 2800, 1, 3, 'Français', 'Allemand'),
(121, 2800, 1, 3, 'Français', 'Italien'),
(122, 2800, 1, 3, 'Français', 'Espagnol'),
(123, 3400, 1, 3, 'Français', 'Roumain'),
(124, 2800, 1, 3, 'Français', 'Arabe'),
(125, 3400, 1, 3, 'Français', 'Turc'),
(126, 2800, 1, 3, 'Français', 'Russe'),
(127, 3400, 1, 3, 'Français', 'Albanais'),
(128, 4500, 1, 3, 'Français', 'Chinois'),
(129, 3400, 1, 3, 'Français', 'Portugais'),
(130, 4500, 1, 3, 'Français', 'Grec'),
(131, 4500, 1, 3, 'Français', 'Japonais'),
(132, 3400, 1, 3, 'Français', 'Néerlandais'),
(133, 3400, 1, 3, 'Français', 'Tchèque'),
(134, 3400, 1, 3, 'Français', 'Slovaque'),
(135, 3400, 1, 3, 'Français', 'Hongrois'),
(136, 7000, 1, 3, 'Français', 'Mandarin'),
(137, 7000, 1, 3, 'Français', 'Cantonais'),
(138, 3400, 1, 3, 'Français', 'Polonais'),
(139, 4500, 1, 3, 'Français', 'Serbe'),
(140, 4500, 1, 3, 'Français', 'Vietnamien'),
(141, 4500, 1, 3, 'Français', 'Coréen'),
(142, 4500, 1, 3, 'Français', 'Danois'),
(143, 3400, 1, 3, 'Français', 'Suédois'),
(144, 4500, 1, 3, 'Français', 'Thaïlandais'),
(145, 3400, 1, 3, 'Français', 'Croate'),
(146, 2800, 1, 3, 'Anglais', 'Français'),
(147, 2800, 1, 3, 'Allemand', 'Français'),
(148, 2800, 1, 3, 'Italien', 'Français'),
(149, 2800, 1, 3, 'Espagnol', 'Français'),
(150, 3400, 1, 3, 'Roumain', 'Français'),
(151, 2800, 1, 3, 'Arabe', 'Français'),
(152, 2800, 1, 3, 'Portugais', 'Français'),
(153, 2800, 1, 3, 'Néerlandais', 'Français'),
(154, 2800, 1, 3, 'Turc', 'Français'),
(155, 4500, 1, 3, 'Chinois', 'Français'),
(156, 4500, 1, 3, 'Chinois', 'Anglais'),
(157, 2800, 1, 3, 'Russe', 'Français'),
(158, 3400, 1, 3, 'Albanais', 'Français'),
(159, 2800, 1, 3, 'Ukrainien', 'Français'),
(160, 2800, 1, 3, 'Slovaque', 'Français'),
(161, 4500, 1, 3, 'Serbe', 'Français'),
(162, 3400, 1, 3, 'Grec', 'Français'),
(163, 4500, 1, 3, 'Japonais', 'Français'),
(164, 2800, 1, 3, 'Polonais', 'Français'),
(165, 7000, 1, 3, 'Mandarin', 'Français'),
(166, 7000, 1, 3, 'Cantonais', 'Français'),
(167, 3400, 1, 3, 'Hongrois', 'Français'),
(168, 3400, 1, 3, 'Géorgien', 'Français'),
(169, 3400, 1, 3, 'Tchèque', 'Français'),
(170, 4500, 1, 3, 'Vietnamien', 'Français'),
(171, 4500, 1, 3, 'Coréen', 'Français'),
(172, 4500, 1, 3, 'Danois', 'Français'),
(173, 3400, 1, 3, 'Suédois', 'Français'),
(174, 4500, 1, 3, 'Thaïlandais', 'Français'),
(175, 3400, 1, 3, 'Croate', 'Français'),
(176, 3400, 1, 3, 'Portugais', 'Espagnol'),
(177, 3400, 1, 3, 'Espagnol', 'Portugais'),
(178, 2800, 1, 8, 'Français', 'Anglais'),
(179, 2800, 1, 8, 'Français', 'Allemand'),
(180, 2800, 1, 8, 'Français', 'Italien'),
(181, 3200, 1, 8, 'Français', 'Espagnol'),
(182, 3400, 1, 8, 'Français', 'Roumain'),
(183, 2800, 1, 8, 'Français', 'Arabe'),
(184, 3400, 1, 8, 'Français', 'Turc'),
(185, 2800, 1, 8, 'Français', 'Russe'),
(186, 3400, 1, 8, 'Français', 'Albanais'),
(187, 4500, 1, 8, 'Français', 'Chinois'),
(188, 3400, 1, 8, 'Français', 'Portugais'),
(189, 4500, 1, 8, 'Français', 'Grec'),
(190, 4500, 1, 8, 'Français', 'Japonais'),
(191, 3400, 1, 8, 'Français', 'Néerlandais'),
(192, 3400, 1, 8, 'Français', 'Tchèque'),
(193, 3400, 1, 8, 'Français', 'Slovaque'),
(194, 7000, 1, 8, 'Français', 'Mandarin'),
(195, 7000, 1, 8, 'Français', 'Cantonais'),
(196, 3400, 1, 8, 'Français', 'Hongrois'),
(197, 3400, 1, 8, 'Français', 'Polonais'),
(198, 4500, 1, 8, 'Français', 'Serbe'),
(199, 4500, 1, 8, 'Français', 'Vietnamien'),
(200, 4500, 1, 8, 'Français', 'Coréen'),
(201, 4500, 1, 8, 'Français', 'Danois'),
(202, 3400, 1, 8, 'Français', 'Suédois'),
(203, 4500, 1, 8, 'Français', 'Thaïlandais'),
(204, 3400, 1, 8, 'Français', 'Croate'),
(205, 2800, 1, 8, 'Anglais', 'Français'),
(206, 2800, 1, 8, 'Allemand', 'Français'),
(207, 2800, 1, 8, 'Italien', 'Français'),
(208, 2800, 1, 8, 'Espagnol', 'Français'),
(209, 3400, 1, 8, 'Roumain', 'Français'),
(210, 2800, 1, 8, 'Arabe', 'Français'),
(211, 2800, 1, 8, 'Portugais', 'Français'),
(212, 2800, 1, 8, 'Néerlandais', 'Français'),
(213, 2800, 1, 8, 'Turc', 'Français'),
(214, 4500, 1, 8, 'Chinois', 'Français'),
(215, 4500, 1, 8, 'Chinois', 'Anglais'),
(216, 2800, 1, 8, 'Russe', 'Français'),
(217, 3400, 1, 8, 'Albanais', 'Français'),
(218, 2800, 1, 8, 'Ukrainien', 'Français'),
(219, 2800, 1, 8, 'Slovaque', 'Français'),
(220, 4500, 1, 8, 'Serbe', 'Français'),
(221, 3400, 1, 8, 'Grec', 'Français'),
(222, 4500, 1, 8, 'Japonais', 'Français'),
(223, 2800, 1, 8, 'Polonais', 'Français'),
(224, 7000, 1, 8, 'Mandarin', 'Français'),
(225, 7000, 1, 8, 'Cantonais', 'Français'),
(226, 3400, 1, 8, 'Hongrois', 'Français'),
(227, 3400, 1, 8, 'Géorgien', 'Français'),
(228, 3400, 1, 8, 'Tchèque', 'Français'),
(229, 4500, 1, 8, 'Vietnamien', 'Français'),
(230, 4500, 1, 8, 'Coréen', 'Français'),
(231, 4500, 1, 8, 'Danois', 'Français'),
(232, 3400, 1, 8, 'Suédois', 'Français'),
(233, 4500, 1, 8, 'Thaïlandais', 'Français'),
(234, 3400, 1, 8, 'Croate', 'Français'),
(235, 3400, 1, 8, 'Portugais', 'Espagnol'),
(236, 3400, 1, 8, 'Espagnol', 'Portugais'),
(237, 2800, 1, 6, 'Français', 'Anglais'),
(238, 2800, 1, 6, 'Français', 'Allemand'),
(239, 2800, 1, 6, 'Français', 'Italien'),
(240, 3200, 1, 6, 'Français', 'Espagnol'),
(241, 3400, 1, 6, 'Français', 'Roumain'),
(242, 3200, 1, 6, 'Français', 'Arabe'),
(243, 3400, 1, 6, 'Français', 'Turc'),
(244, 2800, 1, 6, 'Français', 'Russe'),
(245, 3400, 1, 6, 'Français', 'Albanais'),
(246, 4500, 1, 6, 'Français', 'Chinois'),
(247, 3400, 1, 6, 'Français', 'Portugais'),
(248, 4500, 1, 6, 'Français', 'Grec'),
(249, 4500, 1, 6, 'Français', 'Japonais'),
(250, 3400, 1, 6, 'Français', 'Néerlandais'),
(251, 3400, 1, 6, 'Français', 'Tchèque'),
(252, 3400, 1, 6, 'Français', 'Slovaque'),
(253, 7000, 1, 6, 'Français', 'Cantonais'),
(254, 3400, 1, 6, 'Français', 'Hongrois'),
(255, 7000, 1, 6, 'Français', 'Mandarin'),
(256, 3400, 1, 6, 'Français', 'Polonais'),
(257, 4500, 1, 6, 'Français', 'Serbe'),
(258, 4500, 1, 6, 'Français', 'Vietnamien'),
(259, 4500, 1, 6, 'Français', 'Coréen'),
(260, 4500, 1, 6, 'Français', 'Danois'),
(261, 3400, 1, 6, 'Français', 'Suédois'),
(262, 4500, 1, 6, 'Français', 'Thaïlandais'),
(263, 3400, 1, 6, 'Français', 'Croate'),
(264, 2800, 1, 6, 'Anglais', 'Français'),
(265, 2800, 1, 6, 'Allemand', 'Français'),
(266, 2800, 1, 6, 'Italien', 'Français'),
(267, 2800, 1, 6, 'Espagnol', 'Français'),
(268, 3400, 1, 6, 'Roumain', 'Français'),
(269, 2800, 1, 6, 'Arabe', 'Français'),
(270, 2800, 1, 6, 'Portugais', 'Français'),
(271, 2800, 1, 6, 'Néerlandais', 'Français'),
(272, 2800, 1, 6, 'Turc', 'Français'),
(273, 4500, 1, 6, 'Chinois', 'Français'),
(274, 4500, 1, 6, 'Chinois', 'Anglais'),
(275, 2800, 1, 6, 'Russe', 'Français'),
(276, 3400, 1, 6, 'Albanais', 'Français'),
(277, 2800, 1, 6, 'Ukrainien', 'Français'),
(278, 2800, 1, 6, 'Slovaque', 'Français'),
(279, 4500, 1, 6, 'Serbe', 'Français'),
(280, 3400, 1, 6, 'Grec', 'Français'),
(281, 4500, 1, 6, 'Japonais', 'Français'),
(282, 2800, 1, 6, 'Polonais', 'Français'),
(283, 7000, 1, 6, 'Mandarin', 'Français'),
(284, 7000, 1, 6, 'Cantonais', 'Français'),
(285, 3400, 1, 6, 'Hongrois', 'Français'),
(286, 3400, 1, 6, 'Géorgien', 'Français'),
(287, 3400, 1, 6, 'Tchèque', 'Français'),
(288, 4500, 1, 6, 'Vietnamien', 'Français'),
(289, 4500, 1, 6, 'Coréen', 'Français'),
(290, 4500, 1, 6, 'Danois', 'Français'),
(291, 3400, 1, 6, 'Suédois', 'Français'),
(292, 4500, 1, 6, 'Thaïlandais', 'Français'),
(293, 3400, 1, 6, 'Croate', 'Français'),
(294, 3400, 1, 6, 'Portugais', 'Espagnol'),
(295, 3400, 1, 6, 'Espagnol', 'Portugais'),
(296, 3600, 1, 2, 'Français', 'Anglais'),
(297, 3600, 1, 2, 'Français', 'Allemand'),
(298, 3600, 1, 2, 'Français', 'Italien'),
(299, 3600, 1, 2, 'Français', 'Espagnol'),
(300, 4200, 1, 2, 'Français', 'Roumain'),
(301, 3600, 1, 2, 'Français', 'Arabe'),
(302, 4200, 1, 2, 'Français', 'Turc'),
(303, 3600, 1, 2, 'Français', 'Russe'),
(304, 4200, 1, 2, 'Français', 'Albanais'),
(305, 6500, 1, 2, 'Français', 'Chinois'),
(306, 4200, 1, 2, 'Français', 'Portugais'),
(307, 5200, 1, 2, 'Français', 'Grec'),
(308, 6500, 1, 2, 'Français', 'Japonais'),
(309, 4200, 1, 2, 'Français', 'Néerlandais'),
(310, 4200, 1, 2, 'Français', 'Tchèque'),
(311, 4200, 1, 2, 'Français', 'Slovaque'),
(312, 7000, 1, 2, 'Français', 'Mandarin'),
(313, 7000, 1, 2, 'Français', 'Cantonais'),
(314, 4200, 1, 2, 'Français', 'Hongrois'),
(315, 4200, 1, 2, 'Français', 'Polonais'),
(316, 4500, 1, 2, 'Français', 'Serbe'),
(317, 6500, 1, 2, 'Français', 'Vietnamien'),
(318, 6500, 1, 2, 'Français', 'Coréen'),
(319, 4500, 1, 2, 'Français', 'Danois'),
(320, 4300, 1, 2, 'Français', 'Suédois'),
(321, 6500, 1, 2, 'Français', 'Thaïlandais'),
(322, 4200, 1, 2, 'Français', 'Croate'),
(323, 3600, 1, 2, 'Anglais', 'Français'),
(324, 3600, 1, 2, 'Allemand', 'Français'),
(325, 3600, 1, 2, 'Italien', 'Français'),
(326, 3600, 1, 2, 'Espagnol', 'Français'),
(327, 4200, 1, 2, 'Roumain', 'Français'),
(328, 3600, 1, 2, 'Arabe', 'Français'),
(329, 3600, 1, 2, 'Portugais', 'Français'),
(330, 3600, 1, 2, 'Néerlandais', 'Français'),
(331, 3600, 1, 2, 'Turc', 'Français'),
(332, 6500, 1, 2, 'Chinois', 'Français'),
(333, 6500, 1, 2, 'Chinois', 'Anglais'),
(334, 3600, 1, 2, 'Russe', 'Français'),
(335, 4200, 1, 2, 'Albanais', 'Français'),
(336, 3600, 1, 2, 'Ukrainien', 'Français'),
(337, 3600, 1, 2, 'Slovaque', 'Français'),
(338, 4500, 1, 2, 'Serbe', 'Français'),
(339, 3600, 1, 2, 'Grec', 'Français'),
(340, 6500, 1, 2, 'Japonais', 'Français'),
(341, 3600, 1, 2, 'Polonais', 'Français'),
(342, 7000, 1, 2, 'Mandarin', 'Français'),
(343, 7000, 1, 2, 'Cantonais', 'Français'),
(344, 4200, 1, 2, 'Hongrois', 'Français'),
(345, 4200, 1, 2, 'Géorgien', 'Français'),
(346, 4200, 1, 2, 'Tchèque', 'Français'),
(347, 6500, 1, 2, 'Vietnamien', 'Français'),
(348, 6500, 1, 2, 'Coréen', 'Français'),
(349, 4500, 1, 2, 'Danois', 'Français'),
(350, 4300, 1, 2, 'Suédois', 'Français'),
(351, 6500, 1, 2, 'Thaïlandais', 'Français'),
(352, 4200, 1, 2, 'Croate', 'Français'),
(353, 4200, 1, 2, 'Portugais', 'Espagnol'),
(354, 4200, 1, 2, 'Espagnol', 'Portugais'),
(355, 3200, 1, 20, 'Français', 'Anglais'),
(356, 3200, 1, 20, 'Français', 'Allemand'),
(357, 3200, 1, 20, 'Français', 'Italien'),
(358, 3200, 1, 20, 'Français', 'Espagnol'),
(359, 3400, 1, 20, 'Français', 'Roumain'),
(360, 3200, 1, 20, 'Français', 'Arabe'),
(361, 3400, 1, 20, 'Français', 'Turc'),
(362, 3200, 1, 20, 'Français', 'Russe'),
(363, 3200, 1, 20, 'Français', 'Albanais'),
(364, 4500, 1, 20, 'Français', 'Chinois'),
(365, 3400, 1, 20, 'Français', 'Portugais'),
(366, 4500, 1, 20, 'Français', 'Grec'),
(367, 4500, 1, 20, 'Français', 'Japonais'),
(368, 3400, 1, 20, 'Français', 'Néerlandais'),
(369, 3400, 1, 20, 'Français', 'Tchèque'),
(370, 3400, 1, 20, 'Français', 'Slovaque'),
(371, 7000, 1, 20, 'Français', 'Cantonais'),
(372, 3400, 1, 20, 'Français', 'Hongrois'),
(373, 7000, 1, 20, 'Français', 'Mandarin'),
(374, 3400, 1, 20, 'Français', 'Polonais'),
(375, 4500, 1, 20, 'Français', 'Serbe'),
(376, 4500, 1, 20, 'Français', 'Vietnamien'),
(377, 4500, 1, 20, 'Français', 'Coréen'),
(378, 4500, 1, 20, 'Français', 'Danois'),
(379, 4300, 1, 20, 'Français', 'Suédois'),
(380, 6500, 1, 20, 'Français', 'Thaïlandais'),
(381, 3400, 1, 20, 'Français', 'Croate'),
(382, 3200, 1, 20, 'Anglais', 'Français'),
(383, 3200, 1, 20, 'Allemand', 'Français'),
(384, 3200, 1, 20, 'Italien', 'Français'),
(385, 3200, 1, 20, 'Espagnol', 'Français'),
(386, 3400, 1, 20, 'Roumain', 'Français'),
(387, 3200, 1, 20, 'Arabe', 'Français'),
(388, 3200, 1, 20, 'Portugais', 'Français'),
(389, 3200, 1, 20, 'Néerlandais', 'Français'),
(390, 3200, 1, 20, 'Turc', 'Français'),
(391, 4500, 1, 20, 'Chinois', 'Français'),
(392, 4500, 1, 20, 'Chinois', 'Anglais'),
(393, 3200, 1, 20, 'Russe', 'Français'),
(394, 3200, 1, 20, 'Albanais', 'Français'),
(395, 3200, 1, 20, 'Ukrainien', 'Français'),
(396, 3200, 1, 20, 'Slovaque', 'Français'),
(397, 4500, 1, 20, 'Serbe', 'Français'),
(398, 3400, 1, 20, 'Grec', 'Français'),
(399, 4500, 1, 20, 'Japonais', 'Français'),
(400, 3200, 1, 20, 'Polonais', 'Français'),
(401, 7000, 1, 20, 'Mandarin', 'Français'),
(402, 7000, 1, 20, 'Cantonais', 'Français'),
(403, 3400, 1, 20, 'Hongrois', 'Français'),
(404, 3400, 1, 20, 'Géorgien', 'Français'),
(405, 3400, 1, 20, 'Tchèque', 'Français'),
(406, 4500, 1, 20, 'Vietnamien', 'Français'),
(407, 4500, 1, 20, 'Coréen', 'Français'),
(408, 4500, 1, 20, 'Danois', 'Français'),
(409, 4300, 1, 20, 'Suédois', 'Français'),
(410, 6500, 1, 20, 'Thaïlandais', 'Français'),
(411, 3400, 1, 20, 'Croate', 'Français'),
(412, 3400, 1, 20, 'Portugais', 'Espagnol'),
(413, 3400, 1, 20, 'Espagnol', 'Portugais'),
(414, 3700, 1, 15, 'Français', 'Anglais'),
(415, 3700, 1, 15, 'Français', 'Allemand'),
(416, 3700, 1, 15, 'Français', 'Italien'),
(417, 3700, 1, 15, 'Français', 'Espagnol'),
(418, 4300, 1, 15, 'Français', 'Roumain'),
(419, 3700, 1, 15, 'Français', 'Arabe'),
(420, 4300, 1, 15, 'Français', 'Turc'),
(421, 3700, 1, 15, 'Français', 'Russe'),
(422, 4300, 1, 15, 'Français', 'Albanais'),
(423, 6500, 1, 15, 'Français', 'Chinois'),
(424, 4300, 1, 15, 'Français', 'Portugais'),
(425, 5700, 1, 15, 'Français', 'Grec'),
(426, 6500, 1, 15, 'Français', 'Japonais'),
(427, 4300, 1, 15, 'Français', 'Néerlandais'),
(428, 4300, 1, 15, 'Français', 'Tchèque'),
(429, 4300, 1, 15, 'Français', 'Slovaque'),
(430, 7000, 1, 15, 'Français', 'Mandarin'),
(431, 4300, 1, 15, 'Français', 'Hongrois'),
(432, 7000, 1, 15, 'Français', 'Cantonais'),
(433, 4300, 1, 15, 'Français', 'Polonais'),
(434, 4500, 1, 15, 'Français', 'Serbe'),
(435, 6500, 1, 15, 'Français', 'Vietnamien'),
(436, 6500, 1, 15, 'Français', 'Coréen'),
(437, 4500, 1, 15, 'Français', 'Danois'),
(438, 4300, 1, 15, 'Français', 'Suédois'),
(439, 6500, 1, 15, 'Français', 'Thaïlandais'),
(440, 4300, 1, 15, 'Français', 'Croate'),
(441, 3700, 1, 15, 'Anglais', 'Français'),
(442, 3700, 1, 15, 'Allemand', 'Français'),
(443, 3700, 1, 15, 'Italien', 'Français'),
(444, 3700, 1, 15, 'Espagnol', 'Français'),
(445, 4300, 1, 15, 'Roumain', 'Français'),
(446, 3700, 1, 15, 'Arabe', 'Français'),
(447, 3700, 1, 15, 'Portugais', 'Français'),
(448, 3700, 1, 15, 'Néerlandais', 'Français'),
(449, 3700, 1, 15, 'Turc', 'Français'),
(450, 6500, 1, 15, 'Chinois', 'Français'),
(451, 6500, 1, 15, 'Chinois', 'Anglais'),
(452, 3700, 1, 15, 'Russe', 'Français'),
(453, 4300, 1, 15, 'Albanais', 'Français'),
(454, 3700, 1, 15, 'Ukrainien', 'Français'),
(455, 3700, 1, 15, 'Slovaque', 'Français'),
(456, 4500, 1, 15, 'Serbe', 'Français'),
(457, 3700, 1, 15, 'Grec', 'Français'),
(458, 6500, 1, 15, 'Japonais', 'Français'),
(459, 3700, 1, 15, 'Polonais', 'Français'),
(460, 7000, 1, 15, 'Mandarin', 'Français'),
(461, 7000, 1, 15, 'Cantonais', 'Français'),
(462, 4300, 1, 15, 'Hongrois', 'Français'),
(463, 4300, 1, 15, 'Géorgien', 'Français'),
(464, 4300, 1, 15, 'Tchèque', 'Français'),
(465, 6500, 1, 15, 'Vietnamien', 'Français'),
(466, 6500, 1, 15, 'Coréen', 'Français'),
(467, 4500, 1, 15, 'Danois', 'Français'),
(468, 4300, 1, 15, 'Suédois', 'Français'),
(469, 6500, 1, 15, 'Thaïlandais', 'Français'),
(470, 4300, 1, 15, 'Croate', 'Français'),
(471, 4200, 1, 15, 'Portugais', 'Espagnol'),
(472, 4200, 1, 15, 'Espagnol', 'Portugais'),
(473, 3000, 1, 7, 'Français', 'Anglais'),
(474, 3000, 1, 7, 'Français', 'Allemand'),
(475, 3000, 1, 7, 'Français', 'Italien'),
(476, 3000, 1, 7, 'Français', 'Espagnol'),
(477, 3400, 1, 7, 'Français', 'Roumain'),
(478, 3000, 1, 7, 'Français', 'Arabe'),
(479, 3400, 1, 7, 'Français', 'Turc'),
(480, 3000, 1, 7, 'Français', 'Russe'),
(481, 3400, 1, 7, 'Français', 'Albanais'),
(482, 4500, 1, 7, 'Français', 'Chinois'),
(483, 3400, 1, 7, 'Français', 'Portugais'),
(484, 4500, 1, 7, 'Français', 'Grec'),
(485, 4500, 1, 7, 'Français', 'Japonais'),
(486, 3400, 1, 7, 'Français', 'Néerlandais'),
(487, 3400, 1, 7, 'Français', 'Tchèque'),
(488, 3400, 1, 7, 'Français', 'Slovaque'),
(489, 7000, 1, 7, 'Français', 'Mandarin'),
(490, 3400, 1, 7, 'Français', 'Hongrois'),
(491, 3400, 1, 7, 'Français', 'Polonais'),
(492, 4500, 1, 7, 'Français', 'Serbe'),
(493, 4500, 1, 7, 'Français', 'Vietnamien'),
(494, 4500, 1, 7, 'Français', 'Coréen'),
(495, 4500, 1, 7, 'Français', 'Danois'),
(496, 3400, 1, 7, 'Français', 'Suédois'),
(497, 4500, 1, 7, 'Français', 'Thaïlandais'),
(498, 3400, 1, 7, 'Français', 'Croate'),
(499, 7000, 1, 7, 'Français', 'Cantonais'),
(500, 3000, 1, 7, 'Anglais', 'Français'),
(501, 3000, 1, 7, 'Allemand', 'Français'),
(502, 3000, 1, 7, 'Italien', 'Français'),
(503, 3000, 1, 7, 'Espagnol', 'Français'),
(504, 3400, 1, 7, 'Roumain', 'Français'),
(505, 3000, 1, 7, 'Arabe', 'Français'),
(506, 3000, 1, 7, 'Portugais', 'Français'),
(507, 3000, 1, 7, 'Néerlandais', 'Français'),
(508, 3000, 1, 7, 'Turc', 'Français'),
(509, 4500, 1, 7, 'Chinois', 'Français'),
(510, 4500, 1, 7, 'Chinois', 'Anglais'),
(511, 3000, 1, 7, 'Russe', 'Français'),
(512, 3400, 1, 7, 'Albanais', 'Français'),
(513, 3000, 1, 7, 'Ukrainien', 'Français'),
(514, 3000, 1, 7, 'Slovaque', 'Français'),
(515, 4500, 1, 7, 'Serbe', 'Français'),
(516, 3400, 1, 7, 'Grec', 'Français'),
(517, 4500, 1, 7, 'Japonais', 'Français'),
(518, 3000, 1, 7, 'Polonais', 'Français'),
(519, 7000, 1, 7, 'Mandarin', 'Français'),
(520, 7000, 1, 7, 'Cantonais', 'Français'),
(521, 3400, 1, 7, 'Hongrois', 'Français'),
(522, 3400, 1, 7, 'Géorgien', 'Français'),
(523, 3400, 1, 7, 'Tchèque', 'Français'),
(524, 4500, 1, 7, 'Vietnamien', 'Français'),
(525, 4500, 1, 7, 'Coréen', 'Français'),
(526, 4500, 1, 7, 'Danois', 'Français'),
(527, 3400, 1, 7, 'Suédois', 'Français'),
(528, 4500, 1, 7, 'Thaïlandais', 'Français'),
(529, 3400, 1, 7, 'Croate', 'Français'),
(530, 3400, 1, 7, 'Portugais', 'Espagnol'),
(531, 3400, 1, 7, 'Espagnol', 'Portugais'),
(532, 2800, 1, 4, 'Français', 'Anglais'),
(533, 2800, 1, 4, 'Français', 'Allemand'),
(534, 2800, 1, 4, 'Français', 'Italien'),
(535, 2800, 1, 4, 'Français', 'Espagnol'),
(536, 2800, 1, 4, 'Français', 'Roumain'),
(537, 2800, 1, 4, 'Français', 'Arabe'),
(538, 2800, 1, 4, 'Français', 'Turc'),
(539, 2800, 1, 4, 'Français', 'Russe'),
(540, 2800, 1, 4, 'Français', 'Albanais'),
(541, 2800, 1, 4, 'Français', 'Chinois'),
(542, 2800, 1, 4, 'Français', 'Portugais'),
(543, 2800, 1, 4, 'Français', 'Grec'),
(544, 2800, 1, 4, 'Français', 'Japonais'),
(545, 2800, 1, 4, 'Français', 'Néerlandais'),
(546, 2800, 1, 4, 'Français', 'Tchèque'),
(547, 2800, 1, 4, 'Français', 'Slovaque'),
(548, 2800, 1, 4, 'Français', 'Hongrois'),
(549, 2800, 1, 4, 'Français', 'Cantonais'),
(550, 2800, 1, 4, 'Français', 'Mandarin'),
(551, 2800, 1, 4, 'Français', 'Polonais'),
(552, 2800, 1, 4, 'Français', 'Serbe'),
(553, 2800, 1, 4, 'Français', 'Vietnamien'),
(554, 2800, 1, 4, 'Français', 'Coréen'),
(555, 2800, 1, 4, 'Français', 'Danois'),
(556, 2800, 1, 4, 'Français', 'Suédois'),
(557, 2800, 1, 4, 'Français', 'Thaïlandais'),
(558, 2800, 1, 4, 'Français', 'Croate'),
(559, 2800, 1, 4, 'Anglais', 'Français'),
(560, 2800, 1, 4, 'Allemand', 'Français'),
(561, 2800, 1, 4, 'Italien', 'Français'),
(562, 2800, 1, 4, 'Espagnol', 'Français'),
(563, 2800, 1, 4, 'Roumain', 'Français'),
(564, 2800, 1, 4, 'Arabe', 'Français'),
(565, 2800, 1, 4, 'Portugais', 'Français'),
(566, 2800, 1, 4, 'Néerlandais', 'Français'),
(567, 2800, 1, 4, 'Turc', 'Français'),
(568, 2800, 1, 4, 'Chinois', 'Français'),
(569, 2800, 1, 4, 'Chinois', 'Anglais'),
(570, 2800, 1, 4, 'Russe', 'Français'),
(571, 2800, 1, 4, 'Albanais', 'Français'),
(572, 2800, 1, 4, 'Ukrainien', 'Français'),
(573, 2800, 1, 4, 'Slovaque', 'Français'),
(574, 2800, 1, 4, 'Serbe', 'Français'),
(575, 2800, 1, 4, 'Grec', 'Français'),
(576, 2800, 1, 4, 'Japonais', 'Français'),
(577, 2800, 1, 4, 'Polonais', 'Français'),
(578, 2800, 1, 4, 'Mandarin', 'Français'),
(579, 2800, 1, 4, 'Cantonais', 'Français'),
(580, 2800, 1, 4, 'Hongrois', 'Français'),
(581, 2800, 1, 4, 'Géorgien', 'Français'),
(582, 2800, 1, 4, 'Tchèque', 'Français'),
(583, 2800, 1, 4, 'Vietnamien', 'Français'),
(584, 2800, 1, 4, 'Coréen', 'Français'),
(585, 2800, 1, 4, 'Danois', 'Français'),
(586, 2800, 1, 4, 'Suédois', 'Français'),
(587, 2800, 1, 4, 'Thaïlandais', 'Français'),
(588, 2800, 1, 4, 'Croate', 'Français'),
(589, 2800, 1, 4, 'Portugais', 'Espagnol'),
(590, 2800, 1, 4, 'Espagnol', 'Portugais'),
(591, 2800, 1, 9, 'Français', 'Anglais'),
(592, 2800, 1, 9, 'Français', 'Allemand'),
(593, 2800, 1, 9, 'Français', 'Italien'),
(594, 2800, 1, 9, 'Français', 'Espagnol'),
(595, 2800, 1, 9, 'Français', 'Roumain'),
(596, 2800, 1, 9, 'Français', 'Arabe'),
(597, 2800, 1, 9, 'Français', 'Turc'),
(598, 2800, 1, 9, 'Français', 'Russe'),
(599, 2800, 1, 9, 'Français', 'Albanais'),
(600, 2800, 1, 9, 'Français', 'Chinois'),
(601, 2800, 1, 9, 'Français', 'Portugais'),
(602, 2800, 1, 9, 'Français', 'Grec'),
(603, 2800, 1, 9, 'Français', 'Japonais'),
(604, 2800, 1, 9, 'Français', 'Néerlandais'),
(605, 2800, 1, 9, 'Français', 'Tchèque'),
(606, 2800, 1, 9, 'Français', 'Slovaque'),
(607, 2800, 1, 9, 'Français', 'Hongrois'),
(608, 2800, 1, 9, 'Français', 'Cantonais'),
(609, 2800, 1, 9, 'Français', 'Mandarin'),
(610, 2800, 1, 9, 'Français', 'Polonais'),
(611, 2800, 1, 9, 'Français', 'Serbe'),
(612, 2800, 1, 9, 'Français', 'Vietnamien'),
(613, 2800, 1, 9, 'Français', 'Coréen'),
(614, 2800, 1, 9, 'Français', 'Danois'),
(615, 2800, 1, 9, 'Français', 'Suédois'),
(616, 2800, 1, 9, 'Français', 'Thaïlandais'),
(617, 2800, 1, 9, 'Français', 'Croate'),
(618, 2800, 1, 9, 'Anglais', 'Français'),
(619, 2800, 1, 9, 'Allemand', 'Français'),
(620, 2800, 1, 9, 'Italien', 'Français'),
(621, 2800, 1, 9, 'Espagnol', 'Français'),
(622, 2800, 1, 9, 'Roumain', 'Français'),
(623, 2800, 1, 9, 'Arabe', 'Français'),
(624, 2800, 1, 9, 'Portugais', 'Français'),
(625, 2800, 1, 9, 'Néerlandais', 'Français'),
(626, 2800, 1, 9, 'Turc', 'Français'),
(627, 2800, 1, 9, 'Chinois', 'Français'),
(628, 2800, 1, 9, 'Chinois', 'Anglais'),
(629, 2800, 1, 9, 'Russe', 'Français'),
(630, 2800, 1, 9, 'Albanais', 'Français'),
(631, 2800, 1, 9, 'Ukrainien', 'Français'),
(632, 2800, 1, 9, 'Slovaque', 'Français'),
(633, 2800, 1, 9, 'Serbe', 'Français'),
(634, 2800, 1, 9, 'Grec', 'Français'),
(635, 2800, 1, 9, 'Japonais', 'Français'),
(636, 2800, 1, 9, 'Polonais', 'Français'),
(637, 2800, 1, 9, 'Mandarin', 'Français'),
(638, 2800, 1, 9, 'Cantonais', 'Français'),
(639, 2800, 1, 9, 'Hongrois', 'Français'),
(640, 2800, 1, 9, 'Géorgien', 'Français'),
(641, 2800, 1, 9, 'Tchèque', 'Français'),
(642, 2800, 1, 9, 'Vietnamien', 'Français'),
(643, 2800, 1, 9, 'Coréen', 'Français'),
(644, 2800, 1, 9, 'Danois', 'Français'),
(645, 2800, 1, 9, 'Suédois', 'Français'),
(646, 2800, 1, 9, 'Thaïlandais', 'Français'),
(647, 2800, 1, 9, 'Croate', 'Français'),
(648, 2800, 1, 9, 'Portugais', 'Espagnol'),
(649, 2800, 1, 9, 'Espagnol', 'Portugais'),
(650, 2800, 1, 10, 'Français', 'Anglais'),
(651, 2800, 1, 10, 'Français', 'Allemand'),
(652, 2800, 1, 10, 'Français', 'Italien'),
(653, 2800, 1, 10, 'Français', 'Espagnol'),
(654, 2800, 1, 10, 'Français', 'Roumain'),
(655, 2800, 1, 10, 'Français', 'Arabe'),
(656, 2800, 1, 10, 'Français', 'Turc'),
(657, 2800, 1, 10, 'Français', 'Russe'),
(658, 2800, 1, 10, 'Français', 'Albanais'),
(659, 2800, 1, 10, 'Français', 'Chinois'),
(660, 2800, 1, 10, 'Français', 'Portugais'),
(661, 2800, 1, 10, 'Français', 'Grec'),
(662, 2800, 1, 10, 'Français', 'Japonais'),
(663, 2800, 1, 10, 'Français', 'Néerlandais'),
(664, 2800, 1, 10, 'Français', 'Tchèque'),
(665, 2800, 1, 10, 'Français', 'Slovaque'),
(666, 2800, 1, 10, 'Français', 'Hongrois'),
(667, 2800, 1, 10, 'Français', 'Cantonais'),
(668, 2800, 1, 10, 'Français', 'Mandarin'),
(669, 2800, 1, 10, 'Français', 'Polonais'),
(670, 2800, 1, 10, 'Français', 'Serbe'),
(671, 2800, 1, 10, 'Français', 'Vietnamien'),
(672, 2800, 1, 10, 'Français', 'Coréen'),
(673, 2800, 1, 10, 'Français', 'Danois'),
(674, 2800, 1, 10, 'Français', 'Suédois'),
(675, 2800, 1, 10, 'Français', 'Thaïlandais'),
(676, 2800, 1, 10, 'Français', 'Croate'),
(677, 2800, 1, 10, 'Anglais', 'Français'),
(678, 2800, 1, 10, 'Allemand', 'Français'),
(679, 2800, 1, 10, 'Italien', 'Français'),
(680, 2800, 1, 10, 'Espagnol', 'Français'),
(681, 2800, 1, 10, 'Roumain', 'Français'),
(682, 2800, 1, 10, 'Arabe', 'Français'),
(683, 2800, 1, 10, 'Portugais', 'Français'),
(684, 2800, 1, 10, 'Néerlandais', 'Français'),
(685, 2800, 1, 10, 'Turc', 'Français'),
(686, 2800, 1, 10, 'Chinois', 'Français'),
(687, 2800, 1, 10, 'Chinois', 'Anglais'),
(688, 2800, 1, 10, 'Russe', 'Français'),
(689, 2800, 1, 10, 'Albanais', 'Français'),
(690, 2800, 1, 10, 'Ukrainien', 'Français'),
(691, 2800, 1, 10, 'Slovaque', 'Français'),
(692, 2800, 1, 10, 'Serbe', 'Français'),
(693, 2800, 1, 10, 'Grec', 'Français'),
(694, 2800, 1, 10, 'Japonais', 'Français'),
(695, 2800, 1, 10, 'Polonais', 'Français'),
(696, 2800, 1, 10, 'Mandarin', 'Français'),
(697, 2800, 1, 10, 'Cantonais', 'Français'),
(698, 2800, 1, 10, 'Hongrois', 'Français'),
(699, 2800, 1, 10, 'Géorgien', 'Français'),
(700, 2800, 1, 10, 'Tchèque', 'Français'),
(701, 2800, 1, 10, 'Vietnamien', 'Français'),
(702, 2800, 1, 10, 'Coréen', 'Français'),
(703, 2800, 1, 10, 'Danois', 'Français'),
(704, 2800, 1, 10, 'Suédois', 'Français'),
(705, 2800, 1, 10, 'Thaïlandais', 'Français'),
(706, 2800, 1, 10, 'Croate', 'Français'),
(707, 2800, 1, 10, 'Portugais', 'Espagnol'),
(708, 2800, 1, 10, 'Espagnol', 'Portugais'),
(709, 2800, 1, 11, 'Français', 'Anglais'),
(710, 2800, 1, 11, 'Français', 'Allemand'),
(711, 2800, 1, 11, 'Français', 'Italien'),
(712, 2800, 1, 11, 'Français', 'Espagnol'),
(713, 2800, 1, 11, 'Français', 'Roumain'),
(714, 2800, 1, 11, 'Français', 'Arabe'),
(715, 2800, 1, 11, 'Français', 'Turc'),
(716, 2800, 1, 11, 'Français', 'Russe'),
(717, 2800, 1, 11, 'Français', 'Albanais'),
(718, 2800, 1, 11, 'Français', 'Chinois'),
(719, 2800, 1, 11, 'Français', 'Portugais'),
(720, 2800, 1, 11, 'Français', 'Grec'),
(721, 2800, 1, 11, 'Français', 'Japonais'),
(722, 2800, 1, 11, 'Français', 'Néerlandais'),
(723, 2800, 1, 11, 'Français', 'Tchèque'),
(724, 2800, 1, 11, 'Français', 'Slovaque'),
(725, 2800, 1, 11, 'Français', 'Hongrois'),
(726, 2800, 1, 11, 'Français', 'Cantonais'),
(727, 2800, 1, 11, 'Français', 'Mandarin'),
(728, 2800, 1, 11, 'Français', 'Polonais'),
(729, 2800, 1, 11, 'Français', 'Serbe'),
(730, 2800, 1, 11, 'Français', 'Vietnamien'),
(731, 2800, 1, 11, 'Français', 'Coréen'),
(732, 2800, 1, 11, 'Français', 'Danois'),
(733, 2800, 1, 11, 'Français', 'Suédois'),
(734, 2800, 1, 11, 'Français', 'Thaïlandais'),
(735, 2800, 1, 11, 'Français', 'Croate'),
(736, 2800, 1, 11, 'Anglais', 'Français'),
(737, 2800, 1, 11, 'Allemand', 'Français'),
(738, 2800, 1, 11, 'Italien', 'Français'),
(739, 2800, 1, 11, 'Espagnol', 'Français'),
(740, 2800, 1, 11, 'Roumain', 'Français'),
(741, 2800, 1, 11, 'Arabe', 'Français'),
(742, 2800, 1, 11, 'Portugais', 'Français'),
(743, 2800, 1, 11, 'Néerlandais', 'Français'),
(744, 2800, 1, 11, 'Turc', 'Français'),
(745, 2800, 1, 11, 'Chinois', 'Français'),
(746, 2800, 1, 11, 'Chinois', 'Anglais'),
(747, 2800, 1, 11, 'Russe', 'Français'),
(748, 2800, 1, 11, 'Albanais', 'Français'),
(749, 2800, 1, 11, 'Ukrainien', 'Français'),
(750, 2800, 1, 11, 'Slovaque', 'Français'),
(751, 2800, 1, 11, 'Serbe', 'Français'),
(752, 2800, 1, 11, 'Grec', 'Français'),
(753, 2800, 1, 11, 'Japonais', 'Français'),
(754, 2800, 1, 11, 'Polonais', 'Français'),
(755, 2800, 1, 11, 'Mandarin', 'Français'),
(756, 2800, 1, 11, 'Cantonais', 'Français'),
(757, 2800, 1, 11, 'Hongrois', 'Français'),
(758, 2800, 1, 11, 'Géorgien', 'Français'),
(759, 2800, 1, 11, 'Tchèque', 'Français'),
(760, 2800, 1, 11, 'Vietnamien', 'Français'),
(761, 2800, 1, 11, 'Coréen', 'Français'),
(762, 2800, 1, 11, 'Danois', 'Français'),
(763, 2800, 1, 11, 'Suédois', 'Français'),
(764, 2800, 1, 11, 'Thaïlandais', 'Français'),
(765, 2800, 1, 11, 'Croate', 'Français'),
(766, 2800, 1, 11, 'Portugais', 'Espagnol'),
(767, 2800, 1, 11, 'Espagnol', 'Portugais'),
(768, 2800, 1, 12, 'Français', 'Anglais'),
(769, 2800, 1, 12, 'Français', 'Allemand'),
(770, 2800, 1, 12, 'Français', 'Italien'),
(771, 2800, 1, 12, 'Français', 'Espagnol'),
(772, 2800, 1, 12, 'Français', 'Roumain'),
(773, 2800, 1, 12, 'Français', 'Arabe'),
(774, 2800, 1, 12, 'Français', 'Turc'),
(775, 2800, 1, 12, 'Français', 'Russe'),
(776, 2800, 1, 12, 'Français', 'Albanais'),
(777, 2800, 1, 12, 'Français', 'Chinois'),
(778, 2800, 1, 12, 'Français', 'Portugais'),
(779, 2800, 1, 12, 'Français', 'Grec'),
(780, 2800, 1, 12, 'Français', 'Japonais'),
(781, 2800, 1, 12, 'Français', 'Néerlandais'),
(782, 2800, 1, 12, 'Français', 'Tchèque'),
(783, 2800, 1, 12, 'Français', 'Slovaque'),
(784, 2800, 1, 12, 'Français', 'Hongrois'),
(785, 2800, 1, 12, 'Français', 'Cantonais'),
(786, 2800, 1, 12, 'Français', 'Mandarin'),
(787, 2800, 1, 12, 'Français', 'Polonais'),
(788, 2800, 1, 12, 'Français', 'Serbe'),
(789, 2800, 1, 12, 'Français', 'Vietnamien'),
(790, 2800, 1, 12, 'Français', 'Coréen'),
(791, 2800, 1, 12, 'Français', 'Danois'),
(792, 2800, 1, 12, 'Français', 'Suédois'),
(793, 2800, 1, 12, 'Français', 'Thaïlandais'),
(794, 2800, 1, 12, 'Français', 'Croate'),
(795, 2800, 1, 12, 'Anglais', 'Français'),
(796, 2800, 1, 12, 'Allemand', 'Français'),
(797, 2800, 1, 12, 'Italien', 'Français'),
(798, 2800, 1, 12, 'Espagnol', 'Français'),
(799, 2800, 1, 12, 'Roumain', 'Français'),
(800, 2800, 1, 12, 'Arabe', 'Français'),
(801, 2800, 1, 12, 'Portugais', 'Français'),
(802, 2800, 1, 12, 'Néerlandais', 'Français'),
(803, 2800, 1, 12, 'Turc', 'Français'),
(804, 2800, 1, 12, 'Chinois', 'Français'),
(805, 2800, 1, 12, 'Chinois', 'Anglais'),
(806, 2800, 1, 12, 'Russe', 'Français'),
(807, 2800, 1, 12, 'Albanais', 'Français'),
(808, 2800, 1, 12, 'Ukrainien', 'Français'),
(809, 2800, 1, 12, 'Slovaque', 'Français'),
(810, 2800, 1, 12, 'Serbe', 'Français'),
(811, 2800, 1, 12, 'Grec', 'Français'),
(812, 2800, 1, 12, 'Japonais', 'Français'),
(813, 2800, 1, 12, 'Polonais', 'Français'),
(814, 2800, 1, 12, 'Mandarin', 'Français'),
(815, 2800, 1, 12, 'Cantonais', 'Français'),
(816, 2800, 1, 12, 'Hongrois', 'Français'),
(817, 2800, 1, 12, 'Géorgien', 'Français'),
(818, 2800, 1, 12, 'Tchèque', 'Français'),
(819, 2800, 1, 12, 'Vietnamien', 'Français'),
(820, 2800, 1, 12, 'Coréen', 'Français'),
(821, 2800, 1, 12, 'Danois', 'Français'),
(822, 2800, 1, 12, 'Suédois', 'Français'),
(823, 2800, 1, 12, 'Thaïlandais', 'Français'),
(824, 2800, 1, 12, 'Croate', 'Français'),
(825, 2800, 1, 12, 'Portugais', 'Espagnol'),
(826, 2800, 1, 12, 'Espagnol', 'Portugais'),
(827, 2800, 1, 13, 'Français', 'Anglais'),
(828, 2800, 1, 13, 'Français', 'Allemand'),
(829, 2800, 1, 13, 'Français', 'Italien'),
(830, 2800, 1, 13, 'Français', 'Espagnol'),
(831, 2800, 1, 13, 'Français', 'Roumain'),
(832, 2800, 1, 13, 'Français', 'Arabe'),
(833, 2800, 1, 13, 'Français', 'Turc'),
(834, 2800, 1, 13, 'Français', 'Russe'),
(835, 2800, 1, 13, 'Français', 'Albanais'),
(836, 2800, 1, 13, 'Français', 'Chinois'),
(837, 2800, 1, 13, 'Français', 'Portugais'),
(838, 2800, 1, 13, 'Français', 'Grec'),
(839, 2800, 1, 13, 'Français', 'Japonais'),
(840, 2800, 1, 13, 'Français', 'Néerlandais'),
(841, 2800, 1, 13, 'Français', 'Tchèque'),
(842, 2800, 1, 13, 'Français', 'Slovaque'),
(843, 2800, 1, 13, 'Français', 'Hongrois'),
(844, 2800, 1, 13, 'Français', 'Cantonais'),
(845, 2800, 1, 13, 'Français', 'Mandarin'),
(846, 2800, 1, 13, 'Français', 'Polonais'),
(847, 2800, 1, 13, 'Français', 'Serbe'),
(848, 2800, 1, 13, 'Français', 'Vietnamien'),
(849, 2800, 1, 13, 'Français', 'Coréen'),
(850, 2800, 1, 13, 'Français', 'Danois'),
(851, 2800, 1, 13, 'Français', 'Suédois'),
(852, 2800, 1, 13, 'Français', 'Thaïlandais'),
(853, 2800, 1, 13, 'Français', 'Croate'),
(854, 2800, 1, 13, 'Anglais', 'Français'),
(855, 2800, 1, 13, 'Allemand', 'Français'),
(856, 2800, 1, 13, 'Italien', 'Français'),
(857, 2800, 1, 13, 'Espagnol', 'Français'),
(858, 2800, 1, 13, 'Roumain', 'Français'),
(859, 2800, 1, 13, 'Arabe', 'Français'),
(860, 2800, 1, 13, 'Portugais', 'Français'),
(861, 2800, 1, 13, 'Néerlandais', 'Français'),
(862, 2800, 1, 13, 'Turc', 'Français'),
(863, 2800, 1, 13, 'Chinois', 'Français'),
(864, 2800, 1, 13, 'Chinois', 'Anglais'),
(865, 2800, 1, 13, 'Russe', 'Français'),
(866, 2800, 1, 13, 'Albanais', 'Français'),
(867, 2800, 1, 13, 'Ukrainien', 'Français'),
(868, 2800, 1, 13, 'Slovaque', 'Français'),
(869, 2800, 1, 13, 'Serbe', 'Français'),
(870, 2800, 1, 13, 'Grec', 'Français'),
(871, 2800, 1, 13, 'Japonais', 'Français'),
(872, 2800, 1, 13, 'Polonais', 'Français'),
(873, 2800, 1, 13, 'Mandarin', 'Français'),
(874, 2800, 1, 13, 'Cantonais', 'Français'),
(875, 2800, 1, 13, 'Hongrois', 'Français'),
(876, 2800, 1, 13, 'Géorgien', 'Français'),
(877, 2800, 1, 13, 'Tchèque', 'Français'),
(878, 2800, 1, 13, 'Vietnamien', 'Français'),
(879, 2800, 1, 13, 'Coréen', 'Français'),
(880, 2800, 1, 13, 'Danois', 'Français'),
(881, 2800, 1, 13, 'Suédois', 'Français'),
(882, 2800, 1, 13, 'Thaïlandais', 'Français'),
(883, 2800, 1, 13, 'Croate', 'Français'),
(884, 2800, 1, 13, 'Portugais', 'Espagnol'),
(885, 2800, 1, 13, 'Espagnol', 'Portugais'),
(886, 2800, 1, 14, 'Français', 'Anglais'),
(887, 2800, 1, 14, 'Français', 'Allemand'),
(888, 2800, 1, 14, 'Français', 'Italien'),
(889, 2800, 1, 14, 'Français', 'Espagnol'),
(890, 2800, 1, 14, 'Français', 'Roumain'),
(891, 2800, 1, 14, 'Français', 'Arabe'),
(892, 2800, 1, 14, 'Français', 'Turc'),
(893, 2800, 1, 14, 'Français', 'Russe'),
(894, 2800, 1, 14, 'Français', 'Albanais'),
(895, 2800, 1, 14, 'Français', 'Chinois'),
(896, 2800, 1, 14, 'Français', 'Portugais'),
(897, 2800, 1, 14, 'Français', 'Grec'),
(898, 2800, 1, 14, 'Français', 'Japonais'),
(899, 2800, 1, 14, 'Français', 'Néerlandais'),
(900, 2800, 1, 14, 'Français', 'Tchèque'),
(901, 2800, 1, 14, 'Français', 'Slovaque'),
(902, 2800, 1, 14, 'Français', 'Hongrois'),
(903, 2800, 1, 14, 'Français', 'Cantonais'),
(904, 2800, 1, 14, 'Français', 'Mandarin'),
(905, 2800, 1, 14, 'Français', 'Polonais'),
(906, 2800, 1, 14, 'Français', 'Serbe'),
(907, 2800, 1, 14, 'Français', 'Vietnamien'),
(908, 2800, 1, 14, 'Français', 'Coréen'),
(909, 2800, 1, 14, 'Français', 'Danois'),
(910, 2800, 1, 14, 'Français', 'Suédois'),
(911, 2800, 1, 14, 'Français', 'Thaïlandais'),
(912, 2800, 1, 14, 'Français', 'Croate'),
(913, 2800, 1, 14, 'Anglais', 'Français'),
(914, 2800, 1, 14, 'Allemand', 'Français'),
(915, 2800, 1, 14, 'Italien', 'Français'),
(916, 2800, 1, 14, 'Espagnol', 'Français'),
(917, 2800, 1, 14, 'Roumain', 'Français'),
(918, 2800, 1, 14, 'Arabe', 'Français'),
(919, 2800, 1, 14, 'Portugais', 'Français'),
(920, 2800, 1, 14, 'Néerlandais', 'Français'),
(921, 2800, 1, 14, 'Turc', 'Français'),
(922, 2800, 1, 14, 'Chinois', 'Français'),
(923, 2800, 1, 14, 'Chinois', 'Anglais'),
(924, 2800, 1, 14, 'Russe', 'Français'),
(925, 2800, 1, 14, 'Albanais', 'Français'),
(926, 2800, 1, 14, 'Ukrainien', 'Français'),
(927, 2800, 1, 14, 'Slovaque', 'Français'),
(928, 2800, 1, 14, 'Serbe', 'Français'),
(929, 2800, 1, 14, 'Grec', 'Français'),
(930, 2800, 1, 14, 'Japonais', 'Français'),
(931, 2800, 1, 14, 'Polonais', 'Français'),
(932, 2800, 1, 14, 'Mandarin', 'Français'),
(933, 2800, 1, 14, 'Cantonais', 'Français'),
(934, 2800, 1, 14, 'Hongrois', 'Français'),
(935, 2800, 1, 14, 'Géorgien', 'Français'),
(936, 2800, 1, 14, 'Tchèque', 'Français'),
(937, 2800, 1, 14, 'Vietnamien', 'Français'),
(938, 2800, 1, 14, 'Coréen', 'Français'),
(939, 2800, 1, 14, 'Danois', 'Français'),
(940, 2800, 1, 14, 'Suédois', 'Français'),
(941, 2800, 1, 14, 'Thaïlandais', 'Français'),
(942, 2800, 1, 14, 'Croate', 'Français'),
(943, 2800, 1, 14, 'Portugais', 'Espagnol'),
(944, 2800, 1, 14, 'Espagnol', 'Portugais'),
(945, 2800, 1, 16, 'Français', 'Anglais'),
(946, 2800, 1, 16, 'Français', 'Allemand'),
(947, 2800, 1, 16, 'Français', 'Italien'),
(948, 2800, 1, 16, 'Français', 'Espagnol'),
(949, 2800, 1, 16, 'Français', 'Roumain'),
(950, 2800, 1, 16, 'Français', 'Arabe'),
(951, 2800, 1, 16, 'Français', 'Turc'),
(952, 2800, 1, 16, 'Français', 'Russe'),
(953, 2800, 1, 16, 'Français', 'Albanais'),
(954, 2800, 1, 16, 'Français', 'Chinois'),
(955, 2800, 1, 16, 'Français', 'Portugais'),
(956, 2800, 1, 16, 'Français', 'Grec'),
(957, 2800, 1, 16, 'Français', 'Japonais'),
(958, 2800, 1, 16, 'Français', 'Néerlandais'),
(959, 2800, 1, 16, 'Français', 'Tchèque'),
(960, 2800, 1, 16, 'Français', 'Slovaque'),
(961, 2800, 1, 16, 'Français', 'Hongrois'),
(962, 2800, 1, 16, 'Français', 'Cantonais'),
(963, 2800, 1, 16, 'Français', 'Mandarin'),
(964, 2800, 1, 16, 'Français', 'Polonais'),
(965, 2800, 1, 16, 'Français', 'Serbe'),
(966, 2800, 1, 16, 'Français', 'Vietnamien'),
(967, 2800, 1, 16, 'Français', 'Coréen'),
(968, 2800, 1, 16, 'Français', 'Danois'),
(969, 2800, 1, 16, 'Français', 'Suédois'),
(970, 2800, 1, 16, 'Français', 'Thaïlandais'),
(971, 2800, 1, 16, 'Français', 'Croate'),
(972, 2800, 1, 16, 'Anglais', 'Français'),
(973, 2800, 1, 16, 'Allemand', 'Français'),
(974, 2800, 1, 16, 'Italien', 'Français'),
(975, 2800, 1, 16, 'Espagnol', 'Français'),
(976, 2800, 1, 16, 'Roumain', 'Français'),
(977, 2800, 1, 16, 'Arabe', 'Français'),
(978, 2800, 1, 16, 'Portugais', 'Français'),
(979, 2800, 1, 16, 'Néerlandais', 'Français'),
(980, 2800, 1, 16, 'Turc', 'Français'),
(981, 2800, 1, 16, 'Chinois', 'Français'),
(982, 2800, 1, 16, 'Chinois', 'Anglais'),
(983, 2800, 1, 16, 'Russe', 'Français'),
(984, 2800, 1, 16, 'Albanais', 'Français'),
(985, 2800, 1, 16, 'Ukrainien', 'Français'),
(986, 2800, 1, 16, 'Slovaque', 'Français'),
(987, 2800, 1, 16, 'Serbe', 'Français'),
(988, 2800, 1, 16, 'Grec', 'Français'),
(989, 2800, 1, 16, 'Japonais', 'Français'),
(990, 2800, 1, 16, 'Polonais', 'Français'),
(991, 2800, 1, 16, 'Mandarin', 'Français'),
(992, 2800, 1, 16, 'Cantonais', 'Français'),
(993, 2800, 1, 16, 'Hongrois', 'Français'),
(994, 2800, 1, 16, 'Géorgien', 'Français'),
(995, 2800, 1, 16, 'Tchèque', 'Français'),
(996, 2800, 1, 16, 'Vietnamien', 'Français'),
(997, 2800, 1, 16, 'Coréen', 'Français'),
(998, 2800, 1, 16, 'Danois', 'Français'),
(999, 2800, 1, 16, 'Suédois', 'Français'),
(1000, 2800, 1, 16, 'Thaïlandais', 'Français'),
(1001, 2800, 1, 16, 'Croate', 'Français'),
(1002, 2800, 1, 16, 'Portugais', 'Espagnol'),
(1003, 2800, 1, 16, 'Espagnol', 'Portugais'),
(1004, 2800, 1, 17, 'Français', 'Anglais'),
(1005, 2800, 1, 17, 'Français', 'Allemand'),
(1006, 2800, 1, 17, 'Français', 'Italien'),
(1007, 2800, 1, 17, 'Français', 'Espagnol'),
(1008, 2800, 1, 17, 'Français', 'Roumain'),
(1009, 2800, 1, 17, 'Français', 'Arabe'),
(1010, 2800, 1, 17, 'Français', 'Turc'),
(1011, 2800, 1, 17, 'Français', 'Russe'),
(1012, 2800, 1, 17, 'Français', 'Albanais'),
(1013, 2800, 1, 17, 'Français', 'Chinois'),
(1014, 2800, 1, 17, 'Français', 'Portugais'),
(1015, 2800, 1, 17, 'Français', 'Grec'),
(1016, 2800, 1, 17, 'Français', 'Japonais'),
(1017, 2800, 1, 17, 'Français', 'Néerlandais'),
(1018, 2800, 1, 17, 'Français', 'Tchèque'),
(1019, 2800, 1, 17, 'Français', 'Slovaque'),
(1020, 2800, 1, 17, 'Français', 'Hongrois'),
(1021, 2800, 1, 17, 'Français', 'Cantonais'),
(1022, 2800, 1, 17, 'Français', 'Mandarin'),
(1023, 2800, 1, 17, 'Français', 'Polonais'),
(1024, 2800, 1, 17, 'Français', 'Serbe'),
(1025, 2800, 1, 17, 'Français', 'Vietnamien'),
(1026, 2800, 1, 17, 'Français', 'Coréen'),
(1027, 2800, 1, 17, 'Français', 'Danois'),
(1028, 2800, 1, 17, 'Français', 'Suédois'),
(1029, 2800, 1, 17, 'Français', 'Thaïlandais'),
(1030, 2800, 1, 17, 'Français', 'Croate'),
(1031, 2800, 1, 17, 'Anglais', 'Français'),
(1032, 2800, 1, 17, 'Allemand', 'Français'),
(1033, 2800, 1, 17, 'Italien', 'Français'),
(1034, 2800, 1, 17, 'Espagnol', 'Français'),
(1035, 2800, 1, 17, 'Roumain', 'Français'),
(1036, 2800, 1, 17, 'Arabe', 'Français'),
(1037, 2800, 1, 17, 'Portugais', 'Français'),
(1038, 2800, 1, 17, 'Néerlandais', 'Français'),
(1039, 2800, 1, 17, 'Turc', 'Français'),
(1040, 2800, 1, 17, 'Chinois', 'Français'),
(1041, 2800, 1, 17, 'Chinois', 'Anglais'),
(1042, 2800, 1, 17, 'Russe', 'Français'),
(1043, 2800, 1, 17, 'Albanais', 'Français'),
(1044, 2800, 1, 17, 'Ukrainien', 'Français'),
(1045, 2800, 1, 17, 'Slovaque', 'Français'),
(1046, 2800, 1, 17, 'Serbe', 'Français'),
(1047, 2800, 1, 17, 'Grec', 'Français'),
(1048, 2800, 1, 17, 'Japonais', 'Français'),
(1049, 2800, 1, 17, 'Polonais', 'Français'),
(1050, 2800, 1, 17, 'Mandarin', 'Français'),
(1051, 2800, 1, 17, 'Cantonais', 'Français'),
(1052, 2800, 1, 17, 'Hongrois', 'Français'),
(1053, 2800, 1, 17, 'Géorgien', 'Français'),
(1054, 2800, 1, 17, 'Tchèque', 'Français'),
(1055, 2800, 1, 17, 'Vietnamien', 'Français'),
(1056, 2800, 1, 17, 'Coréen', 'Français'),
(1057, 2800, 1, 17, 'Danois', 'Français'),
(1058, 2800, 1, 17, 'Suédois', 'Français'),
(1059, 2800, 1, 17, 'Thaïlandais', 'Français'),
(1060, 2800, 1, 17, 'Croate', 'Français'),
(1061, 2800, 1, 17, 'Portugais', 'Espagnol'),
(1062, 2800, 1, 17, 'Espagnol', 'Portugais'),
(1063, 2800, 1, 18, 'Français', 'Anglais'),
(1064, 2800, 1, 18, 'Français', 'Allemand'),
(1065, 2800, 1, 18, 'Français', 'Italien'),
(1066, 2800, 1, 18, 'Français', 'Espagnol'),
(1067, 2800, 1, 18, 'Français', 'Roumain'),
(1068, 2800, 1, 18, 'Français', 'Arabe'),
(1069, 2800, 1, 18, 'Français', 'Turc'),
(1070, 2800, 1, 18, 'Français', 'Russe'),
(1071, 2800, 1, 18, 'Français', 'Albanais'),
(1072, 2800, 1, 18, 'Français', 'Chinois'),
(1073, 2800, 1, 18, 'Français', 'Portugais'),
(1074, 2800, 1, 18, 'Français', 'Grec'),
(1075, 2800, 1, 18, 'Français', 'Japonais'),
(1076, 2800, 1, 18, 'Français', 'Néerlandais'),
(1077, 2800, 1, 18, 'Français', 'Tchèque'),
(1078, 2800, 1, 18, 'Français', 'Slovaque'),
(1079, 2800, 1, 18, 'Français', 'Hongrois'),
(1080, 2800, 1, 18, 'Français', 'Cantonais'),
(1081, 2800, 1, 18, 'Français', 'Mandarin'),
(1082, 2800, 1, 18, 'Français', 'Polonais'),
(1083, 2800, 1, 18, 'Français', 'Serbe'),
(1084, 2800, 1, 18, 'Français', 'Vietnamien'),
(1085, 2800, 1, 18, 'Français', 'Coréen'),
(1086, 2800, 1, 18, 'Français', 'Danois'),
(1087, 2800, 1, 18, 'Français', 'Suédois'),
(1088, 2800, 1, 18, 'Français', 'Thaïlandais'),
(1089, 2800, 1, 18, 'Français', 'Croate'),
(1090, 2800, 1, 18, 'Anglais', 'Français'),
(1091, 2800, 1, 18, 'Allemand', 'Français'),
(1092, 2800, 1, 18, 'Italien', 'Français'),
(1093, 2800, 1, 18, 'Espagnol', 'Français'),
(1094, 2800, 1, 18, 'Roumain', 'Français'),
(1095, 2800, 1, 18, 'Arabe', 'Français'),
(1096, 2800, 1, 18, 'Portugais', 'Français'),
(1097, 2800, 1, 18, 'Néerlandais', 'Français'),
(1098, 2800, 1, 18, 'Turc', 'Français'),
(1099, 2800, 1, 18, 'Chinois', 'Français'),
(1100, 2800, 1, 18, 'Chinois', 'Anglais'),
(1101, 2800, 1, 18, 'Russe', 'Français'),
(1102, 2800, 1, 18, 'Albanais', 'Français'),
(1103, 2800, 1, 18, 'Ukrainien', 'Français'),
(1104, 2800, 1, 18, 'Slovaque', 'Français'),
(1105, 2800, 1, 18, 'Serbe', 'Français'),
(1106, 2800, 1, 18, 'Grec', 'Français'),
(1107, 2800, 1, 18, 'Japonais', 'Français'),
(1108, 2800, 1, 18, 'Polonais', 'Français'),
(1109, 2800, 1, 18, 'Mandarin', 'Français'),
(1110, 2800, 1, 18, 'Cantonais', 'Français'),
(1111, 2800, 1, 18, 'Hongrois', 'Français'),
(1112, 2800, 1, 18, 'Géorgien', 'Français'),
(1113, 2800, 1, 18, 'Tchèque', 'Français'),
(1114, 2800, 1, 18, 'Vietnamien', 'Français'),
(1115, 2800, 1, 18, 'Coréen', 'Français'),
(1116, 2800, 1, 18, 'Danois', 'Français'),
(1117, 2800, 1, 18, 'Suédois', 'Français'),
(1118, 2800, 1, 18, 'Thaïlandais', 'Français'),
(1119, 2800, 1, 18, 'Croate', 'Français'),
(1120, 2800, 1, 18, 'Portugais', 'Espagnol'),
(1121, 2800, 1, 18, 'Espagnol', 'Portugais'),
(1122, 2800, 1, 19, 'Français', 'Anglais'),
(1123, 2800, 1, 19, 'Français', 'Allemand'),
(1124, 2800, 1, 19, 'Français', 'Italien'),
(1125, 2800, 1, 19, 'Français', 'Espagnol'),
(1126, 2800, 1, 19, 'Français', 'Roumain'),
(1127, 2800, 1, 19, 'Français', 'Arabe'),
(1128, 2800, 1, 19, 'Français', 'Turc'),
(1129, 2800, 1, 19, 'Français', 'Russe'),
(1130, 2800, 1, 19, 'Français', 'Albanais'),
(1131, 2800, 1, 19, 'Français', 'Chinois'),
(1132, 2800, 1, 19, 'Français', 'Portugais'),
(1133, 2800, 1, 19, 'Français', 'Grec'),
(1134, 2800, 1, 19, 'Français', 'Japonais'),
(1135, 2800, 1, 19, 'Français', 'Néerlandais'),
(1136, 2800, 1, 19, 'Français', 'Tchèque'),
(1137, 2800, 1, 19, 'Français', 'Slovaque'),
(1138, 2800, 1, 19, 'Français', 'Hongrois'),
(1139, 2800, 1, 19, 'Français', 'Cantonais'),
(1140, 2800, 1, 19, 'Français', 'Mandarin'),
(1141, 2800, 1, 19, 'Français', 'Polonais'),
(1142, 2800, 1, 19, 'Français', 'Serbe'),
(1143, 2800, 1, 19, 'Français', 'Vietnamien'),
(1144, 2800, 1, 19, 'Français', 'Coréen'),
(1145, 2800, 1, 19, 'Français', 'Danois'),
(1146, 2800, 1, 19, 'Français', 'Suédois'),
(1147, 2800, 1, 19, 'Français', 'Thaïlandais'),
(1148, 2800, 1, 19, 'Français', 'Croate'),
(1149, 2800, 1, 19, 'Anglais', 'Français'),
(1150, 2800, 1, 19, 'Allemand', 'Français'),
(1151, 2800, 1, 19, 'Italien', 'Français'),
(1152, 2800, 1, 19, 'Espagnol', 'Français'),
(1153, 2800, 1, 19, 'Roumain', 'Français'),
(1154, 2800, 1, 19, 'Arabe', 'Français'),
(1155, 2800, 1, 19, 'Portugais', 'Français'),
(1156, 2800, 1, 19, 'Néerlandais', 'Français'),
(1157, 2800, 1, 19, 'Turc', 'Français'),
(1158, 2800, 1, 19, 'Chinois', 'Français'),
(1159, 2800, 1, 19, 'Chinois', 'Anglais'),
(1160, 2800, 1, 19, 'Russe', 'Français'),
(1161, 2800, 1, 19, 'Albanais', 'Français'),
(1162, 2800, 1, 19, 'Ukrainien', 'Français'),
(1163, 2800, 1, 19, 'Slovaque', 'Français'),
(1164, 2800, 1, 19, 'Serbe', 'Français'),
(1165, 2800, 1, 19, 'Grec', 'Français'),
(1166, 2800, 1, 19, 'Japonais', 'Français'),
(1167, 2800, 1, 19, 'Polonais', 'Français'),
(1168, 2800, 1, 19, 'Mandarin', 'Français'),
(1169, 2800, 1, 19, 'Cantonais', 'Français'),
(1170, 2800, 1, 19, 'Hongrois', 'Français'),
(1171, 2800, 1, 19, 'Géorgien', 'Français'),
(1172, 2800, 1, 19, 'Tchèque', 'Français'),
(1173, 2800, 1, 19, 'Vietnamien', 'Français'),
(1174, 2800, 1, 19, 'Coréen', 'Français'),
(1175, 2800, 1, 19, 'Danois', 'Français'),
(1176, 2800, 1, 19, 'Suédois', 'Français'),
(1177, 2800, 1, 19, 'Thaïlandais', 'Français'),
(1178, 2800, 1, 19, 'Croate', 'Français'),
(1179, 2800, 1, 19, 'Portugais', 'Espagnol'),
(1180, 2800, 1, 19, 'Espagnol', 'Portugais'),
(1181, 2800, 1, 21, 'Français', 'Anglais'),
(1182, 2800, 1, 21, 'Français', 'Allemand'),
(1183, 2800, 1, 21, 'Français', 'Italien'),
(1184, 2800, 1, 21, 'Français', 'Espagnol'),
(1185, 3400, 1, 21, 'Français', 'Roumain'),
(1186, 2800, 1, 21, 'Français', 'Arabe'),
(1187, 3400, 1, 21, 'Français', 'Turc'),
(1188, 2800, 1, 21, 'Français', 'Russe'),
(1189, 3400, 1, 21, 'Français', 'Albanais'),
(1190, 4500, 1, 21, 'Français', 'Chinois'),
(1191, 3400, 1, 21, 'Français', 'Portugais'),
(1192, 4500, 1, 21, 'Français', 'Grec'),
(1193, 4500, 1, 21, 'Français', 'Japonais'),
(1194, 3400, 1, 21, 'Français', 'Néerlandais'),
(1195, 3400, 1, 21, 'Français', 'Tchèque'),
(1196, 3400, 1, 21, 'Français', 'Slovaque'),
(1197, 7000, 1, 21, 'Français', 'Mandarin'),
(1198, 7000, 1, 21, 'Français', 'Cantonais'),
(1199, 3400, 1, 21, 'Français', 'Hongrois'),
(1200, 3400, 1, 21, 'Français', 'Polonais'),
(1201, 4500, 1, 21, 'Français', 'Serbe'),
(1202, 4500, 1, 21, 'Français', 'Vietnamien'),
(1203, 4500, 1, 21, 'Français', 'Coréen'),
(1204, 4500, 1, 21, 'Français', 'Danois'),
(1205, 3400, 1, 21, 'Français', 'Suédois'),
(1206, 4500, 1, 21, 'Français', 'Thaïlandais'),
(1207, 3400, 1, 21, 'Français', 'Croate'),
(1208, 2800, 1, 21, 'Anglais', 'Français'),
(1209, 2800, 1, 21, 'Allemand', 'Français'),
(1210, 2800, 1, 21, 'Italien', 'Français'),
(1211, 2800, 1, 21, 'Espagnol', 'Français'),
(1212, 3400, 1, 21, 'Roumain', 'Français'),
(1213, 2800, 1, 21, 'Arabe', 'Français'),
(1214, 2800, 1, 21, 'Portugais', 'Français'),
(1215, 2800, 1, 21, 'Néerlandais', 'Français');
INSERT INTO `translation_rate` (`id`, `price`, `active`, `document_id`, `language_origine`, `language_cible`) VALUES
(1216, 2800, 1, 21, 'Turc', 'Français'),
(1217, 4500, 1, 21, 'Chinois', 'Français'),
(1218, 4500, 1, 21, 'Chinois', 'Anglais'),
(1219, 2800, 1, 21, 'Russe', 'Français'),
(1220, 3400, 1, 21, 'Albanais', 'Français'),
(1221, 2800, 1, 21, 'Ukrainien', 'Français'),
(1222, 2800, 1, 21, 'Slovaque', 'Français'),
(1223, 4500, 1, 21, 'Serbe', 'Français'),
(1224, 3400, 1, 21, 'Grec', 'Français'),
(1225, 4500, 1, 21, 'Japonais', 'Français'),
(1226, 2800, 1, 21, 'Polonais', 'Français'),
(1227, 7000, 1, 21, 'Mandarin', 'Français'),
(1228, 7000, 1, 21, 'Cantonais', 'Français'),
(1229, 3400, 1, 21, 'Hongrois', 'Français'),
(1230, 3400, 1, 21, 'Géorgien', 'Français'),
(1231, 3400, 1, 21, 'Tchèque', 'Français'),
(1232, 4500, 1, 21, 'Vietnamien', 'Français'),
(1233, 4500, 1, 21, 'Coréen', 'Français'),
(1234, 4500, 1, 21, 'Danois', 'Français'),
(1235, 3400, 1, 21, 'Suédois', 'Français'),
(1236, 4500, 1, 21, 'Thaïlandais', 'Français'),
(1237, 3400, 1, 21, 'Croate', 'Français'),
(1238, 3400, 1, 21, 'Portugais', 'Espagnol'),
(1239, 3000, 1, 22, 'Français', 'Anglais'),
(1240, 3000, 1, 22, 'Français', 'Allemand'),
(1241, 3000, 1, 22, 'Français', 'Italien'),
(1242, 3000, 1, 22, 'Français', 'Espagnol'),
(1243, 3400, 1, 22, 'Français', 'Roumain'),
(1244, 3000, 1, 22, 'Français', 'Arabe'),
(1245, 3400, 1, 22, 'Français', 'Turc'),
(1246, 3000, 1, 22, 'Français', 'Russe'),
(1247, 3400, 1, 22, 'Français', 'Albanais'),
(1248, 4500, 1, 22, 'Français', 'Chinois'),
(1249, 3400, 1, 22, 'Français', 'Portugais'),
(1250, 4500, 1, 22, 'Français', 'Japonais'),
(1251, 4500, 1, 22, 'Français', 'Grec'),
(1252, 3400, 1, 22, 'Français', 'Néerlandais'),
(1253, 3400, 1, 22, 'Français', 'Tchèque'),
(1254, 3400, 1, 22, 'Français', 'Slovaque'),
(1255, 3400, 1, 22, 'Français', 'Hongrois'),
(1256, 7000, 1, 22, 'Français', 'Cantonais'),
(1257, 7000, 1, 22, 'Français', 'Mandarin'),
(1258, 3400, 1, 22, 'Français', 'Polonais'),
(1259, 4500, 1, 22, 'Français', 'Serbe'),
(1260, 4500, 1, 22, 'Français', 'Vietnamien'),
(1261, 4500, 1, 22, 'Français', 'Coréen'),
(1262, 4500, 1, 22, 'Français', 'Danois'),
(1263, 3400, 1, 22, 'Français', 'Suédois'),
(1264, 4500, 1, 22, 'Français', 'Thaïlandais'),
(1265, 3400, 1, 22, 'Français', 'Croate'),
(1266, 3000, 1, 22, 'Anglais', 'Français'),
(1267, 3000, 1, 22, 'Allemand', 'Français'),
(1268, 3000, 1, 22, 'Italien', 'Français'),
(1269, 3000, 1, 22, 'Espagnol', 'Français'),
(1270, 3400, 1, 22, 'Roumain', 'Français'),
(1271, 3000, 1, 22, 'Arabe', 'Français'),
(1272, 3000, 1, 22, 'Portugais', 'Français'),
(1273, 3000, 1, 22, 'Néerlandais', 'Français'),
(1274, 3000, 1, 22, 'Turc', 'Français'),
(1275, 4500, 1, 22, 'Chinois', 'Français'),
(1276, 4500, 1, 22, 'Chinois', 'Anglais'),
(1277, 3000, 1, 22, 'Russe', 'Français'),
(1278, 3400, 1, 22, 'Albanais', 'Français'),
(1279, 3000, 1, 22, 'Ukrainien', 'Français'),
(1280, 3000, 1, 22, 'Slovaque', 'Français'),
(1281, 4500, 1, 22, 'Serbe', 'Français'),
(1282, 3400, 1, 22, 'Grec', 'Français'),
(1283, 4500, 1, 22, 'Japonais', 'Français'),
(1284, 3000, 1, 22, 'Polonais', 'Français'),
(1285, 7000, 1, 22, 'Mandarin', 'Français'),
(1286, 7000, 1, 22, 'Cantonais', 'Français'),
(1287, 3400, 1, 22, 'Hongrois', 'Français'),
(1288, 3400, 1, 22, 'Géorgien', 'Français'),
(1289, 3400, 1, 22, 'Tchèque', 'Français'),
(1290, 3400, 1, 22, 'Slovaque', 'Français'),
(1291, 4500, 1, 22, 'Vietnamien', 'Français'),
(1292, 4500, 1, 22, 'Coréen', 'Français'),
(1293, 4500, 1, 22, 'Danois', 'Français'),
(1294, 3400, 1, 22, 'Suédois', 'Français'),
(1295, 4500, 1, 22, 'Thaïlandais', 'Français'),
(1296, 3400, 1, 22, 'Croate', 'Français'),
(1297, 3400, 1, 22, 'Portugais', 'Espagnol'),
(1298, 3400, 1, 22, 'Espagnol', 'Portugais'),
(1299, 4500, 1, 1, 'Birman', 'Français');

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
-- Index pour la table `client_document_payment_link`
--
ALTER TABLE `client_document_payment_link`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_303F44D8C2745D0C` (`client_document_id`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT pour la table `app_order_item`
--
ALTER TABLE `app_order_item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT pour la table `app_user`
--
ALTER TABLE `app_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--
-- AUTO_INCREMENT pour la table `client_document_payment_link`
--
ALTER TABLE `client_document_payment_link`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `contact`
--
ALTER TABLE `contact`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT pour la table `document`
--
ALTER TABLE `document`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1300;

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
-- Contraintes pour la table `client_document_payment_link`
--
ALTER TABLE `client_document_payment_link`
  ADD CONSTRAINT `FK_303F44D8C2745D0C` FOREIGN KEY (`client_document_id`) REFERENCES `client_document` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `translation_rate`
--
ALTER TABLE `translation_rate`
  ADD CONSTRAINT `FK_F2CE9CA2C33F7837` FOREIGN KEY (`document_id`) REFERENCES `document` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
