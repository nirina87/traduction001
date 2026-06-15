# Documentation technique — traduction001

## 1. Vue d'ensemble

**traduction001** est une application web de services de traduction de documents administratifs. Elle permet aux visiteurs de :

- consulter un site vitrine (accueil, services, contact, articles de blog) ;
- parcourir un catalogue de types de documents à traduire ;
- gérer un panier en session ;
- s'inscrire, se connecter et payer via **Stripe Checkout** ;
- recevoir une facture après commande.

Un **back-office** (`/admin`) permet de gérer les catégories, articles, documents administratifs et messages de contact.

---

## 2. Stack technique

| Composant | Technologie | Version |
|-----------|-------------|---------|
| Langage | PHP | ≥ 8.1 |
| Framework | Symfony | 6.4.* |
| ORM | Doctrine ORM | ^3.6 |
| Migrations | Doctrine Migrations | ^3.7 |
| Base de données | MySQL (via `DATABASE_URL`) | — |
| Templates | Twig | ^2.12 \| ^3.0 |
| Back-office | EasyAdmin Bundle | ^4.29 |
| Upload fichiers | VichUploaderBundle | ^2.9 |
| Paiement | Stripe Checkout (API REST via cURL) | — |
| E-mail | Symfony Mailer | 6.4.* |
| Assets JS modernes | Asset Mapper, Stimulus, Turbo | 2.34 |
| Frontend public | Bootstrap, thème Porto (assets statiques dans `public/`) | — |
| Tests | PHPUnit | ^9.5 |

**Dépendances notables** : `stripe/stripe-php` est déclaré dans `composer.json` mais le paiement est implémenté directement avec cURL dans `CheckoutController`.

---

## 3. Architecture applicative

L'application suit l'architecture standard **Symfony MVC** :

```
Requête HTTP
    → public/index.php
    → Kernel (MicroKernelTrait)
    → Route (attributs PHP sur les contrôleurs)
    → Contrôleur
    → (Doctrine ORM / Session / Mailer / Stripe API)
    → Template Twig
    → Réponse HTTP
```

### Couches principales

| Couche | Emplacement | Rôle |
|--------|-------------|------|
| Contrôleurs front | `src/Controller/` | Pages publiques, panier, checkout |
| Contrôleurs admin | `src/Controller/Admin/` | CRUD EasyAdmin |
| Entités | `src/Entity/` | Modèle de données Doctrine |
| Repositories | `src/Repository/` | Accès base de données |
| Vues | `templates/` | Rendu HTML Twig |
| Configuration | `config/` | Services, sécurité, bundles |
| Assets publics | `public/` | CSS, JS, images, uploads |
| Migrations | `migrations/` | Schéma base de données |

---

## 4. Structure du dépôt

```
traduction001/
├── assets/                 # JS moderne (Stimulus / importmap)
├── config/                 # Configuration Symfony
├── documentations/         # Documentation projet
├── migrations/             # Migrations Doctrine
├── public/                 # Point d'entrée web + assets statiques
│   ├── index.php
│   ├── css/, js/, img/, vendor/
│   └── uploads/            # Fichiers uploadés (articles, documents)
├── src/
│   ├── Controller/
│   ├── Entity/
│   ├── Repository/
│   └── Kernel.php
├── templates/
│   ├── admin/
│   ├── page/
│   └── security/
├── tests/
├── .env                    # Variables d'environnement (non versionné en prod)
└── composer.json
```

---

## 5. Modèle de données

### Schéma relationnel

```
Category 1──* Article
User 1──* Order 1──* OrderItem
Contact (entité autonome)
Product (entité autonome — documents administratifs)
```

### Entités

#### `Category`
- `name`, `slug`
- Relation `OneToMany` vers `Article`

#### `Article`
- Contenu éditorial : `title`, `slug` (unique), `creation`, `metacription`, `words`, `content1`, `content2`, `images`
- Images via VichUploader : `bannerFile` / `bannerName`, `featuredFile` / `featuredName`
- URL publique : `/{category.slug}/{article.slug}`

#### `Contact`
- Formulaire de contact : `nom`, `prenom`, `email`, `telephone`, `message`, `createdAt`

