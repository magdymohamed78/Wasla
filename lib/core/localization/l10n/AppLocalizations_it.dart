// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'AppLocalizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get onboardingLogIn => 'Accedi';

  @override
  String get onboardingNewUser => 'Nuovo utente';

  @override
  String get languageEnglish => 'Inglese';

  @override
  String get languageArabic => 'Arabo';

  @override
  String get supportPageTitle => 'Supporto';

  @override
  String get supportPageDescription =>
      'Per supporto, contattaci a waslacrmteam@wasla.com';

  @override
  String get loginTitle => 'Accedi';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginRememberMe => 'Ricordami';

  @override
  String get loginForgotPassword => 'Password dimenticata?';

  @override
  String get loginSignIn => 'Accedi';

  @override
  String get loginSignUp => 'Non hai un account? Registrati';

  @override
  String get loginSignUpAction => 'Registrati';

  @override
  String get loginInvalidCredentials => 'Email o password non validi';

  @override
  String get loginEmailRequired => 'L\'email è obbligatoria';

  @override
  String get loginPasswordRequired => 'La password è obbligatoria';

  @override
  String get loginEmailInvalid => 'Inserisci un indirizzo email valido';

  @override
  String get loginUnexpectedError =>
      'Si è verificato un errore imprevisto. Riprova.';

  @override
  String get loginNoConnection =>
      'Nessuna connessione Internet. Controlla la rete.';

  @override
  String get loginRateLimited => 'Troppi tentativi. Riprova più tardi.';

  @override
  String get loginSessionExpired => 'Sessione scaduta. Accedi di nuovo.';

  @override
  String get loginErrorInvalidCredentials =>
      'Credenziali non valide o account inattivo.';

  @override
  String get loginErrorAccountNotSetup =>
      'Il tuo account non è completamente configurato. Contatta il supporto.';

  @override
  String get loginErrorRateLimit =>
      'Troppi tentativi di accesso. Riprova più tardi.';

  @override
  String get loginErrorNetwork =>
      'Nessuna connessione Internet. Controlla la rete e riprova.';

  @override
  String get loginErrorServer =>
      'Si è verificato un errore imprevisto. Riprova più tardi.';

  @override
  String get forgotPasswordTitle => 'Password dimenticata?';

  @override
  String get forgotPasswordDescription =>
      'Non preoccuparti! Può succedere. Inserisci l\'indirizzo email collegato al tuo account.';

  @override
  String get forgotPasswordEmailLabel => 'Inserisci il tuo indirizzo email';

  @override
  String get forgotPasswordEmailPlaceholder => 'latuamail@gmail.com';

  @override
  String get forgotPasswordSend => 'Invia';

  @override
  String get forgotPasswordSuccess =>
      'Link di reimpostazione inviato con successo';

  @override
  String get forgotPasswordEmailRequired => 'L\'email è obbligatoria';

  @override
  String get forgotPasswordEmailInvalid =>
      'Inserisci un indirizzo email valido';

  @override
  String get signUpTitle => 'Registrati';

  @override
  String get signUpFirstName => 'Nome';

  @override
  String get signUpLastName => 'Cognome';

  @override
  String get signUpPhoneNumber => 'Numero di telefono';

  @override
  String get signUpEmail => 'Indirizzo email';

  @override
  String get signUpEmailHint => 'latuamail@gmail.com';

  @override
  String get signUpPassword => 'Password';

  @override
  String get signUpConfirmPassword => 'Conferma password';

  @override
  String get signUpButton => 'Registrati';

  @override
  String get signUpHaveAccount => 'Hai già un account? Accedi';

  @override
  String get signUpHaveAccountAction => 'Accedi';

  @override
  String get signUpFirstNameRequired => 'Il nome è obbligatorio';

  @override
  String get signUpLastNameRequired => 'Il cognome è obbligatorio';

  @override
  String get signUpNameTooLong => 'Deve contenere al massimo 100 caratteri';

  @override
  String get signUpNameLettersOnly => 'Il nome deve contenere solo lettere';

  @override
  String get signUpPhoneTooLong => 'Deve contenere al massimo 50 caratteri';

  @override
  String get signUpPhoneInvalid =>
      'Il numero di telefono deve contenere esattamente 11 cifre';

  @override
  String get signUpEmailRequired => 'L\'email è obbligatoria';

  @override
  String get signUpEmailInvalid => 'Inserisci un indirizzo email valido';

  @override
  String get signUpPasswordRequired => 'Inserisci una password';

  @override
  String get signUpPasswordTooShort => 'Usa almeno 8 caratteri';

  @override
  String get signUpPasswordMissingUppercase => 'Aggiungi una lettera maiuscola';

  @override
  String get signUpPasswordMissingNumber => 'Aggiungi un numero';

  @override
  String get signUpPasswordMissingSpecial => 'Aggiungi un carattere speciale';

  @override
  String get signUpConfirmPasswordRequired => 'Conferma la password';

  @override
  String get signUpConfirmPasswordMismatch => 'Le password non corrispondono';

  @override
  String get signUpErrorEmailInUse => 'Questa email è già registrata';

  @override
  String get signUpErrorServer =>
      'Qualcosa è andato storto. Riprova più tardi.';

  @override
  String get signUpErrorNetwork =>
      'Nessuna connessione Internet. Controlla la rete.';

  @override
  String get signUpErrorUnexpected =>
      'Si è verificato un errore imprevisto. Riprova.';

  @override
  String get signUpSuccessMessage => 'Registrazione completata con successo!';

  @override
  String get signUpSuccessButton => 'Iniziamo';

  @override
  String get networkErrorNoConnection => 'Nessuna connessione Internet';

  @override
  String get networkErrorRetry => 'Riprova';

  @override
  String get networkErrorServer => 'Errore del server. Riprova più tardi.';

  @override
  String get otpVerificationTitle => 'Cambia password';

  @override
  String get otpVerificationDescription =>
      'Inserisci l\'OTP inviato alla tua email per continuare.';

  @override
  String otpVerificationTimerText(int seconds) {
    return 'Reinvia codice tra ${seconds}s';
  }

  @override
  String get otpVerificationResend => 'Reinvia OTP';

  @override
  String get otpVerificationVerify => 'Verifica';

  @override
  String get otpVerificationOtpRequired => 'Inserisci il codice OTP';

  @override
  String get otpVerificationOtpInvalid =>
      'Inserisci un codice valido di 6 cifre';

  @override
  String get changePasswordTitle => 'Cambia password';

  @override
  String get changePasswordDescription =>
      'La nuova password deve essere diversa da quelle usate in precedenza.';

  @override
  String get changePasswordNewPasswordLabel => 'Nuova password';

  @override
  String get changePasswordConfirmPasswordLabel => 'Conferma password';

  @override
  String get changePasswordConfirm => 'Conferma';

  @override
  String get changePasswordMinLength =>
      'La password deve contenere almeno 6 caratteri';

  @override
  String get changePasswordMismatch => 'Le password non corrispondono';

  @override
  String get changePasswordSuccess => 'Password reimpostata con successo';

  @override
  String get errorRateLimit => 'Troppe richieste. Riprova più tardi.';

  @override
  String get errorNetwork =>
      'Nessuna connessione Internet. Controlla la rete e riprova.';

  @override
  String get errorExpiredOtp => 'Il tuo OTP è scaduto. Richiedine uno nuovo.';

  @override
  String get errorPasswordPolicy =>
      'La password non soddisfa i requisiti minimi.';

  @override
  String get errorServer =>
      'Si è verificato un errore imprevisto. Riprova più tardi.';

  @override
  String get signatureModalTitle => 'La tua firma digitale';

  @override
  String get signatureModalGuidance =>
      'Conserva questa firma al sicuro. Ti servirà in seguito per approvare le offerte.';

  @override
  String get signatureModalDownloadError =>
      'Impossibile salvare la firma. Riprova.';

  @override
  String get signatureModalOk => 'OK';

  @override
  String get signatureModalDownloadButton => 'Scarica firma';

  @override
  String get signUpErrorMissingSignature =>
      'Registrazione incompleta. Riprova o contatta il supporto.';

  @override
  String get signatureModalCopySuccess => 'Firma copiata negli appunti.';

  @override
  String get forgotPasswordNotRegistered =>
      'Email non registrata. Registrati prima.';

  @override
  String get forgotPasswordInactiveAccount =>
      'L\'account esiste ma è inattivo — contatta il supporto.';

  @override
  String get forgotPasswordSignUp => 'Non hai un account? Registrati';

  @override
  String get forgotPasswordSignUpAction => 'Registrati';

  @override
  String get forgotPasswordContactSupport => 'Contatta il supporto';

  @override
  String forgotPasswordRateLimitWait(int seconds) {
    return 'Riprova tra ${seconds}s';
  }

  @override
  String get passwordRuleMinLength => '8+ caratteri';

  @override
  String get passwordRuleNumber => '1+ numero';

  @override
  String get passwordRuleUppercase => '1+ lettera maiuscola';

  @override
  String get passwordRuleSpecial => '1+ carattere speciale (!@#\$%^&*)';

  @override
  String get passwordStrengthWeak => 'Debole';

  @override
  String get passwordStrengthMedium => 'Media';

  @override
  String get passwordStrengthStrong => 'Forte';

  @override
  String get passwordStrengthHelperFeedback => 'Scegli una password più forte.';

  @override
  String get homeSearchForServicesOrCompanies => 'Cerca servizi o aziende';

  @override
  String get homeRecommendedCompanies => 'Aziende consigliate';

  @override
  String get homeTrendingCompanies => 'Aziende di tendenza';

  @override
  String get homeAllCompanies => 'Tutte le aziende';

  @override
  String get homeViewAll => 'Vedi tutto';

  @override
  String get navigationHome => 'Home';

  @override
  String get navigationCompanies => 'Aziende';

  @override
  String get navigationSignIn => 'Accedi';

  @override
  String get navigationRequests => 'Richieste';

  @override
  String get navigationOffers => 'Offerte';

  @override
  String get navigationProfile => 'Profilo';

  @override
  String get navigationSettings => 'Impostazioni';

  @override
  String get navigationAllCompanies => 'Tutte le aziende';

  @override
  String get navigationRecommended => 'Consigliate';

  @override
  String get navigationTrending => 'Di tendenza';

  @override
  String get a11yCompaniesDropdownButton => 'Apri opzioni aziende';

  @override
  String get a11ySettingsTabButton => 'Apri impostazioni';

  @override
  String get a11yViewAllButton => 'Vedi tutte le aziende in questa sezione';

  @override
  String get exploreSearchCompanies => 'Cerca aziende...';

  @override
  String get exploreSearchCity => 'Città...';

  @override
  String get exploreAllServices => 'Tutti i servizi';

  @override
  String get exploreMove => 'Trasloco';

  @override
  String get exploreCleaning => 'Pulizia';

  @override
  String get exploreDisposal => 'Smaltimento';

  @override
  String get explorePacking => 'Imballaggio';

  @override
  String get exploreUnpacking => 'Disimballaggio';

  @override
  String get exploreStorage => 'Deposito';

  @override
  String get exploreTransport => 'Trasporto';

  @override
  String get exploreNoCompaniesFound => 'Nessuna azienda trovata';

  @override
  String get exploreTryAdjustingFilters =>
      'Prova a modificare i filtri di ricerca';

  @override
  String get exploreClearFilters => 'Cancella filtri';

  @override
  String get restrictionLoginOrRegister =>
      'Accedi per sbloccare questa destinazione.';

  @override
  String get restrictionContinue => 'Continua';

  @override
  String get restrictionCancel => 'Annulla';

  @override
  String get restrictionBrowseCompanies => 'Torna alle aziende';

  @override
  String get restrictionRequestsTitle => 'Le richieste richiedono l\'accesso';

  @override
  String get restrictionOffersTitle => 'Le offerte richiedono l\'accesso';

  @override
  String get restrictionProfileTitle => 'Il profilo richiede l\'accesso';

  @override
  String get restrictionRequestsMessage =>
      'Accedi per tracciare e gestire le tue richieste.';

  @override
  String get restrictionOffersMessage =>
      'Accedi per visualizzare e confrontare le tue offerte.';

  @override
  String get restrictionProfileMessage =>
      'Accedi per accedere al tuo profilo e alle impostazioni.';

  @override
  String get requestFlowContinuePromptTitle =>
      'Accedi per richiedere questo servizio';

  @override
  String get requestFlowContinuePromptMessage =>
      'Continua con l\'accesso per richiedere un servizio a questa azienda.';

  @override
  String get requestFlowLeadReloginPromptTitle =>
      'Completa la configurazione per continuare';

  @override
  String get requestFlowLeadReloginPromptMessage =>
      'Accedi di nuovo per continuare e sbloccare l\'accesso cliente completo.';

  @override
  String get requestFlowUpgradeSuccessMessage =>
      'Richiesta di servizio inviata. Il tuo account è ora completamente attivato come cliente.';

  @override
  String get requestFlowUpgradeFailedMessage =>
      'Richiesta di servizio inviata. Non siamo ancora riusciti a confermare l\'attivazione cliente.';

  @override
  String get requestFlowSuccessGoToRequests => 'Vai alle richieste';

  @override
  String get requestFlowMissingCompany =>
      'Scegli un\'azienda prima di inviare la richiesta.';

  @override
  String get homeNoReviewsYet => 'Ancora nessuna recensione';

  @override
  String get homeRecommendedLoadFailed =>
      'Impossibile caricare le aziende consigliate.';

  @override
  String get homeTrendingLoadFailed =>
      'Impossibile caricare le aziende di tendenza.';

  @override
  String get homeAllCompaniesLoadFailed => 'Impossibile caricare le aziende.';

  @override
  String get explorePageTitle => 'Esplora';

  @override
  String get explorePagePlaceholderMessage =>
      'I contenuti Esplora arriveranno presto.';

  @override
  String get companyDetailsPageTitle => 'Dettagli azienda';

  @override
  String get companyDetailsContactInfo => 'Informazioni di contatto';

  @override
  String get companyDetailsServices => 'Servizi';

  @override
  String get companyDetailsRecentReviews => 'Recensioni recenti';

  @override
  String get companyDetailsNoContactInfo =>
      'Nessuna informazione di contatto disponibile.';

  @override
  String get companyDetailsNoServicesAvailable => 'Nessun servizio elencato.';

  @override
  String get companyDetailsNoReviewsYet =>
      'Nessuna recensione ancora disponibile.';

  @override
  String get companyDetailsRequestService => 'Richiedi servizio';

  @override
  String get companyDetailsLoadFailed =>
      'Impossibile caricare i dettagli dell\'azienda.';

  @override
  String get companyDetailsLoadMoreReviews => 'Carica altre recensioni';

  @override
  String get companyDetailsAnonymousReviewer => 'Anonimo';

  @override
  String get companyDetailsNoComment => 'Nessun commento fornito.';

  @override
  String get companyDetailsUnknownCompany => 'Azienda sconosciuta';

  @override
  String get companyDetailsUnnamedService => 'Servizio';

  @override
  String get companyDetailsInvalidCompanyId => 'ID azienda non valido.';

  @override
  String get companyDetailsViewAllReviews => 'Vedi tutte le recensioni';

  @override
  String companyDetailsReviewsSectionTitle(int count) {
    return 'Recensioni ($count)';
  }

  @override
  String companyDetailsPlaceholderBody(String companyId) {
    return 'Dettagli azienda per ID: $companyId';
  }

  @override
  String get homeGreeting => 'Ciao';

  @override
  String get companyReviewsPageTitle => 'Tutte le recensioni';

  @override
  String get companyReviewsSortLabel => 'Ordina recensioni';

  @override
  String get companyReviewsSortNewestFirst => 'Più recenti prima';

  @override
  String get companyReviewsSortOldestFirst => 'Più vecchie prima';

  @override
  String get companyReviewsSortHighestRating => 'Valutazione più alta';

  @override
  String get companyReviewsSortLowestRating => 'Valutazione più bassa';

  @override
  String get companyReviewsWriteReview => 'Scrivi una recensione';

  @override
  String get companyReviewsWriteHint => 'Scrivi la tua recensione...';

  @override
  String get companyReviewsWriteSubmit => 'Invia';

  @override
  String get companyReviewsWriteSuccess => 'Recensione inviata con successo.';

  @override
  String get companyReviewsWriteErrorBadRequest =>
      'Recensione non inviata a causa di linguaggio inappropriato. Modifica e riprova.';

  @override
  String get companyReviewsWriteErrorUnauthorized =>
      'Accedi per inviare una recensione.';

  @override
  String get companyReviewsWriteErrorForbidden =>
      'Solo i clienti possono inviare recensioni.';

  @override
  String get companyReviewsWriteErrorNotFound =>
      'Questa azienda non è stata trovata.';

  @override
  String get companyReviewsWriteErrorConflict =>
      'Hai già recensito questa azienda.';

  @override
  String get companyReviewsWriteErrorServer =>
      'Impossibile inviare la recensione al momento. Riprova.';

  @override
  String get companyReviewsWriteErrorNetwork =>
      'Controlla la connessione Internet e riprova.';

  @override
  String get companyReviewsEligibilityInfo =>
      'Puoi recensire solo le aziende con cui sei connesso. Invia una richiesta di servizio e attendi l\'accettazione, oppure gestisci le connessioni dal profilo.';

  @override
  String get companyReviewsViewProfile => 'Vedi profilo';

  @override
  String homeGreetingWithName(String firstName) {
    return 'Ciao, $firstName';
  }

  @override
  String get notificationsPageTitle => 'Notifiche';

  @override
  String get notificationsPagePlaceholderMessage =>
      'I contenuti delle notifiche arriveranno presto.';

  @override
  String get settingsEditProfileTitle => 'Modifica profilo';

  @override
  String get settingsEditProfileSubtitle =>
      'Aggiorna le informazioni personali';

  @override
  String get settingsDigitalSignatureTitle => 'Firma digitale';

  @override
  String get settingsDigitalSignatureMasked => '*********';

  @override
  String get settingsSignaturePasswordTitle => 'Verifica password';

  @override
  String get settingsSignaturePasswordHint => 'Inserisci la password';

  @override
  String get settingsSignaturePasswordSubmit => 'Verifica';

  @override
  String get settingsSignatureCopied => 'Copiato negli appunti';

  @override
  String get settingsSignatureLocked =>
      'Troppi tentativi non riusciti. Riprova tra 15 minuti.';

  @override
  String get settingsChangePasswordTitle => 'Cambia password';

  @override
  String get settingsCurrentPassword => 'Password attuale';

  @override
  String get settingsNewPassword => 'Nuova password';

  @override
  String get settingsConfirmNewPassword => 'Conferma nuova password';

  @override
  String get settingsChangePasswordSubmit => 'Cambia password';

  @override
  String get settingsChangePasswordSuccess =>
      'Password modificata con successo';

  @override
  String get settingsSectionAccountManagement => 'GESTIONE ACCOUNT';

  @override
  String get settingsSectionDigitalSignature => 'FIRMA DIGITALE';

  @override
  String get settingsSectionSecurity => 'SICUREZZA E AUTENTICAZIONE';

  @override
  String get settingsSectionPreferences => 'PREFERENZE APP';

  @override
  String get settingsSecuritySectionTitle => 'Sicurezza e autenticazione';

  @override
  String get settingsLogoutCurrent => 'Disconnetti sessione corrente';

  @override
  String get settingsLogoutAll => 'Disconnetti tutti i dispositivi';

  @override
  String get settingsLogoutAllSubtitle =>
      'Termina tutte le sessioni attive\nsulle piattaforme connesse.';

  @override
  String get settingsLogoutAllConfirmTitle =>
      'Disconnettere tutti i dispositivi?';

  @override
  String get settingsLogoutAllConfirmMessage =>
      'Questo ti disconnetterà da tutti i dispositivi.';

  @override
  String get settingsLogoutAllConfirm => 'Conferma';

  @override
  String get settingsLogoutAllCancel => 'Annulla';

  @override
  String get settingsLanguageTitle => 'Lingua';

  @override
  String get profileRoleLead => 'Lead';

  @override
  String get profileRoleCustomer => 'Cliente';

  @override
  String get profileEditPageTitle => 'Modifica profilo';

  @override
  String get profilePersonalDetailsTitle => 'Dati personali';

  @override
  String get profileAddressInformationTitle => 'Informazioni indirizzo';

  @override
  String get profileConnectedCompaniesTitle => 'Aziende collegate';

  @override
  String get profileConnectedCompaniesEmptyTitle => 'Nessuna azienda collegata';

  @override
  String get profileConnectedCompaniesEmptyMessage =>
      'Collegati a un\'azienda per iniziare a ricevere offerte e richieste di servizio.';

  @override
  String get profileFullNameLabel => 'Nome completo';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String get profilePhoneLabel => 'Telefono';

  @override
  String get profileMemberSince => 'Membro dal';

  @override
  String get profileStreetAddress => 'Indirizzo';

  @override
  String get profileCityLabel => 'Città';

  @override
  String get profileZipCodeLabel => 'CAP';

  @override
  String get profileCityZipLabel => 'Città / CAP';

  @override
  String get profileCountryLabel => 'Paese';

  @override
  String get profileSaveChanges => 'Salva modifiche';

  @override
  String get profileCancel => 'Annulla';

  @override
  String get profileSaveSuccess => 'Profilo aggiornato con successo';

  @override
  String get profileSaveError => 'Impossibile aggiornare il profilo. Riprova.';

  @override
  String get profileCompanyCustomerId => 'ID cliente';

  @override
  String get profileCompanyRequestedAt => 'Richiesto il';

  @override
  String get profileCompanyRespondedAt => 'Risposto il';

  @override
  String get profileCompanyStatusPending => 'In sospeso';

  @override
  String get profileCompanyStatusAccepted => 'Accettato';

  @override
  String get profileCompanyStatusRejected => 'Rifiutato';

  @override
  String get profileCompanyStatusUnknown => 'Sconosciuto';

  @override
  String profileCompanyLoadMore(int count) {
    return 'Carica altro (+$count)';
  }

  @override
  String get requestsPageTitle => 'Richieste';

  @override
  String get requestsHeaderTitle => 'Richieste di servizio';

  @override
  String get requestsHeaderDescription =>
      'Tieni traccia e gestisci le tue richieste di servizio';

  @override
  String get requestsFilterAll => 'Tutte';

  @override
  String get requestsFilterPending => 'In sospeso';

  @override
  String get requestsFilterOfferSent => 'Offerta inviata';

  @override
  String get requestsFilterDeclined => 'Rifiutata';

  @override
  String get requestsFilterExpired => 'Scaduta';

  @override
  String get requestsCardViewRequest => 'Vedi richiesta';

  @override
  String get requestsEmptyTitle => 'Ancora nessuna richiesta';

  @override
  String get requestsEmptyMessage =>
      'Le tue richieste di servizio appariranno qui dopo l\'invio.';

  @override
  String get requestsEmptyBrowseCompanies => 'Sfoglia aziende';

  @override
  String get requestsErrorTitle => 'Qualcosa è andato storto';

  @override
  String get requestsErrorMessage =>
      'Impossibile caricare le tue richieste. Riprova.';

  @override
  String get requestsRetry => 'Riprova';

  @override
  String get requestsLoadMore => 'Caricamento di altre richieste...';

  @override
  String get requestsDetailsTitle => 'Dettagli richiesta';

  @override
  String get requestsDetailsReference => 'Riferimento';

  @override
  String get requestsDetailsCompany => 'Azienda';

  @override
  String get requestsDetailsStatus => 'Stato';

  @override
  String get requestsDetailsServiceType => 'Tipo di servizio';

  @override
  String get requestsDetailsPreferredDate => 'Data preferita';

  @override
  String get requestsDetailsSubmissionDate => 'Data di invio';

  @override
  String get requestsDetailsNotFound => 'Richiesta non trovata.';

  @override
  String get requestsDetailsAccessDenied =>
      'Non hai accesso a questa richiesta.';

  @override
  String get requestsFullPageTitle => 'Tutte le richieste';

  @override
  String get requestsFullPageEmptyTitle =>
      'Nessuna richiesta in questa categoria';

  @override
  String get requestsFullPageEmptyMessage =>
      'Prova a passare a un filtro diverso o sfoglia le aziende.';

  @override
  String get requestsFullPageLoadingMore => 'Caricamento...';

  @override
  String get requestsDateNotAvailable => 'N/D';

  @override
  String get requestDetailsFromPickup => 'DA (RITIRO)';

  @override
  String get requestDetailsToDropoff => 'A (CONSEGNA)';

  @override
  String get requestDetailsPreferredDate => 'Data preferita';

  @override
  String get requestDetailsTimeSlot => 'Fascia oraria';

  @override
  String get requestDetailsCustomerNotes => 'Note del cliente';

  @override
  String get requestDetailsLinkedOffer => 'Offerta collegata';

  @override
  String get requestDetailsEstimatedTotal => 'Totale stimato';

  @override
  String get requestDetailsViewOffer => 'Vedi dettagli offerta';

  @override
  String get offerDetailsTitle => 'Dettagli offerta';

  @override
  String get requestDetailsNotAvailable => 'N/D';

  @override
  String get offersPageTitle => 'Offerte';

  @override
  String get offersEmptyTitle => 'Ancora nessuna offerta';

  @override
  String get offersEmptyMessage =>
      'Non hai ancora offerte. Invia una richiesta di servizio per ricevere preventivi!';

  @override
  String get offersExploreCompanies => 'Esplora aziende';

  @override
  String get offersBackToRequests => 'Torna alle richieste';

  @override
  String get offersFilterAll => 'Tutte';

  @override
  String get offersFilterPending => 'In sospeso';

  @override
  String get offersFilterAccepted => 'Accettate';

  @override
  String get offersFilterRejected => 'Rifiutate';

  @override
  String get offersFilterCanceled => 'Annullate';

  @override
  String get offersTotalAmount => 'Importo totale';

  @override
  String get offersIssueDate => 'Data di emissione';

  @override
  String get offersAcceptDate => 'Data di accettazione';

  @override
  String get offersErrorTitle => 'Qualcosa è andato storto';

  @override
  String get offersErrorMessage =>
      'Impossibile caricare le tue offerte. Riprova.';

  @override
  String get offersRetry => 'Riprova';

  @override
  String get newRequestPageTitle => 'Nuova richiesta di servizio';

  @override
  String get newRequestStepServiceType => 'Tipo di servizio';

  @override
  String get newRequestStepLocations => 'Località';

  @override
  String get newRequestStepSchedule => 'Programmazione e dettagli';

  @override
  String newRequestStepProgress(int step, int total) {
    return 'Passaggio $step di $total';
  }

  @override
  String get newRequestChooseCategory => 'Scegli una categoria';

  @override
  String get newRequestHelperText =>
      'Scegli uno o più servizi. Per ciascuno viene creata una richiesta separata.';

  @override
  String get newRequestServiceTypesPlaceholder => 'Scegli tipi di servizio';

  @override
  String get newRequestServiceTypesHelper =>
      'Seleziona uno o più servizi da richiedere a questa azienda.';

  @override
  String get newRequestServiceTypesDone => 'Fatto';

  @override
  String get newRequestNoServicesAvailable => 'Nessun servizio disponibile';

  @override
  String get newRequestValidationRequired => 'Questo campo è obbligatorio';

  @override
  String get newRequestValidationStreetRequired => 'La via è obbligatoria';

  @override
  String get newRequestValidationCityRequired => 'La città è obbligatoria';

  @override
  String get newRequestValidationCityInvalid => 'Inserisci una città valida';

  @override
  String get newRequestValidationCountryRequired => 'Il paese è obbligatorio';

  @override
  String get newRequestValidationServiceType => 'Seleziona almeno un servizio';

  @override
  String get newRequestFromTitle => 'Da (ritiro)';

  @override
  String get newRequestToTitle => 'A (consegna)';

  @override
  String get newRequestStreetLabel => 'Via';

  @override
  String get newRequestStreetPlaceholder => 'Inserisci il nome della via';

  @override
  String get newRequestCityLabel => 'Città';

  @override
  String get newRequestCityPlaceholder => 'Inserisci città';

  @override
  String get newRequestZipCodeLabel => 'CAP';

  @override
  String get newRequestZipCodePlaceholder => 'Inserisci CAP (opzionale)';

  @override
  String get newRequestCountryLabel => 'Paese';

  @override
  String get newRequestCountryPlaceholder => 'Inserisci paese';

  @override
  String get newRequestPreferredDate => 'Data preferita';

  @override
  String get newRequestTimeSlot => 'Fascia oraria preferita';

  @override
  String get newRequestMorning => 'Mattina (8:00 - 12:00)';

  @override
  String get newRequestAfternoon => 'Pomeriggio (12:00 - 17:00)';

  @override
  String get newRequestEvening => 'Sera (17:00 - 20:00)';

  @override
  String get newRequestNotes => 'Note';

  @override
  String get newRequestNotesHint => 'Aggiungi eventuali dettagli...';

  @override
  String get newRequestInfoBox =>
      'La tua richiesta sarà inviata all\'azienda per la revisione. Riceverai un\'offerta se approvata.';

  @override
  String get newRequestButtonNext => 'Avanti';

  @override
  String get newRequestButtonBack => 'Indietro';

  @override
  String get newRequestButtonSubmit => 'Invia richiesta';

  @override
  String get newRequestSuccessMessage =>
      'Richiesta/e di servizio inviata/e con successo!';

  @override
  String get newRequestSubmitting => 'Invio in corso...';

  @override
  String get newRequestServicesLoadFailed =>
      'Impossibile caricare i servizi. Riprova.';

  @override
  String get homeServices => 'Servizi';

  @override
  String get moreLabell => 'Altro';

  @override
  String get homeDashboardTotalOffers => 'Offerte totali';

  @override
  String get homeDashboardAcceptedOffers => 'Offerte accettate';

  @override
  String get homeDashboardPendingOffers => 'Offerte in sospeso';

  @override
  String get homeDashboardMyReviews => 'Le mie recensioni';

  @override
  String get homeDashboardLoadFailed =>
      'Impossibile caricare le metriche della dashboard.';

  @override
  String get myReviewsPageTitle => 'Le mie recensioni';

  @override
  String get myReviewsEmptyTitle => 'Ancora nessuna recensione';

  @override
  String get myReviewsEmptyMessage =>
      'Le recensioni pubblicate appariranno qui.';

  @override
  String get myReviewsEditAction => 'Modifica';

  @override
  String get myReviewsDeleteAction => 'Elimina';

  @override
  String get myReviewsEditTitle => 'Modifica recensione';

  @override
  String get myReviewsRatingLabel => 'Valutazione';

  @override
  String get myReviewsCommentLabel => 'Commento';

  @override
  String get myReviewsCommentHint => 'Condividi la tua esperienza (opzionale)';

  @override
  String get myReviewsSubmit => 'Salva';

  @override
  String get myReviewsCancel => 'Annulla';

  @override
  String get myReviewsDeleteConfirmTitle => 'Eliminare questa recensione?';

  @override
  String get myReviewsDeleteConfirmMessage =>
      'Questa azione non può essere annullata.';

  @override
  String get myReviewsDeleteConfirmYes => 'Sì, elimina';

  @override
  String get myReviewsDeleteConfirmNo => 'No';

  @override
  String get myReviewsUpdatedSuccess => 'Recensione aggiornata con successo.';

  @override
  String get myReviewsDeletedSuccess => 'Recensione eliminata con successo.';

  @override
  String get myReviewsValidationRatingRequired => 'Seleziona una valutazione.';

  @override
  String get myReviewsLoadFailed =>
      'Impossibile caricare le tue recensioni. Riprova.';

  @override
  String get loadMoreButton => 'Carica altro';

  @override
  String get noMoreItems => 'Nessun altro elemento';

  @override
  String get chatbotTabLabel => 'Assistente';

  @override
  String get chatbotTitle => 'Assistente Wasla';

  @override
  String get chatbotHint =>
      'Chiedi informazioni su aziende, offerte e servizi...';

  @override
  String get chatbotNewConversation => 'Nuova conversazione';

  @override
  String get chatbotWelcomeMessage =>
      'Ciao! Sono il tuo assistente IA Wasla. Come posso aiutarti oggi?';

  @override
  String get chatbotRestrictedTitle => 'Assistente IA';

  @override
  String get chatbotRestrictedMessage =>
      'Accedi per chattare con il nostro assistente IA e ricevere aiuto personalizzato.';

  @override
  String get chatbotNewChat => 'Nuova chat';

  @override
  String get chatbotHistoryTitle => 'Cronologia chat';

  @override
  String get chatbotNoHistory => 'Nessuna chat precedente';

  @override
  String get chatbotDeleteChat => 'Eliminare la chat?';

  @override
  String get chatbotDeleteConfirm => 'Questa azione non può essere annullata.';

  @override
  String get chatbotDeleteQuestion =>
      'Vuoi davvero eliminare questa conversazione?';

  @override
  String get chatbotDeleteYes => 'Sì, elimina';

  @override
  String get chatbotDeleteNo => 'No';

  @override
  String get companyReviewsSubmitting => 'La tua recensione è in revisione';

  @override
  String get offerTotalLabel => 'Importo totale';

  @override
  String get currencyEgp => 'EGP';

  @override
  String get vatIncluded => 'IVA inclusa';

  @override
  String get insuranceCovered => 'Assicurazione inclusa';

  @override
  String get offerSavingsLabel => 'Risparmi';

  @override
  String get locationsTitle => 'Località';

  @override
  String get servicesTitle => 'Servizi';

  @override
  String get insuranceTitle => 'Assicurazione';

  @override
  String get includedInPriceTitle => 'Incluso nel prezzo';

  @override
  String get attachmentTitle => 'Allegato';

  @override
  String get pdfAttachment => 'Documento PDF';

  @override
  String get downloadAttachment => 'Scarica';

  @override
  String get acceptOffer => 'Accetta offerta';

  @override
  String get rejectOffer => 'Rifiuta offerta';

  @override
  String get reviewFullAgreement => 'Rivedi accordo completo';

  @override
  String get buildingTypeLabel => 'Edificio';

  @override
  String get floorLabel => 'Piano';

  @override
  String get elevatorLabel => 'Ascensore';

  @override
  String get availableLabel => 'Disponibile';

  @override
  String get notAvailableLabel => 'Non disponibile';

  @override
  String get yes => 'Sì';

  @override
  String get no => 'No';

  @override
  String get unknownService => 'Servizio';

  @override
  String get additionalCostsLabel => 'Costi aggiuntivi';

  @override
  String get cleaningTypeLabel => 'Tipo di pulizia';

  @override
  String get durationHoursLabel => 'Durata (ore)';

  @override
  String get numberOfStaffLabel => 'Numero di addetti';

  @override
  String get fillNailHolesLabel => 'Riempire i fori dei chiodi';

  @override
  String get highPressureCleanerLabel => 'Idropulitrice';

  @override
  String get cleaningDateLabel => 'Data pulizia';

  @override
  String get cleaningStartTimeLabel => 'Ora di inizio';

  @override
  String get deliveryDateLabel => 'Data di consegna';

  @override
  String get deliveryTimeLabel => 'Ora di consegna';

  @override
  String get discountLabel => 'Sconto';

  @override
  String get offerNotFound => 'Offerta non trovata.';

  @override
  String get offerAccessDenied => 'Non hai accesso a questa offerta.';

  @override
  String get offerLoadFailed =>
      'Impossibile caricare i dettagli dell\'offerta. Riprova.';

  @override
  String get offerDetailsRetry => 'Riprova';

  @override
  String get downloadSuccess => 'File scaricato con successo.';

  @override
  String get downloadFailed => 'Impossibile scaricare il file. Riprova.';

  @override
  String get acceptOfferTitle => 'Accetta offerta';

  @override
  String get acceptOfferReviewHeader =>
      'Rivedi e conferma l\'accettazione dell\'offerta';

  @override
  String get acceptOfferSignatureHint =>
      'Inserisci la tua firma digitale (SIG-...)';

  @override
  String get acceptOfferSignatureRequired => 'La firma digitale è obbligatoria';

  @override
  String get acceptOfferSignatureInvalidPrefix =>
      'La firma deve iniziare con SIG-';

  @override
  String get acceptOfferConfirmationText =>
      'Confermo di aver letto e accettato i termini di questa offerta.';

  @override
  String get acceptOfferConfirmationRequired =>
      'Devi confermare prima di accettare';

  @override
  String get acceptOfferPaymentRequired => 'Seleziona un metodo di pagamento';

  @override
  String get cashOnDelivery => 'Pagamento alla consegna';

  @override
  String get onlinePayment => 'Pagamento online';

  @override
  String get acceptOfferSubmit => 'Accetta offerta';

  @override
  String get acceptOfferCancel => 'Annulla';

  @override
  String get acceptOfferSuccessCod => 'Offerta accettata con successo!';

  @override
  String get acceptOfferSuccessOnline => 'Reindirizzamento al pagamento...';

  @override
  String get acceptOfferCheckoutError =>
      'Impossibile aprire la pagina di pagamento. Riprova.';

  @override
  String get acceptOfferTerminalState =>
      'Questa offerta non può più essere accettata.';

  @override
  String get acceptOfferForbidden =>
      'Non hai il permesso di accettare questa offerta.';

  @override
  String get acceptOfferPaymentConfigMissing =>
      'Il pagamento online non è disponibile. Contatta il supporto.';

  @override
  String get acceptOfferFailed => 'Impossibile accettare l\'offerta. Riprova.';

  @override
  String get rejectOfferTitle => 'Rifiuta offerta';

  @override
  String get rejectOfferWarningHeader =>
      'Sei sicuro di voler rifiutare questa offerta?';

  @override
  String get rejectOfferWarningText =>
      'Questa azione non può essere annullata. L\'azienda sarà informata della tua decisione.';

  @override
  String get rejectOfferReasonHint =>
      'Spiega perché stai rifiutando questa offerta...';

  @override
  String get rejectOfferReasonRequired =>
      'Il motivo del rifiuto è obbligatorio';

  @override
  String get rejectOfferReasonTooLong =>
      'Il motivo deve contenere al massimo 2.000 caratteri';

  @override
  String get rejectOfferSubmit => 'Rifiuta offerta';

  @override
  String get rejectOfferCancel => 'Annulla';

  @override
  String get rejectOfferSuccess => 'Offerta rifiutata.';

  @override
  String get rejectOfferTerminalState =>
      'Questa offerta non può più essere rifiutata.';

  @override
  String get rejectOfferForbidden =>
      'Non hai il permesso di rifiutare questa offerta.';

  @override
  String get rejectOfferFailed => 'Impossibile rifiutare l\'offerta. Riprova.';

  @override
  String get offerSummaryCardTitle => 'Riepilogo offerta';

  @override
  String get offerNumberLabel => 'Offerta #';

  @override
  String get companyLabel => 'Azienda';

  @override
  String get rejectionReasonLabel => 'MOTIVO DEL RIFIUTO ';

  @override
  String get acceptOfferFinalizeTitle => 'Finalizza accettazione.';

  @override
  String acceptOfferFinalizeSubtitle(String providerName) {
    return 'Controlla attentamente i dettagli dell\'offerta di $providerName prima di applicare la firma digitale per rendere vincolante l\'accordo.';
  }

  @override
  String get acceptOfferDigitalSignatureLabel => 'FIRMA DIGITALE';

  @override
  String get acceptOfferSignatureHintPart1 =>
      'Suggerimento: puoi trovare la tua firma digitale in ';

  @override
  String get acceptOfferSignatureHintPart2 => 'Impostazioni -> Firma digitale';

  @override
  String get acceptOfferSignatureHintPart3 =>
      ' (richiede verifica della password).';

  @override
  String get acceptOfferConfirmationTextLong =>
      'Confermo di voler accettare questa offerta e firmare con la mia firma digitale. Comprendo che questa azione è legalmente vincolante.';

  @override
  String get acceptOfferSignAndAccept => 'Firma e accetta';

  @override
  String get entryReferenceLabel => 'RIFERIMENTO INGRESSO';

  @override
  String get statusLabel => 'STATO';

  @override
  String get providerIdentityLabel => 'IDENTITÀ FORNITORE';

  @override
  String get valuationLabel => 'VALUTAZIONE';

  @override
  String get offerReferenceLabel => 'RIFERIMENTO OFFERTA';

  @override
  String get totalContractValueLabel => 'VALORE TOTALE CONTRATTO';

  @override
  String get serviceHeader => 'SERVIZIO';

  @override
  String get costHeader => 'COSTO';

  @override
  String get chatbotSuggestionHelp => 'In cosa puoi aiutarmi?';

  @override
  String get chatbotSuggestionExploreServices => 'Esplora servizi';

  @override
  String get chatbotSuggestionViewOffers => 'Vedi le mie offerte';

  @override
  String get chatbotSuggestionFindCompany => 'Trova un\'azienda adatta';

  @override
  String get chatbotSuggestionCreateRequest => 'Crea una richiesta di servizio';

  @override
  String get chatbotSuggestionTrackStatus => 'Traccia stato richiesta';
}
