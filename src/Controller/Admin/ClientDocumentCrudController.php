<?php

namespace App\Controller\Admin;

use App\Entity\ClientDocument;
use App\Entity\ClientDocumentPaymentLink;
use App\Entity\Document;
use App\Entity\Order;
use App\Entity\User;
use App\Repository\ClientDocumentPaymentLinkRepository;
use App\Repository\ClientDocumentRepository;
use App\Repository\DocumentRepository;
use App\Repository\TranslationRateRepository;
use App\Repository\UserRepository;
use App\Service\MailjetService;
use App\Service\StripePaymentLinkService;
use Doctrine\ORM\EntityManagerInterface;
use Doctrine\ORM\QueryBuilder;
use EasyCorp\Bundle\EasyAdminBundle\Attribute\AdminRoute;
use EasyCorp\Bundle\EasyAdminBundle\Collection\FieldCollection;
use EasyCorp\Bundle\EasyAdminBundle\Collection\FilterCollection;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Config\KeyValueStore;
use EasyCorp\Bundle\EasyAdminBundle\Context\AdminContext;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Dto\EntityDto;
use EasyCorp\Bundle\EasyAdminBundle\Dto\SearchDto;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ChoiceField;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateTimeField;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IdField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IntegerField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Field\UrlField;
use EasyCorp\Bundle\EasyAdminBundle\Router\AdminUrlGenerator;
use Symfony\Component\HttpFoundation\File\UploadedFile;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Vich\UploaderBundle\Form\Type\VichFileType;

class ClientDocumentCrudController extends AbstractCrudController
{
    public function __construct(
        private readonly EntityManagerInterface $entityManager,
        private readonly AdminUrlGenerator $adminUrlGenerator,
        private readonly ClientDocumentRepository $clientDocumentRepository,
        private readonly ClientDocumentPaymentLinkRepository $clientDocumentPaymentLinkRepository,
        private readonly DocumentRepository $documentRepository,
        private readonly TranslationRateRepository $translationRateRepository,
        private readonly UserRepository $userRepository,
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
            ->setPageTitle(Crud::PAGE_INDEX, 'Documents clients')
            ->setPageTitle(Crud::PAGE_DETAIL, static fn (ClientDocument $doc) => sprintf('DC-%04d — %s', $doc->getId(), $doc->getTitle()))
            ->setPageTitle(Crud::PAGE_EDIT, static fn (ClientDocument $doc) => sprintf('Modifier DC-%04d — %s', $doc->getId(), $doc->getTitle()))
            ->setPageTitle(Crud::PAGE_NEW, 'Nouveau document client')
            ->setDefaultSort(['uploadedAt' => 'DESC'])
            ->setSearchFields(null)
            ->setDefaultRowAction(Action::DETAIL)
            ->overrideTemplate('crud/index', 'admin/client_document/index.html.twig')
            ->overrideTemplate('crud/detail', 'admin/client_document/detail.html.twig')
            ->overrideTemplate('crud/edit', 'admin/client_document/edit.html.twig')
            ->overrideTemplate('crud/new', 'admin/client_document/new.html.twig');
    }