#### `Product` (documents administratifs)
- Géré en back-office, distinct du catalogue e-commerce
- Champs : `title`, `reference`, `type`, `description`, `issuedAt`, `validUntil`, `status`
- Fichier joint via VichUploader : `documentFile` / `documentName`

#### `User` (table `app_user`)
- Authentification : `email` (unique), `password`, `roles`
- Profil : `firstName`, `lastName`, `company`, `phone`, `createdAt`
- Relation `OneToMany` vers `Order`

#### `Order` (table `app_order`)
- `user`, `total`, `currency` (EUR), `status` (`pending`, `paid`, …)
- `stripeSessionId`, `invoiceNumber`, `createdAt`
- Relation `OneToMany` vers `OrderItem`

#### `OrderItem` (table `app_order_item`)
- Snapshot produit au moment de la commande : `productId`, `title`, `description`, `quantity`, `unitPrice`, `total`

### Catalogue e-commerce (hors base de données)

Les produits vendus en ligne **ne proviennent pas** de l'entité `Product`. Ils sont définis en dur dans deux méthodes dupliquées :

- `PageController::getProductCatalog()` — affichage et panier (sans prix)
- `CheckoutController::getCatalog()` — checkout Stripe (avec prix en centimes)

10 types de documents sont proposés (acte de naissance, certificat de mariage, diplôme, etc.), identifiés par un ID entier (1 à 10).

---

## 6. Routage et contrôleurs

Les routes sont déclarées par **attributs PHP** (`#[Route]`) dans `src/Controller/`. Le chargement automatique est configuré dans `config/routes.yaml`.

### Routes publiques (`PageController`)

| Route | Nom | Description |
|-------|-----|-------------|
| `/` | `accueil` | Page d'accueil (liste des articles) |
| `/services` | `services` | Page services |
| `/qui-sommes-nous` | `qui_sommes_nous` | Page institutionnelle |
| `/mentions-legales` | `mentions_legales` | Mentions légales |
| `/agroalimentaire` | `agroalimentaire` | Page sectorielle |
| `/contact` | `contact` | Formulaire de contact |
| `/contact/ajax` | `contact_ajax` | POST AJAX — enregistrement + envoi e-mail |
| `/produit/{id}` | `produit_detail` | Fiche produit du catalogue |
| `/panier` | `panier` | Panier session |
| `/panier/ajouter/{id}` | `panier_ajouter` | POST — ajout au panier |
| `/{category}/{slug}` | `article_show` | Détail d'un article (route catch-all en fin de fichier) |

### Authentification (`SecurityController`)

| Route | Nom | Rôle |
|-------|-----|------|
| `/login` | `app_login` | Connexion administrateur |
| `/connexion` | `app_user_login` | Connexion client |
| `/logout` | `app_logout` | Déconnexion |

### E-commerce (`CheckoutController`)

| Route | Nom | Description |
|-------|-----|-------------|
| `/inscription` | `app_register` | Création de compte client |
| `/commande` | `commande` | Récapitulatif avant paiement |
| `/commande/checkout` | `commande_checkout` | Création session Stripe + commande |
| `/commande/succes` | `commande_succes` | Retour Stripe — statut `paid` |
| `/commande/annulee` | `commande_annulee` | Paiement annulé |
| `/commande/facture/{id}` | `commande_facture` | Facture HTML (propriétaire uniquement) |

### Administration

| Route | Description |
|-------|-------------|
| `/admin` | Dashboard EasyAdmin (`DashboardController`) |
| `/admin/*` | CRUD catégories, articles, documents, contacts |

---

## 7. Sécurité

Configuration dans `config/packages/security.yaml`.

### Firewalls

| Firewall | Pattern | Provider | Usage |
|----------|---------|----------|-------|
| `dev` | `^/(_profiler\|_wdt\|css\|images\|js)/` | — | Désactivé (outils dev) |
| `admin` | `^/(admin\|login)` | `users_in_memory` | Back-office |
| `main` | `^/` | `users_in_memory` | Site public et clients |

### Utilisateurs en mémoire

Les comptes sont définis statiquement dans `security.yaml` :

- `olivier88` → `ROLE_ADMIN` (accès `/admin`)
- `olivier88_user` → `ROLE_USER`

### Contrôle d'accès

- `/connexion` et `/login` : accès public
- `/admin` : `ROLE_ADMIN` requis

