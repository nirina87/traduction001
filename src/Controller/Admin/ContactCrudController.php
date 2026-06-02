<?php

namespace App\Controller\Admin;

use App\Entity\Contact;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateTimeField;

class ContactCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return Contact::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setPageTitle('index', '📩 Liste des contacts')
            ->setDefaultSort(['createdAt' => 'DESC'])
            ->setPaginatorPageSize(10); // 🔥 pagination
    }

    public function configureFields(string $pageName): iterable
    {
        return [
            TextField::new('nom', 'Nom'),
            TextField::new('prenom', 'Prénom'),
            TextField::new('email', 'Email'),
            TextField::new('telephone', 'Téléphone'),

            // Message court dans la liste
            TextareaField::new('message', 'Message')
                ->formatValue(fn ($value) => substr($value, 0, 50).'...')
                ->onlyOnIndex(),

            // Message complet en édition
            TextareaField::new('message', 'Message')
                ->hideOnIndex(),

            DateTimeField::new('createdAt', 'Date'),
        ];
    }
}