    public function configureActions(Actions $actions): Actions
    {
        $updatePaymentStatus = Action::new('updatePaymentStatus', false)
            ->linkToCrudAction('updatePaymentStatus')
            ->displayIf(static fn () => false);

        $updateWorkflowStatus = Action::new('updateWorkflowStatus', false)
            ->linkToCrudAction('updateWorkflowStatus')
            ->displayIf(static fn () => false);

        $createPaymentLink = Action::new('createPaymentLink', false)
            ->linkToCrudAction('createPaymentLink')
            ->displayIf(static fn () => false);

        $deletePaymentLink = Action::new('deletePaymentLink', false)
            ->linkToCrudAction('deletePaymentLink')
            ->displayIf(static fn () => false);

        $sendToClient = Action::new('sendToClient', false)
            ->linkToCrudAction('sendToClient')
            ->displayIf(static fn () => false);

        $uploadTranslatedDocument = Action::new('uploadTranslatedDocument', false)
            ->linkToCrudAction('uploadTranslatedDocument')
            ->displayIf(static fn () => false);

        $createFromAdmin = Action::new('createFromAdmin', false)
            ->linkToCrudAction('createFromAdmin')
            ->displayIf(static fn () => false);

        return $actions
            ->disable(Action::BATCH_DELETE)
            ->add(Crud::PAGE_INDEX, Action::DETAIL)
            ->add(Crud::PAGE_INDEX, $createFromAdmin)
            ->add(Crud::PAGE_INDEX, $updatePaymentStatus)
            ->add(Crud::PAGE_INDEX, $updateWorkflowStatus)
            ->add(Crud::PAGE_DETAIL, $createPaymentLink)
            ->add(Crud::PAGE_DETAIL, $deletePaymentLink)
            ->add(Crud::PAGE_DETAIL, $sendToClient)
            ->add(Crud::PAGE_DETAIL, $uploadTranslatedDocument)
            ->update(Crud::PAGE_INDEX, Action::NEW, fn (Action $action) => $action->displayIf(static fn () => false))
            ->update(Crud::PAGE_INDEX, Action::EDIT, fn (Action $action) => $action->displayIf(static fn () => false))
            ->update(Crud::PAGE_INDEX, Action::DELETE, fn (Action $action) => $action->displayIf(static fn () => false))
            ->update(Crud::PAGE_DETAIL, Action::EDIT, fn (Action $action) => $action
                ->setLabel('Modifier')
                ->setCssClass('btn btn-outline btn-sm'))
            ->update(Crud::PAGE_DETAIL, Action::INDEX, fn (Action $action) => $action->displayIf(static fn () => false))
            ->update(Crud::PAGE_DETAIL, Action::DELETE, fn (Action $action) => $action
                ->setLabel('Supprimer')
                ->setCssClass('btn btn-outline btn-sm doc-action-delete')
                ->askConfirmation(
                    'Êtes-vous sûr de vouloir supprimer le document client %entity_id% ? Cette action est irréversible.',
                    'Valider la suppression',
                ))
            ->add(Crud::PAGE_EDIT, Action::DELETE)
            ->update(Crud::PAGE_EDIT, Action::DELETE, fn (Action $action) => $action
                ->setLabel('Supprimer')
                ->setCssClass('btn btn-outline btn-sm doc-action-delete')
                ->askConfirmation(
                    'Êtes-vous sûr de vouloir supprimer le document client %entity_id% ? Cette action est irréversible.',
                    'Valider la suppression',
                ));
    }

    public function createIndexQueryBuilder(SearchDto $searchDto, EntityDto $entityDto, FieldCollection $fields, FilterCollection $filters): QueryBuilder
    {
        return parent::createIndexQueryBuilder($searchDto, $entityDto, $fields, $filters)
            ->leftJoin('entity.order', 'paymentOrder')
            ->addSelect('paymentOrder')
            ->leftJoin('entity.user', 'clientUser')
            ->addSelect('clientUser');
    }

    public function configureFields(string $pageName): iterable
    {
        if (Crud::PAGE_INDEX === $pageName) {
            yield from $this->getIndexFields();

            return;
        }

        if (Crud::PAGE_DETAIL === $pageName) {
            yield from $this->getDetailFields();

            return;
        }

        yield from $this->getFormFields();
    }

    public function configureResponseParameters(KeyValueStore $responseParameters): KeyValueStore
    {
        if (Crud::PAGE_INDEX === $responseParameters->get('pageName')) {
            $responseParameters->set('indexStats', $this->clientDocumentRepository->getIndexStats());
            $responseParameters->set('documentsFormData', $this->buildDocumentsFormData());
            $responseParameters->set('existingUsers', $this->userRepository->findBy([], ['email' => 'ASC']));
            $responseParameters->set('createClientDocumentUrl', $this->adminUrlGenerator
                ->setController(self::class)
                ->setAction('createFromAdmin')
                ->generateUrl());
        }

        return $responseParameters;
    }