### Point d'attention important

L'inscription client (`/inscription`) **persiste un utilisateur en base** (`User` / table `app_user`), mais l'authentification front utilise le provider **`users_in_memory`**, pas `UserRepository`.

Conséquence : un client inscrit via le formulaire ne pourra pas se connecter avec son e-mail/mot de passe tant que le provider Doctrine n'est pas configuré. Le checkout exige pourtant un utilisateur connecté (`CheckoutController::checkout`).

**Évolution recommandée** : ajouter un `entity` provider sur `App\Entity\User` pour le firewall `main`, en conservant le provider mémoire pour `admin`.

---

## 8. Flux e-commerce et paiement Stripe

### Panier (session Symfony)

Le panier est stocké en session sous la clé `cart` :

```php
[
    productId => [
        'id' => int,
        'title' => string,
        'description' => string,
        'image' => string,
        'quantity' => int,
    ],
]
```

### Flux de commande

```
Panier → /commande → (connexion requise) → /commande/checkout
    → Création Order (status: pending) + OrderItems
    → Appel API Stripe Checkout Sessions (cURL)
    → Redirection vers Stripe
    → Retour /commande/succes?session_id=...
    → Mise à jour Order (status: paid)
```

### Intégration Stripe

- Variable d'environnement : `STRIPE_SECRET_KEY`
- Appel direct à `https://api.stripe.com/v1/checkout/sessions`
- Montants en **centimes** (ex. `4500` = 45,00 €)
- Métadonnée `user_id` transmise à Stripe
- Numéro de facture généré : `FACT-YYYYMMDD-XXXX`

### Limites actuelles

- Pas de webhook Stripe : le statut `paid` est défini uniquement au retour sur `/commande/succes` (pas de vérification serveur de la session).
- Pas de validation côté serveur que le paiement Stripe a réellement abouti avant de marquer la commande payée.

---

## 9. Back-office (EasyAdmin)

Point d'entrée : `DashboardController` (`/admin`).

### Modules CRUD

| Contrôleur | Entité | Fonctionnalités |
|------------|--------|-----------------|
| `CategoryCrudController` | `Category` | Nom, slug |
| `ArticleCrudController` | `Article` | Éditeur riche, slug auto, images Vich |
| `ProductCrudController` | `Product` | Documents administratifs, upload fichier |
| `ContactCrudController` | `Contact` | Lecture des messages reçus |

Le dashboard affiche des statistiques (nombre de catégories/articles, articles récents, derniers contacts).

Assets admin personnalisés : `public/css/admin.css`.

---

## 10. Gestion des fichiers (VichUploader)

Configuration : `config/packages/vich_uploader.yaml`.

| Mapping | URI publique | Destination |
|---------|--------------|-------------|
| `article_images` | `/uploads/articles` | `public/uploads/articles` |
| `administrative_documents` | `/uploads/documents` | `public/uploads/documents` |

Stratégie de nommage : `SmartUniqueNamer` (noms de fichiers uniques).

---

## 11. E-mails

Configuration : `MAILER_DSN` dans `.env` (SMTP o2switch).

Le formulaire de contact (`PageController::ajax`) :

1. Enregistre le message en base (`Contact`)
2. Envoie un e-mail HTML aux destinataires configurés dans le contrôleur

> **Note** : les en-têtes d'e-mail et certaines métadonnées du site (`base.html.twig`) contiennent encore des références à un ancien projet (« ESPACE HYGIENE 3D »). À harmoniser avec l'identité du site de traduction.

---

## 12. Frontend

### Templates

- `templates/base.html.twig` : layout principal (Bootstrap, thème Porto)
- `templates/header.html.twig` / `footer.html.twig` : navigation
- `templates/page/` : pages métier
- `templates/security/` : login, inscription
- `templates/admin/` : dashboard personnalisé

### Assets

- **Statiques** : `public/css/`, `public/js/`, `public/vendor/`, `public/img/`
- **Modernes** : `assets/app.js` via Symfony Asset Mapper et importmap (`importmap.php`) avec Stimulus et Turbo

Le front public repose majoritairement sur des assets statiques précompilés ; Stimulus/Turbo sont configurés mais peu utilisés dans les templates actuels.

---

## 13. Configuration et variables d'environnement

