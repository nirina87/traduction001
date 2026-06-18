<?php

namespace App\Controller\Admin;

use App\Entity\ClientDocument;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateTimeField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IdField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IntegerField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Field\UrlField;
use Vich\UploaderBundle\Form\Type\VichFileType;

class ClientDocumentCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return ClientDocument::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setEntityLabelInSingular('Document client')
            ->setEntityLabelInPlural('Documents clients')
            ->setPageTitle(Crud::PAGE_INDEX, '📎 Gestion des documents clients')
            ->setDefaultSort(['uploadedAt' => 'DESC']);
    }

    public function configureActions(Actions $actions): Actions
    {
        return $actions
            ->add(Crud::PAGE_INDEX, Action::DETAIL)
            ->update(Crud::PAGE_INDEX, Action::NEW, fn (Action $action) => $action->setLabel('➕ Ajouter un document client'));
    }

    public function configureFields(string $pageName): iterable
    {
        return [
            IdField::new('id')->onlyOnDetail(),
            AssociationField::new('user')->setLabel('Client'),
            AssociationField::new('document')->setLabel('Document à traduire'),
            TextField::new('title')->setLabel('Nom du fichier envoyé'),
            TextField::new('language')->setLabel('Langue demandée'),
            IntegerField::new('price')->setLabel('Prix estimé (centimes)'),
            DateTimeField::new('uploadedAt')->setLabel('Date d’envoi')->hideOnForm(),
            UrlField::new('fileUrl')
                ->setLabel('Document')
                ->onlyOnIndex()
                ->formatValue(fn (?string $value, ClientDocument $entity) => $entity->getFileName() ?? '—'),
            UrlField::new('fileUrl')
                ->setLabel('Fichier envoyé')
                ->onlyOnDetail(),
            TextField::new('file')->setFormType(VichFileType::class)->setLabel('Fichier envoyé')->hideOnIndex(),
        ];
    }
}
