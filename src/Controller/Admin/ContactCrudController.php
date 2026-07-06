<?php

namespace App\Controller\Admin;

use App\Entity\Contact;
use App\Repository\ContactRepository;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Config\KeyValueStore;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateTimeField;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;

class ContactCrudController extends AbstractCrudController
{
    public function __construct(
        private readonly ContactRepository $contactRepository,
    ) {
    }

    public static function getEntityFqcn(): string
    {
        return Contact::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setEntityLabelInSingular('Message')
            ->setEntityLabelInPlural('Messages reçus')
            ->setPageTitle(Crud::PAGE_INDEX, 'Messages reçus')
            ->setPageTitle(Crud::PAGE_EDIT, static fn (Contact $contact) => sprintf('%s — %s', $contact->getContactReference(), $contact->getFullName()))
            ->setDefaultSort(['createdAt' => 'DESC'])
            ->setSearchFields(null)
            ->setPaginatorPageSize(15)
            ->setDefaultRowAction(Action::EDIT)
            ->overrideTemplate('crud/index', 'admin/contact/index.html.twig')
            ->overrideTemplate('crud/edit', 'admin/contact/edit.html.twig');
    }

    public function configureActions(Actions $actions): Actions
    {
        return $actions
            ->disable(Action::BATCH_DELETE)
            ->update(Crud::PAGE_INDEX, Action::NEW, fn (Action $action) => $action->displayIf(static fn () => false))
            ->update(Crud::PAGE_INDEX, Action::DELETE, fn (Action $action) => $action->displayIf(static fn () => false))
            ->add(Crud::PAGE_EDIT, Action::INDEX)
            ->update(Crud::PAGE_EDIT, Action::INDEX, fn (Action $action) => $action->displayIf(static fn () => false))
            ->add(Crud::PAGE_EDIT, Action::DELETE)
            ->update(Crud::PAGE_EDIT, Action::DELETE, fn (Action $action) => $action
                ->setLabel('Supprimer')
                ->setCssClass('btn btn-outline btn-sm doc-action-delete')
                ->askConfirmation(
                    'Êtes-vous sûr de vouloir supprimer le message %entity_id% ? Cette action est irréversible.',
                    'Valider la suppression',
                ))
            ->update(Crud::PAGE_EDIT, Action::SAVE_AND_RETURN, fn (Action $action) => $action
                ->setLabel('Enregistrer'))
            ->update(Crud::PAGE_EDIT, Action::SAVE_AND_CONTINUE, fn (Action $action) => $action
                ->setLabel('Enregistrer et continuer')
                ->setCssClass('btn btn-secondary action-saveAndContinue'));
    }

    public function configureFields(string $pageName): iterable
    {
        if (Crud::PAGE_INDEX === $pageName) {
            yield from $this->getIndexFields();

            return;
        }

        yield from $this->getFormFields();
    }

    public function configureResponseParameters(KeyValueStore $responseParameters): KeyValueStore
    {
        if (Crud::PAGE_INDEX === $responseParameters->get('pageName')) {
            $responseParameters->set('indexStats', $this->contactRepository->getIndexStats());
        }

        return $responseParameters;
    }

    private function getIndexFields(): iterable
    {
        yield TextField::new('fullName')
            ->setLabel('Contact')
            ->formatValue(fn (?string $value, Contact $contact) => $contact->getFullName());
        yield TextField::new('coordinates')
            ->setLabel('Coordonnées')
            ->formatValue(fn (?string $value, Contact $contact) => $this->renderView(
                'admin/contact/_coordinates.html.twig',
                ['contact' => $contact],
            ))
            ->renderAsHtml();
        yield TextField::new('message')
            ->setLabel('Message')
            ->formatValue(fn (?string $value) => $this->truncateMessage($value));
        yield DateTimeField::new('createdAt')
            ->setLabel('Reçu le')
            ->setFormat('dd/MM/yyyy');
    }

    private function getFormFields(): iterable
    {
        yield FormField::addFieldset('Identité');
        yield TextField::new('prenom', 'Prénom');
        yield TextField::new('nom', 'Nom');

        yield FormField::addFieldset('Coordonnées');
        yield TextField::new('email', 'Email');
        yield TextField::new('telephone', 'Téléphone');

        yield FormField::addFieldset('Message reçu');
        yield TextareaField::new('message', 'Message')
            ->setFormTypeOption('attr', ['rows' => 10]);
    }

    private function truncateMessage(?string $message, int $length = 60): string
    {
        if (null === $message || '' === $message) {
            return '—';
        }

        if (mb_strlen($message) <= $length) {
            return $message;
        }

        return mb_substr($message, 0, $length).'…';
    }
}
