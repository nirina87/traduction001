<?php

namespace App\Controller\Admin;

use App\Entity\Document;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IdField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IntegerField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextEditorField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ImageField;

class DocumentCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return Document::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setEntityLabelInSingular('Document à traduire')
            ->setEntityLabelInPlural('Documents à traduire')
            ->setPageTitle(Crud::PAGE_INDEX, '📚 Gestion des documents à traduire')
            ->setDefaultSort(['id' => 'DESC']);
    }

    public function configureActions(Actions $actions): Actions
    {
        return $actions
            ->add(Crud::PAGE_INDEX, Action::DETAIL)
            ->update(Crud::PAGE_INDEX, Action::NEW, fn (Action $action) => $action->setLabel('➕ Ajouter un document'));
    }

    public function configureFields(string $pageName): iterable
    {
        return [
            IdField::new('id')->onlyOnDetail(),
            TextField::new('name')->setLabel('Nom du document')->setRequired(true),
            TextEditorField::new('description')->setLabel('Description')->hideOnIndex(),
            TextField::new('category')->setLabel('Catégorie'),
            IntegerField::new('basePrice')
                ->setLabel('Prix de base (centimes)')
                ->setHelp('Exemple : 4500 = 45,00 €')
                ->setRequired(true),
            BooleanField::new('active')->setLabel('Actif'),
            ImageField::new('image', 'Image')
            ->setBasePath('/uploads')
            ->setUploadDir('public/uploads/')
            ->setUploadedFileNamePattern('[slug]-[timestamp].[extension]')
            ->setRequired(false)
        ];
    }
}
