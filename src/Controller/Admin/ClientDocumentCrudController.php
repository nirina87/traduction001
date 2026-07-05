<?php

namespace App\Controller\Admin;

use App\Entity\ClientDocument;
use App\Entity\Order;
use Doctrine\ORM\EntityManagerInterface;
use Doctrine\ORM\QueryBuilder;
use EasyCorp\Bundle\EasyAdminBundle\Attribute\AdminRoute;
use EasyCorp\Bundle\EasyAdminBundle\Collection\FieldCollection;
use EasyCorp\Bundle\EasyAdminBundle\Collection\FilterCollection;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Context\AdminContext;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Dto\EntityDto;
use EasyCorp\Bundle\EasyAdminBundle\Dto\SearchDto;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ChoiceField;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateTimeField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IdField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IntegerField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Field\UrlField;
use EasyCorp\Bundle\EasyAdminBundle\Router\AdminUrlGenerator;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use Vich\UploaderBundle\Form\Type\VichFileType;

class ClientDocumentCrudController extends AbstractCrudController
{
    public function __construct(
        private readonly EntityManagerInterface $entityManager,
        private readonly AdminUrlGenerator $adminUrlGenerator,
    ) {
    }
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
            ->setDefaultSort(['uploadedAt' => 'DESC'])
            ->overrideTemplate('crud/index', 'admin/client_document/index.html.twig');
    }

    public function configureActions(Actions $actions): Actions
    {
        $updatePaymentStatus = Action::new('updatePaymentStatus', false)
            ->linkToCrudAction('updatePaymentStatus')
            ->displayIf(static fn () => false);

        $updateWorkflowStatus = Action::new('updateWorkflowStatus', false)
            ->linkToCrudAction('updateWorkflowStatus')
            ->displayIf(static fn () => false);

        return $actions
            ->add(Crud::PAGE_INDEX, Action::DETAIL)
            ->add(Crud::PAGE_INDEX, $updatePaymentStatus)
            ->add(Crud::PAGE_INDEX, $updateWorkflowStatus)
            ->update(Crud::PAGE_INDEX, Action::NEW, fn (Action $action) => $action->setLabel('➕ Ajouter un document client'));
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
                ->formatValue(fn (?string $value, ClientDocument $entity) => $this->renderPaymentStatusSelect($entity))
                ->renderAsHtml(),
            TextField::new('workflowStatusLabel')
                ->setLabel('Statut')
                ->onlyOnIndex()
                ->formatValue(fn (?string $value, ClientDocument $entity) => $this->renderView(
                    'admin/client_document/_workflow_status_select.html.twig',
                    ['doc' => $entity],
                ))
                ->renderAsHtml(),
            ChoiceField::new('status')
                ->setLabel('Statut du document')
                ->setChoices(ClientDocument::getStatusChoices())
                ->hideOnIndex(),
            AssociationField::new('document')->setLabel('Document à traduire'),
            TextField::new('title')->setLabel('Nom du fichier envoyé'),
            TextField::new('language')->setLabel('Langue demandée'),
            IntegerField::new('price')->setLabel('Prix estimé (centimes)'),
            BooleanField::new('receiveByPaper')->setLabel('Réception par papier'),
            AssociationField::new('order')
                ->setLabel('Commande liée')
                ->onlyOnDetail()
                ->formatValue(fn ($value, ClientDocument $entity) => $this->formatOrderSummary($entity))
                ->renderAsHtml()
                ->hideOnForm(),
            DateTimeField::new('uploadedAt')->setLabel('Date d’envoi')->hideOnForm(),
            UrlField::new('fileUrl')
                ->setLabel('Document')
                ->onlyOnIndex()
                ->formatValue(fn (?string $value, ClientDocument $entity) => $entity->getFileName() ?? '—'),
            UrlField::new('fileUrl')
                ->setLabel('Fichier envoyé')
                ->onlyOnDetail(),
            TextField::new('file')->setFormType(VichFileType::class)->setLabel('Fichier envoyé')->hideOnIndex(),
            UrlField::new('documentTraduitUrl')
                ->setLabel('Document traduit')
                ->onlyOnIndex()
                ->formatValue(fn (?string $value, ClientDocument $entity) => $entity->getDocumentTraduit() ?? '—'),
            UrlField::new('documentTraduitUrl')
                ->setLabel('Document traduit')
                ->onlyOnDetail(),
            TextField::new('translatedDocumentFile')
                ->setFormType(VichFileType::class)
                ->setLabel('Document traduit')
                ->setFormTypeOptions([
                    'required' => false,
                    'allow_delete' => true,
                    'download_uri' => static fn (ClientDocument $entity) => $entity->getDocumentTraduitUrl(),
                    'download_label' => static fn (ClientDocument $entity) => $entity->getDocumentTraduit() ?? 'Télécharger',
                ])
                ->hideOnIndex(),
        ];
    }

    private function formatOrderSummary(ClientDocument $entity): string
    {
        $order = $entity->getOrder();
        if (null === $order) {
            return '—';
        }

        $statusBadge = $this->renderPaymentStatus($order->getStatus() === 'paid' ? 'paid' : 'pending');

        return sprintf(
            '%s — %s — %s € (%s)',
            $order->getInvoiceNumber() ?? 'Sans n°',
            $statusBadge,
            $order->getTotal(),
            $order->getCreatedAt()?->format('d/m/Y H:i') ?? '—',
        );
    }

    #[AdminRoute(options: ['methods' => ['POST']])]
    public function updatePaymentStatus(AdminContext $context): Response
    {
        $entity = $context->getEntity()->getInstance();
        if (!$entity instanceof ClientDocument) {
            throw $this->createNotFoundException();
        }

        $status = (string) $context->getRequest()->request->get('status', '');
        if (!\in_array($status, ['none', 'pending', 'paid'], true)) {
            return new JsonResponse(['success' => false, 'message' => 'Statut invalide.'], Response::HTTP_BAD_REQUEST);
        }

        try {
            $this->applyPaymentStatus($entity, $status);
            $this->entityManager->flush();
        } catch (\RuntimeException $e) {
            return new JsonResponse(['success' => false, 'message' => $e->getMessage()], Response::HTTP_UNPROCESSABLE_ENTITY);
        }

        return new JsonResponse([
            'success' => true,
            'status' => $entity->getPaymentStatus(),
            'label' => $entity->getPaymentStatusLabel(),
        ]);
    }

    #[AdminRoute(options: ['methods' => ['POST']])]
    public function updateWorkflowStatus(AdminContext $context): Response
    {
        $entity = $context->getEntity()->getInstance();
        if (!$entity instanceof ClientDocument) {
            throw $this->createNotFoundException();
        }

        $status = (string) $context->getRequest()->request->get('status', '');
        if (!\in_array($status, ClientDocument::STATUSES, true)) {
            return new JsonResponse(['success' => false, 'message' => 'Statut invalide.'], Response::HTTP_BAD_REQUEST);
        }

        try {
            $this->applyWorkflowStatus($entity, $status);
            $this->entityManager->flush();
        } catch (\RuntimeException $e) {
            return new JsonResponse(['success' => false, 'message' => $e->getMessage()], Response::HTTP_UNPROCESSABLE_ENTITY);
        }

        return new JsonResponse([
            'success' => true,
            'status' => $entity->getWorkflowStatus(),
            'label' => $entity->getWorkflowStatusLabel(),
            'pillClass' => $entity->getWorkflowStatusPillClass(),
        ]);
    }

    private function applyWorkflowStatus(ClientDocument $document, string $status): void
    {
        if (ClientDocument::STATUS_UNPAID === $status) {
            if ('paid' === $document->getPaymentStatus()) {
                throw new \RuntimeException('Impossible de repasser en non-payé : la commande est déjà payée.');
            }

            $document->setStatus(ClientDocument::STATUS_UNPAID);

            return;
        }

        if (\in_array($status, [ClientDocument::STATUS_PAID, ClientDocument::STATUS_IN_TRANSLATION, ClientDocument::STATUS_TRANSLATION_COMPLETED, ClientDocument::STATUS_DELIVERED], true)) {
            if ('paid' !== $document->getPaymentStatus()) {
                $this->applyPaymentStatus($document, 'paid');
            }
        }

        $document->setStatus($status);
    }

    private function applyPaymentStatus(ClientDocument $document, string $status): void
    {
        if ('none' === $status) {
            $document->setOrder(null);
            if (!\in_array($document->getStatus(), [ClientDocument::STATUS_IN_TRANSLATION, ClientDocument::STATUS_TRANSLATION_COMPLETED, ClientDocument::STATUS_DELIVERED], true)) {
                $document->setStatus(ClientDocument::STATUS_UNPAID);
            }

            return;
        }

        $order = $document->getOrder();
        if (null === $order) {
            $user = $document->getUser();
            if (null === $user) {
                throw new \RuntimeException('Impossible de modifier le statut : aucun client associé à ce document.');
            }

            $priceCents = $document->getPrice() ?? 0;
            if ($document->isReceiveByPaper()) {
                $priceCents += ClientDocument::PAPER_DELIVERY_SURCHARGE_CENTS;
            }

            $order = new Order();
            $order->setUser($user);
            $order->setTotal(number_format($priceCents / 100, 2, '.', ''));
            $order->setCurrency('EUR');
            $order->setInvoiceNumber('FACT-' . date('Ymd') . '-' . random_int(1000, 9999));
            $document->setOrder($order);
            $this->entityManager->persist($order);
        }

        $order->setStatus('paid' === $status ? 'paid' : 'pending');

        if ('paid' === $status && ClientDocument::STATUS_UNPAID === $document->getStatus()) {
            $document->setStatus(ClientDocument::STATUS_PAID);
        } elseif ('pending' === $status && !\in_array($document->getStatus(), [ClientDocument::STATUS_IN_TRANSLATION, ClientDocument::STATUS_TRANSLATION_COMPLETED, ClientDocument::STATUS_DELIVERED], true)) {
            $document->setStatus(ClientDocument::STATUS_UNPAID);
        }
    }

    private function renderPaymentStatus(string $status): string
    {
        [$modifier, $label] = match ($status) {
            'paid' => ['paid', 'Payé'],
            'pending' => ['pending', 'Paiement en attente'],
            default => ['none', 'Non rattaché'],
        };

        return sprintf(
            '<span class="ea-payment-status ea-payment-status--%s"><span class="ea-payment-status__dot" aria-hidden="true"></span><span class="ea-payment-status__label">%s</span></span>',
            $modifier,
            htmlspecialchars($label, ENT_QUOTES),
        );
    }

    private function renderPaymentStatusSelect(ClientDocument $entity): string
    {
        $currentStatus = $entity->getPaymentStatus();
        $url = $this->adminUrlGenerator
            ->setController(self::class)
            ->setAction('updatePaymentStatus')
            ->setEntityId($entity->getId())
            ->generateUrl();

        $canChangeStatus = null !== $entity->getOrder() || null !== $entity->getUser();
        $options = [
            'paid' => 'Payé',
            'pending' => 'Paiement en attente',
            'none' => 'Non rattaché',
        ];

        $html = sprintf(
            '<select class="ea-payment-status-select ea-payment-status-select--%s" data-url="%s" data-previous-value="%s" aria-label="Statut paiement"%s>',
            htmlspecialchars($currentStatus, ENT_QUOTES),
            htmlspecialchars($url, ENT_QUOTES),
            htmlspecialchars($currentStatus, ENT_QUOTES),
            $canChangeStatus ? '' : ' disabled title="Client requis pour modifier le statut"',
        );

        foreach ($options as $value => $label) {
            $selected = $value === $currentStatus ? ' selected' : '';
            $disabled = (!$canChangeStatus && 'none' !== $value) ? ' disabled' : '';
            $html .= sprintf(
                '<option value="%s"%s%s>%s</option>',
                htmlspecialchars($value, ENT_QUOTES),
                $selected,
                $disabled,
                htmlspecialchars($label, ENT_QUOTES),
            );
        }

        $html .= '</select>';

        return $html;
    }
}
