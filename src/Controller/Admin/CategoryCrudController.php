<?php

namespace App\Controller\Admin;

use App\Entity\Category;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\IdField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextEditorField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;

class CategoryCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return Category::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setEntityLabelInSingular('Catégorie')
            ->setEntityLabelInPlural('Catégories')
            ->setPageTitle(Crud::PAGE_INDEX, '📁 Gestion des Catégories')
            ->setPageTitle(Crud::PAGE_DETAIL, 'Détails de la Catégorie')
            ->setPageTitle(Crud::PAGE_EDIT, '✏️ Éditer Catégorie')
            ->setPageTitle(Crud::PAGE_NEW, '➕ Créer une Nouvelle Catégorie')
            ->showEntityActionsInlined()
            ->setDefaultSort(['id' => 'DESC']);
    }

    public function configureActions(Actions $actions): Actions
    {
        return $actions
            ->add(Crud::PAGE_INDEX, Action::DETAIL)
            ->update(Crud::PAGE_INDEX, Action::NEW, function (Action $action) {
                return $action->setLabel('➕ Ajouter une Catégorie')
                    ->setCssClass('btn btn-success');
            })
            ->update(Crud::PAGE_INDEX, Action::DELETE, function (Action $action) {
                return $action->setLabel('🗑️ Supprimer');
            })
            ->update(Crud::PAGE_INDEX, Action::EDIT, function (Action $action) {
                return $action->setLabel('✏️ Éditer');
            })
            ->update(Crud::PAGE_DETAIL, Action::DELETE, function (Action $action) {
                return $action->setLabel('🗑️ Supprimer la Catégorie')
                    ->setCssClass('btn btn-danger');
            });
    }

    public function configureFields(string $pageName): iterable
    {
        $fields = [
            IdField::new('id')
                ->onlyOnDetail(),
        ];

        if ($pageName !== Crud::PAGE_INDEX) {
            $fields[] = TextField::new('name')
                ->setLabel('📝 Nom de la Catégorie')
                ->setHelp('Le nom affiché pour cette catégorie')
                ->setRequired(true);

            $fields[] = TextField::new('slug')
                ->setLabel('🔗 URL Slug')
                ->setHelp('Version URL-friendly du nom (ex: "mes-services")')
                ->hideOnIndex();
        } else {
            $fields[] = TextField::new('name')
                ->setLabel('Catégorie');
        }

        return $fields;
    }

}