| Variable | Usage |
|----------|-------|
| `APP_ENV` | Environnement (`dev`, `prod`, `test`) |
| `APP_SECRET` | Clé secrète Symfony |
| `DATABASE_URL` | Connexion MySQL |
| `MAILER_DSN` | Transport e-mail |
| `MESSENGER_TRANSPORT_DSN` | File d'attente Doctrine (configuré, peu exploité) |
| `STRIPE_SECRET_KEY` | Clé secrète API Stripe (à ajouter dans `.env.local`) |

### Installation locale (résumé)

```bash
composer install
cp .env .env.local   # adapter DATABASE_URL, STRIPE_SECRET_KEY, etc.
php bin/console doctrine:database:create
php bin/console doctrine:migrations:migrate
symfony server:start   # ou configuration Apache/Nginx vers public/
```

Répertoires uploads à rendre inscriptibles :

```bash
mkdir -p public/uploads/articles public/uploads/documents
chmod -R 775 public/uploads
```

---

## 14. Base de données et migrations

Migration existante : `migrations/Version20260609110232.php`

Crée les tables : `article`, `category`, `contact`, `product`, `messenger_messages`.

Ajoute des clés étrangères sur `app_order` et `app_order_item`, mais **ne crée pas** ces tables ni `app_user` dans le `up()`. Ces tables doivent avoir été créées séparément (migration antérieure ou `doctrine:schema:update`). À vérifier lors d'une installation from scratch.

---

## 15. Tests

Emplacement : `tests/Controller/CheckoutFlowTest.php`

Tests actuels (PHPUnit + `WebTestCase`) :

- Accessibilité de `/panier`
- Accessibilité de `/inscription`

Couverture limitée : pas de tests sur Stripe, panier, authentification ni back-office.

```bash
php bin/phpunit
```

---

## 16. Diagramme de flux simplifié

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│  Visiteur   │────▶│ PageController│────▶│   Twig      │
└─────────────┘     └──────────────┘     └─────────────┘
       │                    │
       │ ajout panier       │ articles/contact
       ▼                    ▼
┌─────────────┐     ┌──────────────┐
│   Session   │     │   Doctrine   │
│   (cart)    │     │   (MySQL)    │
└─────────────┘     └──────────────┘
       │
       ▼
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│  Checkout   │────▶│    Stripe    │────▶│  Order DB   │
│ Controller  │     │   Checkout   │     │  (paid)     │
└─────────────┘     └──────────────┘     └─────────────┘

┌─────────────┐     ┌──────────────┐
│   Admin     │────▶│  EasyAdmin   │────▶ Doctrine
│  /login     │     │   /admin     │
└─────────────┘     └──────────────┘
```

---

## 17. Dette technique et évolutions recommandées

| Sujet | Description | Priorité |
|-------|-------------|----------|
| Authentification client | Brancher `UserRepository` comme provider Doctrine pour le firewall `main` | Haute |
| Catalogue produits | Centraliser le catalogue (service dédié ou entité) — éviter la duplication PageController / CheckoutController | Moyenne |
| Webhook Stripe | Valider les paiements côté serveur (`checkout.session.completed`) | Haute |
| Migration incomplète | Ajouter la création de `app_user`, `app_order`, `app_order_item` | Moyenne |
| SDK Stripe | Utiliser `stripe/stripe-php` déjà installé plutôt que cURL manuel | Basse |
| Contenu résiduel | Mettre à jour métadonnées SEO et e-mails (ancien projet hygiène) | Moyenne |
| `stripe/stripe-php` | Variable `STRIPE_SECRET_KEY` absente du `.env` exemple — documenter dans `.env.local` | Haute |
| Route `article_show` | Placée en dernier dans `PageController` — risque de conflit avec d'autres routes si mal ordonnées | Basse |

---

## 18. Références utiles

- [Documentation Symfony 6.4](https://symfony.com/doc/6.4/index.html)
- [EasyAdmin 4](https://symfony.com/bundles/EasyAdminBundle/current/index.html)
- [VichUploaderBundle](https://github.com/dustin10/VichUploaderBundle)
- [Stripe Checkout](https://docs.stripe.com/payments/checkout)
- [Doctrine Migrations](https://www.doctrine-project.org/projects/doctrine-migrations/en/latest/index.html)
