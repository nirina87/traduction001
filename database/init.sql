CREATE TABLE IF NOT EXISTS article (
  id int NOT NULL AUTO_INCREMENT,
  category_id int DEFAULT NULL,
  title text,
  creation date DEFAULT NULL,
  metacription text,
  words text,
  content1 text,
  content2 text,
  images text,
  slug text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  banner_name text CHARACTER SET utf8 COLLATE utf8_general_ci,
  featured_name text CHARACTER SET utf8 COLLATE utf8_general_ci,
  updated_at text CHARACTER SET utf8 COLLATE utf8_general_ci,
  PRIMARY KEY (id),
  KEY FK_ARTICLE_CATEGORY (category_id)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table article
--


DROP TABLE IF EXISTS category;
CREATE TABLE IF NOT EXISTS category (
  id int NOT NULL AUTO_INCREMENT,
  name varchar(255) DEFAULT NULL,
  slug text,
  PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;

--
-- Structure de la table contact
--

DROP TABLE IF EXISTS contact;
CREATE TABLE IF NOT EXISTS contact (
  id int NOT NULL AUTO_INCREMENT,
  nom varchar(255) NOT NULL,
  prenom varchar(255) NOT NULL,
  email varchar(255) NOT NULL,
  telephone varchar(50) DEFAULT NULL,
  message text,
  created_at datetime NOT NULL,
  PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
COMMIT;