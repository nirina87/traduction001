<?php

namespace App\Controller\Admin;

use App\Entity\TranslationRate;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IdField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IntegerField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;

class TranslationRateCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return TranslationRate::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setEntityLabelInSingular('Tarif par langue')
            ->setEntityLabelInPlural('Tarifs par langue')
            ->setPageTitle(Crud::PAGE_INDEX, '🌍 Gestion des tarifs par langue')
            ->setDefaultSort(['id' => 'DESC']);
    }

    public function configureActions(Actions $actions): Actions
    {
        return $actions
            ->add(Crud::PAGE_INDEX, Action::DETAIL)
            ->update(Crud::PAGE_INDEX, Action::NEW, fn (Action $action) => $action->setLabel('➕ Ajouter un tarif'));
    }

    public function configureFields(string $pageName): iterable
    {
        return [
            IdField::new('id')->onlyOnDetail(),
            AssociationField::new('document')->setLabel('Document à traduire')->setRequired(true),
            TextField::new('languageOrigine')
                ->setLabel('Langue d\'origine')
                ->setRequired(true),
            TextField::new('languageCible')
                ->setLabel('Langue cible')
                ->setRequired(true),
            IntegerField::new('price')->setLabel('Prix (centimes)')->setRequired(true),
            BooleanField::new('active')->setLabel('Actif'),
        ];
    }
}
