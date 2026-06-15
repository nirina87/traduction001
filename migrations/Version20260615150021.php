<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

final class Version20260615150021 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Ajout des tables document, translation_rate et client_document pour les documents à traduire.';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('CREATE TABLE IF NOT EXISTS document (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(150) NOT NULL, description LONGTEXT DEFAULT NULL, category VARCHAR(80) DEFAULT NULL, base_price INT DEFAULT NULL, active TINYINT(1) DEFAULT 1 NOT NULL, PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci`');
        $this->addSql('CREATE TABLE IF NOT EXISTS translation_rate (id INT AUTO_INCREMENT NOT NULL, document_id INT NOT NULL, language VARCHAR(80) NOT NULL, price INT NOT NULL, active TINYINT(1) DEFAULT 1 NOT NULL, INDEX IDX_F2CE9CA2C33F7837 (document_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci`');
        $this->addSql('CREATE TABLE IF NOT EXISTS client_document (id INT AUTO_INCREMENT NOT NULL, user_id INT DEFAULT NULL, document_id INT DEFAULT NULL, title VARCHAR(150) NOT NULL, language VARCHAR(100) DEFAULT NULL, price INT DEFAULT NULL, file_name VARCHAR(255) DEFAULT NULL, uploaded_at DATETIME DEFAULT NULL, INDEX IDX_F68FBAB3A76ED395 (user_id), INDEX IDX_F68FBAB3C33F7837 (document_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci`');

        $this->addSql('ALTER TABLE translation_rate ADD CONSTRAINT FK_F2CE9CA2C33F7837 FOREIGN KEY (document_id) REFERENCES document (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE client_document ADD CONSTRAINT FK_F68FBAB3A76ED395 FOREIGN KEY (user_id) REFERENCES app_user (id) ON DELETE SET NULL');
        $this->addSql('ALTER TABLE client_document ADD CONSTRAINT FK_F68FBAB3C33F7837 FOREIGN KEY (document_id) REFERENCES document (id) ON DELETE SET NULL');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('ALTER TABLE client_document DROP FOREIGN KEY FK_F68FBAB3C33F7837');
        $this->addSql('ALTER TABLE client_document DROP FOREIGN KEY FK_F68FBAB3A76ED395');
        $this->addSql('ALTER TABLE translation_rate DROP FOREIGN KEY FK_F2CE9CA2C33F7837');
        $this->addSql('DROP TABLE IF EXISTS client_document');
        $this->addSql('DROP TABLE IF EXISTS translation_rate');
        $this->addSql('DROP TABLE IF EXISTS document');
    }
}
