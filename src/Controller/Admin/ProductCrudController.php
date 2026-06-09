<?php

namespace App\Controller\Admin;

use App\Entity\Product;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\ChoiceField;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateField;
use EasyCorp\Bundle\EasyAdminBundle\Field\Field;
use EasyCorp\Bundle\EasyAdminBundle\Field\IdField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextEditorField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use Vich\UploaderBundle\Form\Type\VichFileType;

class ProductCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return Product::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setEntityLabelInSingular('Document administratif')
            ->setEntityLabelInPlural('Documents administratifs')
            ->setPageTitle(Crud::PAGE_INDEX, '📄 Gestion des documents administratifs')
            ->setPageTitle(Crud::PAGE_DETAIL, 'Détail du document')
            ->setPageTitle(Crud::PAGE_EDIT, '✏️ Modifier un document')
            ->setPageTitle(Crud::PAGE_NEW, '➕ Ajouter un document administratif')
            ->showEntityActionsInlined()
            ->setDefaultSort(['issuedAt' => 'DESC']);
    }

    public function configureActions(Actions $actions): Actions
    {
        return $actions
            ->add(Crud::PAGE_INDEX, Action::DETAIL)
            ->update(Crud::PAGE_INDEX, Action::NEW, function (Action $action) {
                return $action->setLabel('➕ Ajouter un document')
                    ->setCssClass('btn btn-success');
            })
            ->update(Crud::PAGE_INDEX, Action::EDIT, function (Action $action) {
                return $action->setLabel('✏️ Modifier');
            })
            ->update(Crud::PAGE_INDEX, Action::DELETE, function (Action $action) {
                return $action->setLabel('🗑️ Supprimer');
            })
            ->update(Crud::PAGE_DETAIL, Action::DELETE, function (Action $action) {
                return $action->setLabel('🗑️ Supprimer le document')
                    ->setCssClass('btn btn-danger');
            });
    }

    public function configureFields(string $pageName): iterable
    {
        $fields = [];

        if (Crud::PAGE_DETAIL === $pageName) {
            $fields[] = IdField::new('id');
        }

        $fields[] = TextField::new('title')
            ->setLabel('📝 Intitulé du document')
            ->setHelp('Nom officiel du produit / document administratif')
            ->setRequired(true);

        $fields[] = TextField::new('reference')
            ->setLabel('🔢 Référence')
            ->setHelp('Numéro de référence ou code administratif');

        $fields[] = ChoiceField::new('type')
            ->setLabel('📂 Type de document')
            ->setChoices([
                'Attestation' => 'Attestation',
                'Autorisation' => 'Autorisation',
                'Certificat' => 'Certificat',
                'Formulaire' => 'Formulaire',
                'Avis' => 'Avis',
                'Rapport' => 'Rapport',
            ])
            ->setRequired(true);

        $fields[] = ChoiceField::new('status')
            ->setLabel('✅ Statut')
            ->setChoices([
                'Actif' => 'Actif',
                'En attente' => 'En attente',
                'Expiré' => 'Expiré',
            ]);

        $fields[] = DateField::new('issuedAt')
            ->setLabel('📅 Date de publication')
            ->setRequired(true);

        $fields[] = DateField::new('validUntil')
            ->setLabel('🗓️ Date de validité');

        if ($pageName !== Crud::PAGE_INDEX) {
            $fields[] = TextEditorField::new('description')
                ->setLabel('📋 Description administrative')
                ->setHelp('Informations utiles sur le document à diffuser')
                ->hideOnIndex();

            $fields[] = Field::new('documentFile')
                ->setFormType(VichFileType::class)
                ->setLabel('📎 Fichier du document (PDF, DOCX, JPG)')
                ->setHelp('Téléverser le document administratif associé');
        }

        $fields[] = TextField::new('documentName')
            ->setLabel('Nom du fichier')
            ->onlyOnIndex();

        return $fields;
    }
}
