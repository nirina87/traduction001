<?php

namespace App\Controller\Admin;

use App\Entity\ClientDocument;
use Doctrine\ORM\QueryBuilder;
use EasyCorp\Bundle\EasyAdminBundle\Collection\FieldCollection;
use EasyCorp\Bundle\EasyAdminBundle\Collection\FilterCollection;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Config\Filters;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Dto\EntityDto;
use EasyCorp\Bundle\EasyAdminBundle\Dto\SearchDto;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateTimeField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IdField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IntegerField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Field\UrlField;
use EasyCorp\Bundle\EasyAdminBundle\Filter\ChoiceFilter;
use EasyCorp\Bundle\EasyAdminBundle\Filter\NullFilter;
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

    public function configureFilters(Filters $filters): Filters
    {
        return $filters
            ->add(NullFilter::new('order')
                ->setLabel('Rattaché à une commande')
                ->setChoiceLabels('Non rattaché', 'Rattaché à une commande'))
            ->add(ChoiceFilter::new('order.status', 'Statut de paiement')->setChoices([
                'Payé' => 'paid',
                'Paiement en attente' => 'pending',
            ]));
    }

    public function createIndexQueryBuilder(SearchDto $searchDto, EntityDto $entityDto, FieldCollection $fields, FilterCollection $filters): QueryBuilder
    {
        return parent::createIndexQueryBuilder($searchDto, $entityDto, $fields, $filters)
            ->leftJoin('entity.order', 'paymentOrder')
            ->addSelect('paymentOrder');
    }

    public function configureFields(string $pageName): iterable
    {
        return [
            IdField::new('id')->onlyOnDetail(),
            AssociationField::new('user')
                ->setLabel('Client')
                ->formatValue(fn ($value, ClientDocument $entity) => $entity->getUser()?->getEmail() ?? '—'),
            TextField::new('paymentStatusLabel')
                ->setLabel('Statut paiement')
                ->onlyOnIndex()
                ->formatValue(fn (?string $value, ClientDocument $entity) => match ($entity->getPaymentStatus()) {
                    'paid' => '<span class="badge bg-success">Payé</span>',
                    'pending' => '<span class="badge bg-warning text-dark">Paiement en attente</span>',
                    default => '<span class="badge bg-secondary">Non rattaché</span>',
                })
                ->renderAsHtml(),
            AssociationField::new('document')->setLabel('Document à traduire'),
            TextField::new('title')->setLabel('Nom du fichier envoyé'),
            TextField::new('language')->setLabel('Langue demandée'),
            IntegerField::new('price')->setLabel('Prix estimé (centimes)'),
            BooleanField::new('receiveByPaper')->setLabel('Réception par papier'),
            TextField::new('order')
                ->setLabel('Commande liée')
                ->onlyOnDetail()
                ->formatValue(fn ($value, ClientDocument $entity) => $this->formatOrderSummary($entity))
                ->renderAsHtml(),
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

    private function formatOrderSummary(ClientDocument $entity): string
    {
        $order = $entity->getOrder();
        if (null === $order) {
            return '—';
        }

        $statusBadge = match ($order->getStatus()) {
            'paid' => '<span class="badge bg-success">Payé</span>',
            default => '<span class="badge bg-warning text-dark">Paiement en attente</span>',
        };

        return sprintf(
            '%s — %s — %s € (%s)',
            $order->getInvoiceNumber() ?? 'Sans n°',
            $statusBadge,
            $order->getTotal(),
            $order->getCreatedAt()?->format('d/m/Y H:i') ?? '—',
        );
    }
}