    private function getIndexFields(): iterable
    {
        yield AssociationField::new('user')
            ->setLabel('Client')
            ->formatValue(fn ($value, ClientDocument $entity) => $entity->getUser()?->getEmail() ?? '—');
        yield TextField::new('title')->setLabel('Titre');
        yield TextField::new('language')->setLabel('Langue');
        yield TextField::new('workflowStatusLabel')
            ->setLabel('Statut')
            ->formatValue(fn (?string $value, ClientDocument $entity) => $this->renderView(
                'admin/client_document/_workflow_status_select.html.twig',
                ['doc' => $entity],
            ))
            ->renderAsHtml();
        yield IntegerField::new('pageCount')->setLabel('Pages Initiales');
        yield IntegerField::new('pageAfterTranslation')->setLabel('Pages Finales');
        yield TextField::new('receiveByPaperLabel')
            ->setLabel('Réception')
            ->formatValue(fn (?string $value, ClientDocument $entity) => $this->renderView(
                'admin/client_document/_receive_by_paper_badge.html.twig',
                ['doc' => $entity],
            ))
            ->renderAsHtml();
        yield DateTimeField::new('uploadedAt')
            ->setLabel('Reçu le')
            ->setFormat('dd/MM/yyyy');
    }

    private function getDetailFields(): iterable
    {
        yield IdField::new('id');
        yield AssociationField::new('user')
            ->setLabel('Client')
            ->formatValue(fn ($value, ClientDocument $entity) => $entity->getUser()?->getEmail() ?? '—');
        yield ChoiceField::new('status')
            ->setLabel('Statut du document')
            ->setChoices(ClientDocument::getStatusChoices());
        yield AssociationField::new('document')->setLabel('Document à traduire');
        yield TextField::new('title')->setLabel('Nom du fichier envoyé');
        yield TextField::new('language')->setLabel('Langue demandée');
        yield IntegerField::new('price')->setLabel('Prix estimé (centimes)');
        yield BooleanField::new('receiveByPaper')->setLabel('Réception par papier');
        yield AssociationField::new('order')
            ->setLabel('Commande liée')
            ->formatValue(fn ($value, ClientDocument $entity) => $this->formatOrderSummary($entity))
            ->renderAsHtml();
        yield DateTimeField::new('uploadedAt')->setLabel('Date d’envoi');
        yield UrlField::new('fileUrl')->setLabel('Fichier envoyé');
        yield UrlField::new('documentTraduitUrl')->setLabel('Document traduit');
    }

