<?php

namespace App\Controller\Admin;

use App\Entity\Article;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\IdField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextEditorField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateField;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use Symfony\Component\String\Slugger\SluggerInterface;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use Vich\UploaderBundle\Form\Type\VichImageType;
use EasyCorp\Bundle\EasyAdminBundle\Field\Field;
use EasyCorp\Bundle\EasyAdminBundle\Field\ImageField;

class ArticleCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return Article::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setEntityLabelInSingular('Article')
            ->setEntityLabelInPlural('Articles')
            ->setPageTitle(Crud::PAGE_INDEX, '📄 Gestion des Articles')
            ->setPageTitle(Crud::PAGE_DETAIL, 'Détails de l\'Article')
            ->setPageTitle(Crud::PAGE_EDIT, '✏️ Éditer Article')
            ->setPageTitle(Crud::PAGE_NEW, '➕ Créer un Nouvel Article')
            ->showEntityActionsInlined()
            ->setDefaultSort(['creation' => 'DESC']);
    }

    public function configureActions(Actions $actions): Actions
    {
        return $actions
            ->add(Crud::PAGE_INDEX, Action::DETAIL)
            ->update(Crud::PAGE_INDEX, Action::NEW, function (Action $action) {
                return $action->setLabel('➕ Ajouter un Article')
                    ->setCssClass('btn btn-success');
            })
            ->update(Crud::PAGE_INDEX, Action::DELETE, function (Action $action) {
                return $action->setLabel('🗑️ Supprimer');
            })
            ->update(Crud::PAGE_INDEX, Action::EDIT, function (Action $action) {
                return $action->setLabel('✏️ Éditer');
            })
            ->update(Crud::PAGE_INDEX, Action::DETAIL, function (Action $action) {
                return $action->setLabel('👁️ Voir');
            })
            ->update(Crud::PAGE_DETAIL, Action::DELETE, function (Action $action) {
                return $action->setLabel('🗑️ Supprimer l\'Article')
                    ->setCssClass('btn btn-danger');
            });
    }

    public function configureFields(string $pageName): iterable
    {
        $fields = [];

        if ($pageName === Crud::PAGE_DETAIL) {
            $fields[] = IdField::new('id');
        }

        $fields[] = TextField::new('title')
            ->setLabel('📝 Titre')
            ->setHelp('Le titre principal de l\'article')
            ->setRequired(true);
        $fields[] = SlugField::new('slug')
            ->setLabel('🔗 URL')
            ->setTargetFieldName('title')
            ->hideOnIndex();

        $fields[] = AssociationField::new('category')
            ->setLabel('📁 Catégorie')
            ->setHelp('Sélectionner la catégorie de cet article')
            ->setRequired(true);

        $fields[] = DateField::new('creation')
            ->setLabel('📅 Date de Création')
            ->setHelp('La date de publication de l\'article');

        if ($pageName !== Crud::PAGE_INDEX) {
            $fields[] = TextField::new('metacription')
                ->setLabel('🔍 Métadescription')
                ->setHelp('Description pour les moteurs de recherche')
                ->hideOnIndex();

            $fields[] = TextEditorField::new('words')
                ->setLabel('📄 Résumé')
                ->setHelp('Un court résumé de l\'article')
                ->hideOnIndex();

            $fields[] = TextEditorField::new('content1')
                ->setLabel('📖 Contenu Principal')
                ->setHelp('Le contenu principal de l\'article')
                ->hideOnIndex();

            $fields[] = TextEditorField::new('content2')
                ->setLabel('📖 Contenu Additionnel')
                ->setHelp('Contenu supplémentaire (optionnel)')
                ->hideOnIndex();

            $fields[] = TextField::new('images')
                ->setLabel('🖼️ Images')
                ->setHelp('URLs des images séparées par des virgules')
                ->hideOnIndex();
            if ($pageName !== Crud::PAGE_INDEX) {

                $fields[] = Field::new('bannerFile')
                    ->setFormType(VichImageType::class)
                    ->setLabel('🖼️ Bannière');

                $fields[] = Field::new('featuredFile')
                    ->setFormType(VichImageType::class)
                    ->setLabel('⭐ Image mise en avant');
            }

            // affichage dans liste
            $fields[] = ImageField::new('bannerName')
                ->setBasePath('/uploads/articles')
                ->onlyOnIndex();

            $fields[] = ImageField::new('featuredName')
                ->setBasePath('/uploads/articles')
                ->onlyOnIndex();
        }

        return $fields;
    }

    public function persistEntity($entityManager, $entityInstance): void
    {
        if ($entityInstance instanceof Article) {
            $slugger = new \Symfony\Component\String\Slugger\AsciiSlugger();
            $entityInstance->setSlug(strtolower($slugger->slug($entityInstance->getTitle())));
        }

        parent::persistEntity($entityManager, $entityInstance);
    }
}
