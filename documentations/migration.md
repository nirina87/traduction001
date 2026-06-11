# Migrations Doctrine — approche code first

Ce projet Symfony utilise une approche **code first** : le schéma de la base de données est défini dans les entités PHP (`src/Entity/`), puis synchronisé avec MySQL via **Doctrine Migrations**.

Les fichiers de migration sont générés dans le dossier `migrations/` (namespace `DoctrineMigrations`).

---

## Prérequis

### 1. Configurer la connexion

Définir `DATABASE_URL` dans `.env.local` (recommandé) ou `.env` :

```env
DATABASE_URL="mysql://traduction_user:traduction_password@127.0.0.1:3306/traduction?serverVersion=8.0&charset=utf8mb4"
```

Adapter l'utilisateur, le mot de passe, l'hôte et le nom de la base selon l'environnement.

### 2. Créer la base de données (première installation)

**Option A — via Symfony** (nécessite un utilisateur MySQL avec le droit `CREATE DATABASE`) :

```bash
php bin/console doctrine:database:create
```

**Option B — manuellement** (recommandé si l'option A échoue) :

Se connecter à MySQL en tant qu'administrateur (`root`) puis exécuter :

```sql
CREATE DATABASE traduction CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'traduction_user'@'localhost' IDENTIFIED BY 'traduction_password';
GRANT ALL PRIVILEGES ON traduction.* TO 'traduction_user'@'localhost';
FLUSH PRIVILEGES;
```

> Si la base existe déjà, **ne pas relancer** `doctrine:database:create`. Passer directement aux migrations.

---

## Workflow code first

```
1. Modifier ou créer une entité dans src/Entity/
2. Générer une migration à partir des différences détectées
3. Vérifier le fichier généré dans migrations/
4. Exécuter la migration sur la base
```

---

## Commandes principales

### Générer une migration (après modification des entités)

```bash
php bin/console make:migration
```

Doctrine compare les entités avec l'état actuel de la base et génère un fichier `migrations/VersionXXXXXXXXXXXX.php`.

**À faire systématiquement** : ouvrir le fichier généré et vérifier les requêtes SQL avant de l'exécuter.

---

### Exécuter les migrations en attente

```bash
php bin/console doctrine:migrations:migrate
```

Applique toutes les migrations non encore exécutées. Symfony demande une confirmation avant de lancer.

Pour lancer sans confirmation interactive (CI, scripts) :

```bash
php bin/console doctrine:migrations:migrate --no-interaction
```

---

### Première installation complète (base vide)

```bash
# Étape 1 : créer la base (voir section Prérequis — option A ou B)
php bin/console doctrine:database:create   # ou création manuelle SQL

# Étape 2 : créer les tables
php bin/console doctrine:migrations:migrate --no-interaction

# Étape 3 : vérifier
php bin/console doctrine:migrations:status
php bin/console doctrine:schema:validate
```

---

## Commandes de consultation

### Lister le statut des migrations

```bash
php bin/console doctrine:migrations:status
```

Affiche la version courante de la base, les migrations exécutées et celles en attente.

---

### Lister toutes les migrations disponibles

```bash
php bin/console doctrine:migrations:list
```

---

### Afficher le SQL d'une migration sans l'exécuter

```bash
php bin/console doctrine:migrations:migrate --dry-run
```

Utile pour prévisualiser les requêtes SQL qui seraient exécutées.

---

### Voir les différences entre entités et base (sans générer de fichier)

```bash
php bin/console doctrine:schema:update --dump-sql
```

> En production, **ne pas utiliser** `doctrine:schema:update --force`. Toujours passer par les migrations.

---

## Commandes avancées

### Revenir à la migration précédente (rollback d'une version)

```bash
php bin/console doctrine:migrations:migrate prev
```

### Revenir à une version précise

```bash
php bin/console doctrine:migrations:migrate DoctrineMigrations\\Version20260609110232
```

Remplacer par le nom de la version cible (visible via `doctrine:migrations:list`).

---

### Exécuter uniquement la prochaine migration

```bash
php bin/console doctrine:migrations:execute --up DoctrineMigrations\\Version20260609110232
```

### Annuler une migration spécifique

```bash
php bin/console doctrine:migrations:execute --down DoctrineMigrations\\Version20260609110232
```

---

### Valider le mapping des entités

```bash
php bin/console doctrine:schema:validate
```

Vérifie que le mapping Doctrine est cohérent et que la base est synchronisée avec les entités.

---

## Environnement de test

Pour les tests PHPUnit, la base de test utilise un suffixe configuré dans `config/packages/doctrine.yaml` :

```bash
# Créer la base de test
php bin/console doctrine:database:create --env=test

# Appliquer les migrations en environnement test
php bin/console doctrine:migrations:migrate --no-interaction --env=test
```

---

## Entités du projet

Les entités suivantes constituent le schéma applicatif :

| Entité | Table |
|--------|-------|
| `Category` | `category` |
| `Article` | `article` |
| `Contact` | `contact` |
| `Product` | `product` |
| `User` | `app_user` |
| `Order` | `app_order` |
| `OrderItem` | `app_order_item` |

Après toute modification de ces classes (nouveau champ, relation, contrainte…), relancer `make:migration` puis `doctrine:migrations:migrate`.

---

## Migration existante

Le projet contient la migration initiale :

```
migrations/Version20260609110232.php
```

Elle crée l'ensemble des tables : `category`, `article`, `contact`, `product`, `messenger_messages`, `app_user`, `app_order`, `app_order_item`, ainsi que les clés étrangères associées.

---

## Dépannage — erreurs courantes à la première installation

### Erreur : `Unknown database 'traduction'`

```
SQLSTATE[HY000] [1049] Unknown database 'traduction'
```

**Cause** : la base n'existe pas encore, et l'utilisateur MySQL (`traduction_user`) n'a pas le droit de la créer via Symfony.

**Solution** : créer la base manuellement avec un compte administrateur MySQL (voir **Option B** dans les prérequis), puis passer à l'étape migrations.

---

### Erreur : `Can't create database 'traduction'; database exists`

```
SQLSTATE[HY000]: General error: 1007 Can't create database 'traduction'; database exists
```

**Cause** : la base a déjà été créée (manuellement ou lors d'une tentative précédente).

**Solution** : **ignorer cette erreur**, c'est le comportement attendu. Enchaîner directement avec :

```bash
php bin/console doctrine:migrations:migrate --no-interaction
```

---

### Erreur : migration échouée à mi-parcours (tables partielles)

Si une migration échoue en cours d'exécution, certaines tables peuvent exister sans que la version soit enregistrée. Symptômes : `Table 'article' already exists` au relancement.

**Solution** (installation neuve uniquement) : supprimer les tables partielles puis relancer :

```bash
mysql -u traduction_user -p traduction -e "
  SET FOREIGN_KEY_CHECKS=0;
  DROP TABLE IF EXISTS article, category, contact, product, messenger_messages,
    app_order_item, app_order, app_user, doctrine_migration_versions;
  SET FOREIGN_KEY_CHECKS=1;
"

php bin/console doctrine:migrations:migrate --no-interaction
```

> En production avec des données, ne pas supprimer les tables : corriger manuellement ou créer une migration corrective.

---

### Vérifier que l'installation est complète

```bash
php bin/console doctrine:migrations:status    # Current = Version20260609110232, New = 0
php bin/console doctrine:schema:validate        # [OK] The database schema is in sync
```

---

## Rappels importants

| Règle | Détail |
|-------|--------|
| Ne jamais modifier une migration déjà exécutée en production | Créer une nouvelle migration à la place |
| Toujours relire le fichier généré | `make:migration` peut produire du SQL inattendu |
| Versionner les fichiers `migrations/` | Ils font partie du code source |
| Ne pas committer `.env.local` | Contient les identifiants de base de données |
| Privilégier les migrations | Éviter `doctrine:schema:update --force` en production |

---

## Référence rapide

```bash
# Workflow courant après modification d'une entité
php bin/console make:migration
php bin/console doctrine:migrations:migrate

# Diagnostic
php bin/console doctrine:migrations:status
php bin/console doctrine:schema:validate
```