    private function getFormFields(): iterable
    {
        yield FormField::addFieldset('Informations du dossier');
        yield AssociationField::new('user')->setLabel('Client');
        yield AssociationField::new('document')->setLabel('Document à traduire');
        yield TextField::new('title')->setLabel('Nom du fichier envoyé');
        yield TextField::new('language')->setLabel('Langue demandée');
        yield ChoiceField::new('status')
            ->setLabel('Statut du document')
            ->setChoices(ClientDocument::getStatusChoices());

        yield FormField::addFieldset('Tarification & livraison');
        yield IntegerField::new('price')
            ->setLabel('Prix estimé (centimes)')
            ->setHelp('Montant en centimes — ex. 4500 = 45,00 €');
        yield BooleanField::new('receiveByPaper')->setLabel('Réception par courrier');

        yield FormField::addFieldset('Fichiers');
        yield TextField::new('file')
            ->setFormType(VichFileType::class)
            ->setLabel('Fichier source')
            ->setHelp('Document original envoyé par le client')
            ->setFormTypeOptions([
                'required' => false,
                'allow_delete' => true,
                'download_uri' => static fn (ClientDocument $entity) => $entity->getFileUrl(),
                'download_label' => static fn (ClientDocument $entity) => $entity->getFileName() ?? 'Télécharger',
            ]);
        yield TextField::new('translatedDocumentFile')
            ->setFormType(VichFileType::class)
            ->setLabel('Document traduit')
            ->setHelp('Déposer ici la traduction finalisée')
            ->setFormTypeOptions([
                'required' => false,
                'allow_delete' => true,
                'download_uri' => static fn (ClientDocument $entity) => $entity->getDocumentTraduitUrl(),
                'download_label' => static fn (ClientDocument $entity) => $entity->getDocumentTraduit() ?? 'Télécharger',
            ]);
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
    public function createFromAdmin(
        AdminContext $context,
        UserPasswordHasherInterface $passwordHasher,
        MailjetService $mailjetService,
    ): Response {
        $request = $context->getRequest();

        try {
            $creation = $this->buildClientDocumentFromAdminRequest($request, $passwordHasher);
        } catch (\InvalidArgumentException $e) {
            return new JsonResponse(['success' => false, 'message' => $e->getMessage()], Response::HTTP_BAD_REQUEST);
        }

        $clientDocument = $creation['clientDocument'];
        $this->entityManager->persist($clientDocument);

        try {
            $this->entityManager->flush();
        } catch (\Throwable $e) {
            return new JsonResponse([
                'success' => false,
                'message' => 'Impossible d\'enregistrer le dossier client.',
            ], Response::HTTP_UNPROCESSABLE_ENTITY);
        }

        if (
            $creation['isNewUser']
            && $creation['sendCredentials']
            && null !== $creation['plainPassword']
        ) {
            $user = $clientDocument->getUser();
            if (!$user instanceof User || null === $user->getId() || null === $clientDocument->getId()) {
                return new JsonResponse([
                    'success' => false,
                    'message' => 'Le dossier a été créé mais le client n\'a pas pu être confirmé pour l\'envoi des identifiants.',
                ], Response::HTTP_UNPROCESSABLE_ENTITY);
            }

            try {
                $mailjetService->sendAccountCredentialsEmail($user, $creation['plainPassword']);
            } catch (\Throwable $e) {
                return new JsonResponse([
                    'success' => false,
                    'message' => 'Le dossier a été créé mais l\'envoi des identifiants par e-mail a échoué.',
                ], Response::HTTP_BAD_GATEWAY);
            }
        }

        $detailUrl = $this->adminUrlGenerator
            ->setController(self::class)
            ->setAction(Action::DETAIL)
            ->setEntityId($clientDocument->getId())
            ->generateUrl();

        return new JsonResponse([
            'success' => true,
            'message' => sprintf('Le dossier DC-%04d a été créé.', $clientDocument->getId()),
            'redirectUrl' => $detailUrl,
            'entityId' => $clientDocument->getId(),
        ]);
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

    #[AdminRoute(options: ['methods' => ['POST']])]
    public function createPaymentLink(
        AdminContext $context,
        StripePaymentLinkService $stripePaymentLinkService,
        MailjetService $mailjetService,
    ): Response {
        $entity = $context->getEntity()->getInstance();
        if (!$entity instanceof ClientDocument) {
            throw $this->createNotFoundException();
        }

        if (ClientDocument::STATUS_UNPAID !== $entity->getWorkflowStatus()) {
            return new JsonResponse([
                'success' => false,
                'message' => 'Un lien de paiement ne peut être créé que pour un dossier non payé.',
            ], Response::HTTP_UNPROCESSABLE_ENTITY);
        }

        if (!$entity->getPaymentLinks()->isEmpty()) {
            return new JsonResponse([
                'success' => false,
                'message' => 'Un lien de paiement existe déjà pour ce dossier.',
            ], Response::HTTP_UNPROCESSABLE_ENTITY);
        }

        $clientEmail = $entity->getUser()?->getEmail();
        if (null === $clientEmail || '' === $clientEmail) {
            return new JsonResponse([
                'success' => false,
                'message' => 'Aucune adresse e-mail client n\'est associée à ce dossier.',
            ], Response::HTTP_BAD_REQUEST);
        }

        try {
            $paymentLink = $stripePaymentLinkService->createForClientDocument($entity);
            $this->entityManager->persist($paymentLink);
            $this->entityManager->flush();
            $mailjetService->sendPaymentLinkEmail($entity, $paymentLink);
        } catch (\Throwable $e) {
            return new JsonResponse([
                'success' => false,
                'message' => $e->getMessage() ?: 'Impossible de créer ou d\'envoyer le lien de paiement.',
            ], Response::HTTP_BAD_GATEWAY);
        }

        return new JsonResponse([
            'success' => true,
            'message' => sprintf('Le lien de paiement a été créé et envoyé à %s.', $clientEmail),
            'paymentLink' => [
                'id' => $paymentLink->getId(),
                'url' => $paymentLink->getUrl(),
                'amountCents' => $paymentLink->getAmountCents(),
                'amountLabel' => number_format($paymentLink->getAmountCents() / 100, 2, ',', ' ') . ' €',
                'currency' => $paymentLink->getCurrency(),
                'createdAt' => $paymentLink->getCreatedAt()?->format('d/m/Y à H:i'),
            ],
        ]);
    }

    #[AdminRoute(options: ['methods' => ['POST']])]
    public function deletePaymentLink(AdminContext $context, StripePaymentLinkService $stripePaymentLinkService): Response
    {
        $entity = $context->getEntity()->getInstance();
        if (!$entity instanceof ClientDocument) {
            throw $this->createNotFoundException();
        }

        $paymentLinkId = (int) $context->getRequest()->request->get('paymentLinkId', 0);
        if ($paymentLinkId <= 0) {
            return new JsonResponse(['success' => false, 'message' => 'Lien de paiement invalide.'], Response::HTTP_BAD_REQUEST);
        }

        $paymentLink = $this->clientDocumentPaymentLinkRepository->find($paymentLinkId);
        if (
            !$paymentLink instanceof ClientDocumentPaymentLink
            || $paymentLink->getClientDocument()?->getId() !== $entity->getId()
        ) {
            return new JsonResponse(['success' => false, 'message' => 'Lien de paiement introuvable.'], Response::HTTP_NOT_FOUND);
        }

        try {
            $stripePaymentLinkService->deactivate($paymentLink);
            $this->entityManager->remove($paymentLink);
            $this->entityManager->flush();
        } catch (\Throwable $e) {
            return new JsonResponse([
                'success' => false,
                'message' => $e->getMessage() ?: 'Impossible de supprimer le lien de paiement.',
            ], Response::HTTP_BAD_GATEWAY);
        }

        return new JsonResponse([
            'success' => true,
            'message' => 'Le lien de paiement a été supprimé.',
        ]);
    }

    #[AdminRoute(options: ['methods' => ['POST']])]
    public function uploadTranslatedDocument(AdminContext $context): Response
    {
        $entity = $context->getEntity()->getInstance();
        if (!$entity instanceof ClientDocument) {
            throw $this->createNotFoundException();
        }

        $uploadedFile = $context->getRequest()->files->get('file');
        if (!$uploadedFile instanceof UploadedFile || !$uploadedFile->isValid()) {
            return new JsonResponse([
                'success' => false,
                'message' => 'Veuillez sélectionner un fichier valide.',
            ], Response::HTTP_BAD_REQUEST);
        }

        $pageAfterTranslation = max(1, min(99, (int) $context->getRequest()->request->get('pageAfterTranslation', 1)));

        try {
            $entity->setPageAfterTranslation($pageAfterTranslation);
            $entity->setTranslatedDocumentFile($uploadedFile);
            $this->entityManager->flush();
        } catch (\Throwable $e) {
            return new JsonResponse([
                'success' => false,
                'message' => $e->getMessage() ?: 'Impossible d\'enregistrer le document traduit.',
            ], Response::HTTP_UNPROCESSABLE_ENTITY);
        }

        return new JsonResponse([
            'success' => true,
            'message' => 'Le document traduit a été enregistré.',
            'fileName' => $entity->getDocumentTraduit(),
            'fileUrl' => $entity->getDocumentTraduitUrl(),
            'workflowStatus' => $entity->getWorkflowStatus(),
            'workflowStatusLabel' => $entity->getWorkflowStatusLabel(),
            'workflowStatusPillClass' => $entity->getWorkflowStatusPillClass(),
            'pageAfterTranslation' => $entity->getPageAfterTranslation(),
            'html' => $this->renderView('admin/client_document/_translated_file_current.html.twig', [
                'doc' => $entity,
                'user' => $entity->getUser(),
            ]),
        ]);
    }

    #[AdminRoute(options: ['methods' => ['POST']])]
    public function sendToClient(AdminContext $context, MailjetService $mailjetService): Response
    {
        $entity = $context->getEntity()->getInstance();
        if (!$entity instanceof ClientDocument) {
            throw $this->createNotFoundException();
        }

        if (null === $entity->getDocumentTraduit() || '' === $entity->getDocumentTraduit()) {
            return new JsonResponse(['success' => false, 'message' => 'Aucun document traduit n\'est disponible.'], Response::HTTP_BAD_REQUEST);
        }

        $user = $entity->getUser();
        if (!$user?->getEmail()) {
            return new JsonResponse(['success' => false, 'message' => 'Aucune adresse e-mail client n\'est associée à ce dossier.'], Response::HTTP_BAD_REQUEST);
        }

        try {
            $mailjetService->sendTranslatedDocumentEmail(
                $entity,
                $context->getRequest()->getSchemeAndHttpHost(),
            );

            if (ClientDocument::STATUS_TRANSLATION_COMPLETED === $entity->getStatus()) {
                $entity->setStatus(ClientDocument::STATUS_DELIVERED);
                $this->entityManager->flush();
            }
        } catch (\Throwable $e) {
            return new JsonResponse([
                'success' => false,
                'message' => $e->getMessage() ?: 'Impossible d\'envoyer l\'e-mail au client.',
            ], Response::HTTP_BAD_GATEWAY);
        }

        return new JsonResponse([
            'success' => true,
            'message' => sprintf('Le document a été envoyé à %s.', $user->getEmail()),
            'status' => $entity->getWorkflowStatus(),
            'label' => $entity->getWorkflowStatusLabel(),
            'pillClass' => $entity->getWorkflowStatusPillClass(),
        ]);
    }

    /**
     * @return list<array{
     *     id: int,
     *     name: string,
     *     hasLanguagePairs: bool,
     *     basePriceCents: int,
     *     languagePairs: list<array{value: string, priceCents: int}>
     * }>
     */
    private function buildDocumentsFormData(): array
    {
        $data = [];

        foreach ($this->documentRepository->findBy(['active' => true], ['name' => 'ASC']) as $document) {
            $id = $document->getId();
            if (null === $id) {
                continue;
            }

            $languagePairs = [];
            foreach ($this->translationRateRepository->findActiveByDocument($document) as $rate) {
                $languagePairs[] = [
                    'value' => $rate->getLanguagePair(),
                    'priceCents' => $rate->getPrice(),
                ];
            }

            $data[] = [
                'id' => $id,
                'name' => (string) $document->getName(),
                'hasLanguagePairs' => [] !== $languagePairs,
                'basePriceCents' => ((int) ($document->getBasePrice() ?? 0)) * 100,
                'languagePairs' => $languagePairs,
            ];
        }

        return $data;
    }

    /**
     * @return array{
     *     clientDocument: ClientDocument,
     *     isNewUser: bool,
     *     sendCredentials: bool,
     *     plainPassword: ?string
     * }
     */
    private function buildClientDocumentFromAdminRequest(
        Request $request,
        UserPasswordHasherInterface $passwordHasher,
    ): array {
        $userMode = (string) $request->request->get('userMode', 'new');
        if (!\in_array($userMode, ['new', 'existing'], true)) {
            throw new \InvalidArgumentException('Mode client invalide.');
        }

        $isNewUser = 'new' === $userMode;
        $sendCredentials = false;
        $plainPassword = null;

        $documentId = (int) $request->request->get('documentId', 0);
        $document = $this->documentRepository->find($documentId);
        if (!$document instanceof Document) {
            throw new \InvalidArgumentException('Veuillez sélectionner un type de document valide.');
        }

        $languagePairs = $this->translationRateRepository->findActiveByDocument($document);
        $hasLanguagePairs = [] !== $languagePairs;
        $language = trim((string) $request->request->get('language', ''));

        if ($hasLanguagePairs && '' === $language) {
            throw new \InvalidArgumentException('Veuillez sélectionner une paire de langues.');
        }

        if ($hasLanguagePairs && null === $this->translationRateRepository->findActiveForDocumentAndPair($document, $language)) {
            throw new \InvalidArgumentException('La paire de langues sélectionnée est invalide.');
        }

        if ('existing' === $userMode) {
            $existingUserId = (int) $request->request->get('existingUserId', 0);
            $user = $this->userRepository->find($existingUserId);
            if (!$user instanceof User) {
                throw new \InvalidArgumentException('Veuillez sélectionner un client existant.');
            }
        } else {
            $email = mb_strtolower(trim((string) $request->request->get('email', '')));
            if (!filter_var($email, \FILTER_VALIDATE_EMAIL)) {
                throw new \InvalidArgumentException('Veuillez fournir une adresse e-mail valide.');
            }

            $existingUser = $this->userRepository->findOneBy(['email' => $email]);
            if ($existingUser instanceof User) {
                throw new \InvalidArgumentException('Cet e-mail est déjà utilisé. Sélectionnez le client existant.');
            }

            $plainPassword = (string) $request->request->get('password', '');
            if ('' === $plainPassword) {
                $plainPassword = bin2hex(random_bytes(8));
            } elseif (strlen($plainPassword) < 8) {
                throw new \InvalidArgumentException('Le mot de passe doit contenir au moins 8 caractères.');
            }

            $user = new User();
            $user->setEmail($email);
            $user->setPassword($passwordHasher->hashPassword($user, $plainPassword));
            $user->setFirstName(trim((string) $request->request->get('firstName', '')) ?: null);
            $user->setLastName(trim((string) $request->request->get('lastName', '')) ?: null);
            $user->setCompany(trim((string) $request->request->get('company', '')) ?: null);
            $user->setPhone(trim((string) $request->request->get('phone', '')) ?: null);
            $this->entityManager->persist($user);

            $sendCredentials = $request->request->getBoolean('sendCredentials');
        }

        $pageCount = max(1, min(99, (int) $request->request->get('pageCount', 1)));
        $receiveByPaper = $request->request->getBoolean('receiveByPaper');
        $priceCents = (int) $request->request->get('price', 0);
        if ($priceCents <= 0) {
            throw new \InvalidArgumentException('Veuillez indiquer un prix estimé valide.');
        }

        $title = trim((string) $request->request->get('title', ''));
        $uploadedFile = $request->files->get('file');
        if ($uploadedFile instanceof UploadedFile && $uploadedFile->isValid()) {
            if ('' === $title) {
                $title = $uploadedFile->getClientOriginalName();
            }
        }

        if ('' === $title) {
            throw new \InvalidArgumentException('Veuillez indiquer un titre ou joindre un fichier source.');
        }

        $clientDocument = new ClientDocument();
        $clientDocument->setUser($user);
        $clientDocument->setDocument($document);
        $clientDocument->setTitle($title);
        $clientDocument->setLanguage($hasLanguagePairs ? $language : null);
        $clientDocument->setPageCount($pageCount);
        $clientDocument->setPrice($priceCents);
        $clientDocument->setReceiveByPaper($receiveByPaper);
        $clientDocument->setStatus(ClientDocument::STATUS_UNPAID);

        if ($uploadedFile instanceof UploadedFile && $uploadedFile->isValid()) {
            $clientDocument->setFile($uploadedFile);
        }

        return [
            'clientDocument' => $clientDocument,
            'isNewUser' => $isNewUser,
            'sendCredentials' => $sendCredentials,
            'plainPassword' => $plainPassword,
        ];
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
