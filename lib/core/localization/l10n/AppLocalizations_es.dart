// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'AppLocalizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get onboardingLogIn => 'Iniciar sesión';

  @override
  String get onboardingNewUser => 'Nuevo usuario';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageArabic => 'Árabe';

  @override
  String get supportPageTitle => 'Soporte';

  @override
  String get supportPageDescription =>
      'Para obtener soporte, contáctanos en waslacrmteam@wasla.com';

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get loginEmail => 'Correo electrónico';

  @override
  String get loginPassword => 'Contraseña';

  @override
  String get loginRememberMe => 'Recordarme';

  @override
  String get loginForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get loginSignIn => 'Iniciar sesión';

  @override
  String get loginSignUp => '¿No tienes una cuenta? Regístrate';

  @override
  String get loginSignUpAction => 'Regístrate';

  @override
  String get loginInvalidCredentials =>
      'Correo electrónico o contraseña no válidos';

  @override
  String get loginEmailRequired => 'El correo electrónico es obligatorio';

  @override
  String get loginPasswordRequired => 'La contraseña es obligatoria';

  @override
  String get loginEmailInvalid => 'Introduce un correo electrónico válido';

  @override
  String get loginUnexpectedError =>
      'Se produjo un error inesperado. Inténtalo de nuevo.';

  @override
  String get loginNoConnection => 'Sin conexión a Internet. Comprueba tu red.';

  @override
  String get loginRateLimited => 'Demasiados intentos. Inténtalo más tarde.';

  @override
  String get loginSessionExpired => 'La sesión expiró. Inicia sesión de nuevo.';

  @override
  String get loginErrorInvalidCredentials =>
      'Credenciales no válidas o cuenta inactiva.';

  @override
  String get loginErrorAccountNotSetup =>
      'Tu cuenta no está completamente configurada. Contacta con soporte.';

  @override
  String get loginErrorRateLimit =>
      'Demasiados intentos de inicio de sesión. Inténtalo más tarde.';

  @override
  String get loginErrorNetwork =>
      'Sin conexión a Internet. Comprueba tu red e inténtalo de nuevo.';

  @override
  String get loginErrorServer =>
      'Se produjo un error inesperado. Inténtalo más tarde.';

  @override
  String get forgotPasswordTitle => '¿Olvidaste tu contraseña?';

  @override
  String get forgotPasswordDescription =>
      '¡No te preocupes! Suele pasar. Introduce el correo electrónico vinculado a tu cuenta.';

  @override
  String get forgotPasswordEmailLabel => 'Introduce tu correo electrónico';

  @override
  String get forgotPasswordEmailPlaceholder => 'tucorreo@gmail.com';

  @override
  String get forgotPasswordSend => 'Enviar';

  @override
  String get forgotPasswordSuccess =>
      'Enlace de restablecimiento enviado correctamente';

  @override
  String get forgotPasswordEmailRequired =>
      'El correo electrónico es obligatorio';

  @override
  String get forgotPasswordEmailInvalid =>
      'Introduce un correo electrónico válido';

  @override
  String get signUpTitle => 'Registrarse';

  @override
  String get signUpFirstName => 'Nombre';

  @override
  String get signUpLastName => 'Apellido';

  @override
  String get signUpPhoneNumber => 'Número de teléfono';

  @override
  String get signUpEmail => 'Correo electrónico';

  @override
  String get signUpEmailHint => 'tucorreo@gmail.com';

  @override
  String get signUpPassword => 'Contraseña';

  @override
  String get signUpConfirmPassword => 'Confirmar contraseña';

  @override
  String get signUpButton => 'Registrarse';

  @override
  String get signUpHaveAccount => '¿Ya tienes una cuenta? Inicia sesión';

  @override
  String get signUpHaveAccountAction => 'Iniciar sesión';

  @override
  String get signUpFirstNameRequired => 'El nombre es obligatorio';

  @override
  String get signUpLastNameRequired => 'El apellido es obligatorio';

  @override
  String get signUpNameTooLong => 'Debe tener 100 caracteres o menos';

  @override
  String get signUpNameLettersOnly => 'El nombre solo debe contener letras';

  @override
  String get signUpPhoneTooLong => 'Debe tener 50 caracteres o menos';

  @override
  String get signUpPhoneInvalid =>
      'El número de teléfono debe tener exactamente 11 dígitos';

  @override
  String get signUpEmailRequired => 'El correo electrónico es obligatorio';

  @override
  String get signUpEmailInvalid => 'Introduce un correo electrónico válido';

  @override
  String get signUpPasswordRequired => 'Introduce una contraseña';

  @override
  String get signUpPasswordTooShort => 'Usa 8 caracteres o más';

  @override
  String get signUpPasswordMissingUppercase => 'Añade una letra mayúscula';

  @override
  String get signUpPasswordMissingNumber => 'Añade un número';

  @override
  String get signUpPasswordMissingSpecial => 'Añade un carácter especial';

  @override
  String get signUpConfirmPasswordRequired => 'Confirma tu contraseña';

  @override
  String get signUpConfirmPasswordMismatch => 'Las contraseñas no coinciden';

  @override
  String get signUpErrorEmailInUse => 'Este correo ya está registrado';

  @override
  String get signUpErrorServer => 'Algo salió mal. Inténtalo más tarde.';

  @override
  String get signUpErrorNetwork => 'Sin conexión a Internet. Comprueba tu red.';

  @override
  String get signUpErrorUnexpected =>
      'Se produjo un error inesperado. Inténtalo de nuevo.';

  @override
  String get signUpSuccessMessage => '¡Te has registrado correctamente!';

  @override
  String get signUpSuccessButton => 'Empezar';

  @override
  String get networkErrorNoConnection => 'Sin conexión a Internet';

  @override
  String get networkErrorRetry => 'Reintentar';

  @override
  String get networkErrorServer => 'Error del servidor. Inténtalo más tarde.';

  @override
  String get otpVerificationTitle => 'Cambiar contraseña';

  @override
  String get otpVerificationDescription =>
      'Introduce el OTP enviado a tu correo para continuar.';

  @override
  String otpVerificationTimerText(int seconds) {
    return 'Reenviar código en ${seconds}s';
  }

  @override
  String get otpVerificationResend => 'Reenviar OTP';

  @override
  String get otpVerificationVerify => 'Verificar';

  @override
  String get otpVerificationOtpRequired => 'Introduce el código OTP';

  @override
  String get otpVerificationOtpInvalid =>
      'Introduce un código válido de 6 dígitos';

  @override
  String get changePasswordTitle => 'Cambiar contraseña';

  @override
  String get changePasswordDescription =>
      'Tu nueva contraseña debe ser diferente de las anteriores.';

  @override
  String get changePasswordNewPasswordLabel => 'Nueva contraseña';

  @override
  String get changePasswordConfirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get changePasswordConfirm => 'Confirmar';

  @override
  String get changePasswordMinLength =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get changePasswordMismatch => 'Las contraseñas no coinciden';

  @override
  String get changePasswordSuccess => 'Contraseña restablecida correctamente';

  @override
  String get errorRateLimit => 'Demasiadas solicitudes. Inténtalo más tarde.';

  @override
  String get errorNetwork =>
      'Sin conexión a Internet. Comprueba tu red e inténtalo de nuevo.';

  @override
  String get errorExpiredOtp => 'Tu OTP ha caducado. Solicita uno nuevo.';

  @override
  String get errorPasswordPolicy =>
      'La contraseña no cumple los requisitos mínimos.';

  @override
  String get errorServer =>
      'Se produjo un error inesperado. Inténtalo más tarde.';

  @override
  String get signatureModalTitle => 'Tu firma digital';

  @override
  String get signatureModalGuidance =>
      'Guarda esta firma de forma segura. La necesitarás para aprobar ofertas.';

  @override
  String get signatureModalDownloadError =>
      'No se pudo guardar la firma. Inténtalo de nuevo.';

  @override
  String get signatureModalOk => 'Aceptar';

  @override
  String get signatureModalDownloadButton => 'Descargar firma';

  @override
  String get signUpErrorMissingSignature =>
      'Registro incompleto. Inténtalo de nuevo o contacta con soporte.';

  @override
  String get signatureModalCopySuccess => 'Firma copiada al portapapeles.';

  @override
  String get forgotPasswordNotRegistered =>
      'Correo no registrado. Regístrate primero.';

  @override
  String get forgotPasswordInactiveAccount =>
      'La cuenta existe pero está inactiva — contacta con soporte.';

  @override
  String get forgotPasswordSignUp => '¿No tienes una cuenta? Regístrate';

  @override
  String get forgotPasswordSignUpAction => 'Regístrate';

  @override
  String get forgotPasswordContactSupport => 'Contactar soporte';

  @override
  String forgotPasswordRateLimitWait(int seconds) {
    return 'Inténtalo de nuevo en ${seconds}s';
  }

  @override
  String get passwordRuleMinLength => '8+ caracteres';

  @override
  String get passwordRuleNumber => '1+ número';

  @override
  String get passwordRuleUppercase => '1+ letra mayúscula';

  @override
  String get passwordRuleSpecial => '1+ carácter especial (!@#\$%^&*)';

  @override
  String get passwordStrengthWeak => 'Débil';

  @override
  String get passwordStrengthMedium => 'Media';

  @override
  String get passwordStrengthStrong => 'Fuerte';

  @override
  String get passwordStrengthHelperFeedback =>
      'Elige una contraseña más segura.';

  @override
  String get homeSearchForServicesOrCompanies => 'Buscar servicios o empresas';

  @override
  String get homeRecommendedCompanies => 'Empresas recomendadas';

  @override
  String get homeTrendingCompanies => 'Empresas en tendencia';

  @override
  String get homeAllCompanies => 'Todas las empresas';

  @override
  String get homeViewAll => 'Ver todo';

  @override
  String get navigationHome => 'Inicio';

  @override
  String get navigationCompanies => 'Empresas';

  @override
  String get navigationSignIn => 'Iniciar sesión';

  @override
  String get navigationRequests => 'Solicitudes';

  @override
  String get navigationOffers => 'Ofertas';

  @override
  String get navigationProfile => 'Perfil';

  @override
  String get navigationSettings => 'Configuración';

  @override
  String get navigationAllCompanies => 'Todas las empresas';

  @override
  String get navigationRecommended => 'Recomendadas';

  @override
  String get navigationTrending => 'Tendencias';

  @override
  String get a11yCompaniesDropdownButton => 'Abrir opciones de empresas';

  @override
  String get a11ySettingsTabButton => 'Abrir configuración';

  @override
  String get a11yViewAllButton => 'Ver todas las empresas de esta sección';

  @override
  String get exploreSearchCompanies => 'Buscar empresas...';

  @override
  String get exploreSearchCity => 'Ciudad...';

  @override
  String get exploreAllServices => 'Todos los servicios';

  @override
  String get exploreMove => 'Mudanza';

  @override
  String get exploreCleaning => 'Limpieza';

  @override
  String get exploreDisposal => 'Eliminación';

  @override
  String get explorePacking => 'Embalaje';

  @override
  String get exploreUnpacking => 'Desembalaje';

  @override
  String get exploreStorage => 'Almacenamiento';

  @override
  String get exploreTransport => 'Transporte';

  @override
  String get exploreNoCompaniesFound => 'No se encontraron empresas';

  @override
  String get exploreTryAdjustingFilters =>
      'Prueba ajustando tus filtros de búsqueda';

  @override
  String get exploreClearFilters => 'Borrar filtros';

  @override
  String get restrictionLoginOrRegister =>
      'Inicia sesión para desbloquear este destino.';

  @override
  String get restrictionContinue => 'Continuar';

  @override
  String get restrictionCancel => 'Cancelar';

  @override
  String get restrictionBrowseCompanies => 'Volver a empresas';

  @override
  String get restrictionRequestsTitle =>
      'Las solicitudes requieren iniciar sesión';

  @override
  String get restrictionOffersTitle => 'Las ofertas requieren iniciar sesión';

  @override
  String get restrictionProfileTitle => 'El perfil requiere iniciar sesión';

  @override
  String get restrictionRequestsMessage =>
      'Inicia sesión para seguir y gestionar tus solicitudes.';

  @override
  String get restrictionOffersMessage =>
      'Inicia sesión para ver y comparar tus ofertas.';

  @override
  String get restrictionProfileMessage =>
      'Inicia sesión para acceder a tu perfil y configuración.';

  @override
  String get requestFlowContinuePromptTitle =>
      'Inicia sesión para solicitar este servicio';

  @override
  String get requestFlowContinuePromptMessage =>
      'Continúa para iniciar sesión y solicitar un servicio a esta empresa.';

  @override
  String get requestFlowLeadReloginPromptTitle =>
      'Completa la configuración para continuar';

  @override
  String get requestFlowLeadReloginPromptMessage =>
      'Inicia sesión de nuevo para continuar y desbloquear tu acceso completo como cliente.';

  @override
  String get requestFlowUpgradeSuccessMessage =>
      'Solicitud de servicio enviada. Tu cuenta ya está completamente activada como cliente.';

  @override
  String get requestFlowUpgradeFailedMessage =>
      'Solicitud de servicio enviada. Aún no pudimos confirmar tu activación como cliente.';

  @override
  String get requestFlowSuccessGoToRequests => 'Ir a solicitudes';

  @override
  String get requestFlowMissingCompany =>
      'Elige una empresa antes de enviar tu solicitud.';

  @override
  String get homeNoReviewsYet => 'Aún no hay reseñas';

  @override
  String get homeRecommendedLoadFailed =>
      'No se pudieron cargar las empresas recomendadas.';

  @override
  String get homeTrendingLoadFailed =>
      'No se pudieron cargar las empresas en tendencia.';

  @override
  String get homeAllCompaniesLoadFailed =>
      'No se pudieron cargar las empresas.';

  @override
  String get explorePageTitle => 'Explorar';

  @override
  String get explorePagePlaceholderMessage =>
      'El contenido de exploración estará disponible pronto.';

  @override
  String get companyDetailsPageTitle => 'Detalles de la empresa';

  @override
  String get companyDetailsContactInfo => 'Información de contacto';

  @override
  String get companyDetailsServices => 'Servicios';

  @override
  String get companyDetailsRecentReviews => 'Reseñas recientes';

  @override
  String get companyDetailsNoContactInfo =>
      'No hay información de contacto disponible.';

  @override
  String get companyDetailsNoServicesAvailable => 'No hay servicios listados.';

  @override
  String get companyDetailsNoReviewsYet => 'Aún no hay reseñas disponibles.';

  @override
  String get companyDetailsRequestService => 'Solicitar servicio';

  @override
  String get companyDetailsLoadFailed =>
      'No se pudieron cargar los detalles de la empresa.';

  @override
  String get companyDetailsLoadMoreReviews => 'Cargar más reseñas';

  @override
  String get companyDetailsAnonymousReviewer => 'Anónimo';

  @override
  String get companyDetailsNoComment => 'Sin comentario.';

  @override
  String get companyDetailsUnknownCompany => 'Empresa desconocida';

  @override
  String get companyDetailsUnnamedService => 'Servicio';

  @override
  String get companyDetailsInvalidCompanyId => 'ID de empresa no válido.';

  @override
  String get companyDetailsViewAllReviews => 'Ver todas las reseñas';

  @override
  String companyDetailsReviewsSectionTitle(int count) {
    return 'Reseñas ($count)';
  }

  @override
  String companyDetailsPlaceholderBody(String companyId) {
    return 'Detalles de la empresa para ID: $companyId';
  }

  @override
  String get homeGreeting => 'Hola';

  @override
  String get companyReviewsPageTitle => 'Todas las reseñas';

  @override
  String get companyReviewsSortLabel => 'Ordenar reseñas';

  @override
  String get companyReviewsSortNewestFirst => 'Más recientes primero';

  @override
  String get companyReviewsSortOldestFirst => 'Más antiguas primero';

  @override
  String get companyReviewsSortHighestRating => 'Calificación más alta';

  @override
  String get companyReviewsSortLowestRating => 'Calificación más baja';

  @override
  String get companyReviewsWriteReview => 'Escribir una reseña';

  @override
  String get companyReviewsWriteHint => 'Escribe tu reseña...';

  @override
  String get companyReviewsWriteSubmit => 'Enviar';

  @override
  String get companyReviewsWriteSuccess => 'Reseña enviada correctamente.';

  @override
  String get companyReviewsWriteErrorBadRequest =>
      'Reseña no enviada por lenguaje inapropiado. Edítala e inténtalo de nuevo.';

  @override
  String get companyReviewsWriteErrorUnauthorized =>
      'Inicia sesión para enviar una reseña.';

  @override
  String get companyReviewsWriteErrorForbidden =>
      'Solo los clientes pueden enviar reseñas.';

  @override
  String get companyReviewsWriteErrorNotFound =>
      'No se pudo encontrar esta empresa.';

  @override
  String get companyReviewsWriteErrorConflict =>
      'Ya has reseñado esta empresa.';

  @override
  String get companyReviewsWriteErrorServer =>
      'No se puede enviar la reseña ahora. Inténtalo de nuevo.';

  @override
  String get companyReviewsWriteErrorNetwork =>
      'Comprueba tu conexión a Internet e inténtalo de nuevo.';

  @override
  String get companyReviewsEligibilityInfo =>
      'Solo puedes reseñar empresas con las que estás conectado. Envía una solicitud de servicio y espera la aceptación, o gestiona conexiones desde tu perfil.';

  @override
  String get companyReviewsViewProfile => 'Ver perfil';

  @override
  String homeGreetingWithName(String firstName) {
    return 'Hola, $firstName';
  }

  @override
  String get notificationsPageTitle => 'Notificaciones';

  @override
  String get notificationsPagePlaceholderMessage =>
      'El contenido de notificaciones estará disponible pronto.';

  @override
  String get settingsEditProfileTitle => 'Editar perfil';

  @override
  String get settingsEditProfileSubtitle =>
      'Actualizar tu información personal';

  @override
  String get settingsDigitalSignatureTitle => 'Firma digital';

  @override
  String get settingsDigitalSignatureMasked => '*********';

  @override
  String get settingsSignaturePasswordTitle => 'Verificar contraseña';

  @override
  String get settingsSignaturePasswordHint => 'Introduce tu contraseña';

  @override
  String get settingsSignaturePasswordSubmit => 'Verificar';

  @override
  String get settingsSignatureCopied => 'Copiado al portapapeles';

  @override
  String get settingsSignatureLocked =>
      'Demasiados intentos fallidos. Inténtalo de nuevo después de 15 minutos.';

  @override
  String get settingsChangePasswordTitle => 'Cambiar contraseña';

  @override
  String get settingsCurrentPassword => 'Contraseña actual';

  @override
  String get settingsNewPassword => 'Nueva contraseña';

  @override
  String get settingsConfirmNewPassword => 'Confirmar nueva contraseña';

  @override
  String get settingsChangePasswordSubmit => 'Cambiar contraseña';

  @override
  String get settingsChangePasswordSuccess =>
      'Contraseña cambiada correctamente';

  @override
  String get settingsSectionAccountManagement => 'GESTIÓN DE CUENTA';

  @override
  String get settingsSectionDigitalSignature => 'FIRMA DIGITAL';

  @override
  String get settingsSectionSecurity => 'SEGURIDAD Y AUTENTICACIÓN';

  @override
  String get settingsSectionPreferences => 'PREFERENCIAS DE LA APLICACIÓN';

  @override
  String get settingsSecuritySectionTitle => 'Seguridad y autenticación';

  @override
  String get settingsLogoutCurrent => 'Cerrar sesión actual';

  @override
  String get settingsLogoutAll => 'Cerrar sesión en todos los dispositivos';

  @override
  String get settingsLogoutAllSubtitle =>
      'Finaliza todas las sesiones activas\nen tus plataformas conectadas.';

  @override
  String get settingsLogoutAllConfirmTitle =>
      '¿Cerrar sesión en todos los dispositivos?';

  @override
  String get settingsLogoutAllConfirmMessage =>
      'Esto cerrará tu sesión en todos los dispositivos.';

  @override
  String get settingsLogoutAllConfirm => 'Confirmar';

  @override
  String get settingsLogoutAllCancel => 'Cancelar';

  @override
  String get settingsLanguageTitle => 'Idioma';

  @override
  String get profileRoleLead => 'Lead';

  @override
  String get profileRoleCustomer => 'Cliente';

  @override
  String get profileEditPageTitle => 'Editar perfil';

  @override
  String get profilePersonalDetailsTitle => 'Datos personales';

  @override
  String get profileAddressInformationTitle => 'Información de dirección';

  @override
  String get profileConnectedCompaniesTitle => 'Empresas conectadas';

  @override
  String get profileConnectedCompaniesEmptyTitle =>
      'No hay empresas conectadas';

  @override
  String get profileConnectedCompaniesEmptyMessage =>
      'Conéctate con una empresa para empezar a recibir ofertas y solicitudes de servicio.';

  @override
  String get profileFullNameLabel => 'Nombre completo';

  @override
  String get profileEmailLabel => 'Correo electrónico';

  @override
  String get profilePhoneLabel => 'Teléfono';

  @override
  String get profileMemberSince => 'Miembro desde';

  @override
  String get profileStreetAddress => 'Dirección';

  @override
  String get profileCityLabel => 'Ciudad';

  @override
  String get profileZipCodeLabel => 'Código postal';

  @override
  String get profileCityZipLabel => 'Ciudad / Código postal';

  @override
  String get profileCountryLabel => 'País';

  @override
  String get profileSaveChanges => 'Guardar cambios';

  @override
  String get profileCancel => 'Cancelar';

  @override
  String get profileSaveSuccess => 'Perfil actualizado correctamente';

  @override
  String get profileSaveError =>
      'No se pudo actualizar el perfil. Inténtalo de nuevo.';

  @override
  String get profileCompanyCustomerId => 'ID de cliente';

  @override
  String get profileCompanyRequestedAt => 'Solicitado el';

  @override
  String get profileCompanyRespondedAt => 'Respondido el';

  @override
  String get profileCompanyStatusPending => 'Pendiente';

  @override
  String get profileCompanyStatusAccepted => 'Aceptado';

  @override
  String get profileCompanyStatusRejected => 'Rechazado';

  @override
  String get profileCompanyStatusUnknown => 'Desconocido';

  @override
  String profileCompanyLoadMore(int count) {
    return 'Cargar más (+$count)';
  }

  @override
  String get requestsPageTitle => 'Solicitudes';

  @override
  String get requestsHeaderTitle => 'Solicitudes de servicio';

  @override
  String get requestsHeaderDescription =>
      'Sigue y gestiona tus solicitudes de servicio';

  @override
  String get requestsFilterAll => 'Todas';

  @override
  String get requestsFilterPending => 'Pendientes';

  @override
  String get requestsFilterOfferSent => 'Oferta enviada';

  @override
  String get requestsFilterDeclined => 'Rechazada';

  @override
  String get requestsFilterExpired => 'Caducada';

  @override
  String get requestsCardViewRequest => 'Ver solicitud';

  @override
  String get requestsEmptyTitle => 'Aún no hay solicitudes';

  @override
  String get requestsEmptyMessage =>
      'Tus solicitudes de servicio aparecerán aquí cuando envíes una.';

  @override
  String get requestsEmptyBrowseCompanies => 'Explorar empresas';

  @override
  String get requestsErrorTitle => 'Algo salió mal';

  @override
  String get requestsErrorMessage =>
      'No se pudieron cargar tus solicitudes. Inténtalo de nuevo.';

  @override
  String get requestsRetry => 'Reintentar';

  @override
  String get requestsLoadMore => 'Cargando más solicitudes...';

  @override
  String get requestsDetailsTitle => 'Detalles de la solicitud';

  @override
  String get requestsDetailsReference => 'Referencia';

  @override
  String get requestsDetailsCompany => 'Empresa';

  @override
  String get requestsDetailsStatus => 'Estado';

  @override
  String get requestsDetailsServiceType => 'Tipo de servicio';

  @override
  String get requestsDetailsPreferredDate => 'Fecha preferida';

  @override
  String get requestsDetailsSubmissionDate => 'Fecha de envío';

  @override
  String get requestsDetailsNotFound => 'Solicitud no encontrada.';

  @override
  String get requestsDetailsAccessDenied =>
      'No tienes acceso a esta solicitud.';

  @override
  String get requestsFullPageTitle => 'Todas las solicitudes';

  @override
  String get requestsFullPageEmptyTitle =>
      'No hay solicitudes en esta categoría';

  @override
  String get requestsFullPageEmptyMessage =>
      'Prueba cambiando a otro filtro o explorando empresas.';

  @override
  String get requestsFullPageLoadingMore => 'Cargando más...';

  @override
  String get requestsDateNotAvailable => 'N/D';

  @override
  String get requestDetailsFromPickup => 'DESDE (RECOGIDA)';

  @override
  String get requestDetailsToDropoff => 'HASTA (ENTREGA)';

  @override
  String get requestDetailsPreferredDate => 'Fecha preferida';

  @override
  String get requestDetailsTimeSlot => 'Franja horaria';

  @override
  String get requestDetailsCustomerNotes => 'Notas del cliente';

  @override
  String get requestDetailsLinkedOffer => 'Oferta vinculada';

  @override
  String get requestDetailsEstimatedTotal => 'Total estimado';

  @override
  String get requestDetailsViewOffer => 'Ver detalles de la oferta';

  @override
  String get offerDetailsTitle => 'Detalles de la oferta';

  @override
  String get requestDetailsNotAvailable => 'N/D';

  @override
  String get offersPageTitle => 'Ofertas';

  @override
  String get offersEmptyTitle => 'Aún no hay ofertas';

  @override
  String get offersEmptyMessage =>
      'Aún no tienes ofertas. ¡Envía una solicitud de servicio para recibir cotizaciones!';

  @override
  String get offersExploreCompanies => 'Explorar empresas';

  @override
  String get offersBackToRequests => 'Volver a solicitudes';

  @override
  String get offersFilterAll => 'Todas';

  @override
  String get offersFilterPending => 'Pendientes';

  @override
  String get offersFilterAccepted => 'Aceptadas';

  @override
  String get offersFilterRejected => 'Rechazadas';

  @override
  String get offersFilterCanceled => 'Canceladas';

  @override
  String get offersTotalAmount => 'Importe total';

  @override
  String get offersIssueDate => 'Fecha de emisión';

  @override
  String get offersAcceptDate => 'Fecha de aceptación';

  @override
  String get offersErrorTitle => 'Algo salió mal';

  @override
  String get offersErrorMessage =>
      'No se pudieron cargar tus ofertas. Inténtalo de nuevo.';

  @override
  String get offersRetry => 'Reintentar';

  @override
  String get newRequestPageTitle => 'Nueva solicitud de servicio';

  @override
  String get newRequestStepServiceType => 'Tipo de servicio';

  @override
  String get newRequestStepLocations => 'Ubicaciones';

  @override
  String get newRequestStepSchedule => 'Horario y detalles';

  @override
  String newRequestStepProgress(int step, int total) {
    return 'Paso $step de $total';
  }

  @override
  String get newRequestChooseCategory => 'Elegir una categoría';

  @override
  String get newRequestHelperText =>
      'Elige uno o más servicios. Se crea una solicitud separada para cada uno.';

  @override
  String get newRequestServiceTypesPlaceholder => 'Elegir tipos de servicio';

  @override
  String get newRequestServiceTypesHelper =>
      'Selecciona uno o más servicios para solicitar a esta empresa.';

  @override
  String get newRequestServiceTypesDone => 'Listo';

  @override
  String get newRequestNoServicesAvailable => 'No hay servicios disponibles';

  @override
  String get newRequestValidationRequired => 'Este campo es obligatorio';

  @override
  String get newRequestValidationStreetRequired => 'La calle es obligatoria';

  @override
  String get newRequestValidationCityRequired => 'La ciudad es obligatoria';

  @override
  String get newRequestValidationCityInvalid => 'Introduce una ciudad válida';

  @override
  String get newRequestValidationCountryRequired => 'El país es obligatorio';

  @override
  String get newRequestValidationServiceType =>
      'Selecciona al menos un servicio';

  @override
  String get newRequestFromTitle => 'Desde (recogida)';

  @override
  String get newRequestToTitle => 'Hasta (entrega)';

  @override
  String get newRequestStreetLabel => 'Calle';

  @override
  String get newRequestStreetPlaceholder => 'Introduce el nombre de la calle';

  @override
  String get newRequestCityLabel => 'Ciudad';

  @override
  String get newRequestCityPlaceholder => 'Introduce ciudad';

  @override
  String get newRequestZipCodeLabel => 'Código postal';

  @override
  String get newRequestZipCodePlaceholder =>
      'Introduce código postal (opcional)';

  @override
  String get newRequestCountryLabel => 'País';

  @override
  String get newRequestCountryPlaceholder => 'Introduce país';

  @override
  String get newRequestPreferredDate => 'Fecha preferida';

  @override
  String get newRequestTimeSlot => 'Franja horaria preferida';

  @override
  String get newRequestMorning => 'Mañana (8:00 - 12:00)';

  @override
  String get newRequestAfternoon => 'Tarde (12:00 - 17:00)';

  @override
  String get newRequestEvening => 'Noche (17:00 - 20:00)';

  @override
  String get newRequestNotes => 'Notas';

  @override
  String get newRequestNotesHint => 'Añade detalles adicionales...';

  @override
  String get newRequestInfoBox =>
      'Tu solicitud se enviará a la empresa para revisión. Recibirás una oferta si se aprueba.';

  @override
  String get newRequestButtonNext => 'Siguiente';

  @override
  String get newRequestButtonBack => 'Atrás';

  @override
  String get newRequestButtonSubmit => 'Enviar solicitud';

  @override
  String get newRequestSuccessMessage =>
      '¡Solicitud(es) de servicio enviadas correctamente!';

  @override
  String get newRequestSubmitting => 'Enviando...';

  @override
  String get newRequestServicesLoadFailed =>
      'No se pudieron cargar los servicios. Inténtalo de nuevo.';

  @override
  String get homeServices => 'Servicios';

  @override
  String get moreLabell => 'Más';

  @override
  String get homeDashboardTotalOffers => 'Ofertas totales';

  @override
  String get homeDashboardAcceptedOffers => 'Ofertas aceptadas';

  @override
  String get homeDashboardPendingOffers => 'Ofertas pendientes';

  @override
  String get homeDashboardMyReviews => 'Mis reseñas';

  @override
  String get homeDashboardLoadFailed =>
      'No se pudieron cargar las métricas del panel.';

  @override
  String get myReviewsPageTitle => 'Mis reseñas';

  @override
  String get myReviewsEmptyTitle => 'Aún no hay reseñas';

  @override
  String get myReviewsEmptyMessage => 'Tus reseñas publicadas aparecerán aquí.';

  @override
  String get myReviewsEditAction => 'Editar';

  @override
  String get myReviewsDeleteAction => 'Eliminar';

  @override
  String get myReviewsEditTitle => 'Editar reseña';

  @override
  String get myReviewsRatingLabel => 'Calificación';

  @override
  String get myReviewsCommentLabel => 'Comentario';

  @override
  String get myReviewsCommentHint => 'Comparte tu experiencia (opcional)';

  @override
  String get myReviewsSubmit => 'Guardar';

  @override
  String get myReviewsCancel => 'Cancelar';

  @override
  String get myReviewsDeleteConfirmTitle => '¿Eliminar esta reseña?';

  @override
  String get myReviewsDeleteConfirmMessage =>
      'Esta acción no se puede deshacer.';

  @override
  String get myReviewsDeleteConfirmYes => 'Sí, eliminar';

  @override
  String get myReviewsDeleteConfirmNo => 'No';

  @override
  String get myReviewsUpdatedSuccess => 'Reseña actualizada correctamente.';

  @override
  String get myReviewsDeletedSuccess => 'Reseña eliminada correctamente.';

  @override
  String get myReviewsValidationRatingRequired =>
      'Selecciona una calificación.';

  @override
  String get myReviewsLoadFailed =>
      'No se pudieron cargar tus reseñas. Inténtalo de nuevo.';

  @override
  String get loadMoreButton => 'Cargar más';

  @override
  String get noMoreItems => 'No hay más elementos';

  @override
  String get chatbotTabLabel => 'Asistente';

  @override
  String get chatbotTitle => 'Asistente Wasla';

  @override
  String get chatbotHint => 'Pregunta sobre empresas, ofertas y servicios...';

  @override
  String get chatbotNewConversation => 'Nueva conversación';

  @override
  String get chatbotWelcomeMessage =>
      '¡Hola! Soy tu asistente de IA de Wasla. ¿Cómo puedo ayudarte hoy?';

  @override
  String get chatbotRestrictedTitle => 'Asistente de IA';

  @override
  String get chatbotRestrictedMessage =>
      'Inicia sesión para chatear con nuestro asistente de IA y recibir ayuda personalizada.';

  @override
  String get chatbotNewChat => 'Nuevo chat';

  @override
  String get chatbotHistoryTitle => 'Historial de chat';

  @override
  String get chatbotNoHistory => 'No hay chats anteriores';

  @override
  String get chatbotDeleteChat => '¿Eliminar chat?';

  @override
  String get chatbotDeleteConfirm => 'Esto no se puede deshacer.';

  @override
  String get chatbotDeleteQuestion =>
      '¿Seguro que quieres eliminar esta conversación?';

  @override
  String get chatbotDeleteYes => 'Sí, eliminar';

  @override
  String get chatbotDeleteNo => 'No';

  @override
  String get companyReviewsSubmitting => 'Tu reseña está en revisión';

  @override
  String get offerTotalLabel => 'Importe total';

  @override
  String get currencyEgp => 'EGP';

  @override
  String get vatIncluded => 'IVA incluida';

  @override
  String get insuranceCovered => 'Seguro incluido';

  @override
  String get offerSavingsLabel => 'Ahorras';

  @override
  String get locationsTitle => 'Ubicaciones';

  @override
  String get servicesTitle => 'Servicios';

  @override
  String get insuranceTitle => 'Seguro';

  @override
  String get includedInPriceTitle => 'Incluido en el precio';

  @override
  String get attachmentTitle => 'Adjunto';

  @override
  String get pdfAttachment => 'Documento PDF';

  @override
  String get downloadAttachment => 'Descargar';

  @override
  String get acceptOffer => 'Aceptar oferta';

  @override
  String get rejectOffer => 'Rechazar oferta';

  @override
  String get reviewFullAgreement => 'Revisar acuerdo completo';

  @override
  String get buildingTypeLabel => 'Edificio';

  @override
  String get floorLabel => 'Piso';

  @override
  String get elevatorLabel => 'Ascensor';

  @override
  String get availableLabel => 'Disponible';

  @override
  String get notAvailableLabel => 'No disponible';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get unknownService => 'Servicio';

  @override
  String get additionalCostsLabel => 'Costes adicionales';

  @override
  String get cleaningTypeLabel => 'Tipo de limpieza';

  @override
  String get durationHoursLabel => 'Duración (horas)';

  @override
  String get numberOfStaffLabel => 'Número de personal';

  @override
  String get fillNailHolesLabel => 'Rellenar agujeros de clavos';

  @override
  String get highPressureCleanerLabel => 'Limpiador de alta presión';

  @override
  String get cleaningDateLabel => 'Fecha de limpieza';

  @override
  String get cleaningStartTimeLabel => 'Hora de inicio';

  @override
  String get deliveryDateLabel => 'Fecha de entrega';

  @override
  String get deliveryTimeLabel => 'Hora de entrega';

  @override
  String get discountLabel => 'Descuento';

  @override
  String get offerNotFound => 'Oferta no encontrada.';

  @override
  String get offerAccessDenied => 'No tienes acceso a esta oferta.';

  @override
  String get offerLoadFailed =>
      'No se pudieron cargar los detalles de la oferta. Inténtalo de nuevo.';

  @override
  String get offerDetailsRetry => 'Reintentar';

  @override
  String get downloadSuccess => 'Archivo descargado correctamente.';

  @override
  String get downloadFailed =>
      'No se pudo descargar el archivo. Inténtalo de nuevo.';

  @override
  String get acceptOfferTitle => 'Aceptar oferta';

  @override
  String get acceptOfferReviewHeader =>
      'Revisar y confirmar aceptación de oferta';

  @override
  String get acceptOfferSignatureHint => 'Introduce tu firma digital (SIG-...)';

  @override
  String get acceptOfferSignatureRequired => 'La firma digital es obligatoria';

  @override
  String get acceptOfferSignatureInvalidPrefix =>
      'La firma debe empezar por SIG-';

  @override
  String get acceptOfferConfirmationText =>
      'Confirmo que he revisado y acepto los términos de esta oferta.';

  @override
  String get acceptOfferConfirmationRequired =>
      'Debes confirmar antes de aceptar';

  @override
  String get acceptOfferPaymentRequired => 'Selecciona un método de pago';

  @override
  String get cashOnDelivery => 'Pago contra entrega';

  @override
  String get onlinePayment => 'Pago en línea';

  @override
  String get acceptOfferSubmit => 'Aceptar oferta';

  @override
  String get acceptOfferCancel => 'Cancelar';

  @override
  String get acceptOfferSuccessCod => '¡Oferta aceptada correctamente!';

  @override
  String get acceptOfferSuccessOnline => 'Redirigiendo al pago...';

  @override
  String get acceptOfferCheckoutError =>
      'No se pudo abrir la página de pago. Inténtalo de nuevo.';

  @override
  String get acceptOfferTerminalState => 'Esta oferta ya no se puede aceptar.';

  @override
  String get acceptOfferForbidden =>
      'No tienes permiso para aceptar esta oferta.';

  @override
  String get acceptOfferPaymentConfigMissing =>
      'El pago en línea no está disponible. Contacta con soporte.';

  @override
  String get acceptOfferFailed =>
      'No se pudo aceptar la oferta. Inténtalo de nuevo.';

  @override
  String get rejectOfferTitle => 'Rechazar oferta';

  @override
  String get rejectOfferWarningHeader =>
      '¿Seguro que quieres rechazar esta oferta?';

  @override
  String get rejectOfferWarningText =>
      'Esta acción no se puede deshacer. La empresa será notificada de tu decisión.';

  @override
  String get rejectOfferReasonHint => 'Explica por qué rechazas esta oferta...';

  @override
  String get rejectOfferReasonRequired =>
      'El motivo del rechazo es obligatorio';

  @override
  String get rejectOfferReasonTooLong =>
      'El motivo debe tener 2.000 caracteres o menos';

  @override
  String get rejectOfferSubmit => 'Rechazar oferta';

  @override
  String get rejectOfferCancel => 'Cancelar';

  @override
  String get rejectOfferSuccess => 'Oferta rechazada.';

  @override
  String get rejectOfferTerminalState => 'Esta oferta ya no se puede rechazar.';

  @override
  String get rejectOfferForbidden =>
      'No tienes permiso para rechazar esta oferta.';

  @override
  String get rejectOfferFailed =>
      'No se pudo rechazar la oferta. Inténtalo de nuevo.';

  @override
  String get offerSummaryCardTitle => 'Resumen de oferta';

  @override
  String get offerNumberLabel => 'Oferta #';

  @override
  String get companyLabel => 'Empresa';

  @override
  String get rejectionReasonLabel => 'MOTIVO DEL RECHAZO ';

  @override
  String get acceptOfferFinalizeTitle => 'Finalizar aceptación.';

  @override
  String acceptOfferFinalizeSubtitle(String providerName) {
    return 'Revisa cuidadosamente los detalles de la oferta de $providerName antes de aplicar tu firma digital para formalizar el acuerdo.';
  }

  @override
  String get acceptOfferDigitalSignatureLabel => 'FIRMA DIGITAL';

  @override
  String get acceptOfferSignatureHintPart1 =>
      'Consejo: puedes encontrar tu firma digital en ';

  @override
  String get acceptOfferSignatureHintPart2 => 'Configuración -> Firma digital';

  @override
  String get acceptOfferSignatureHintPart3 =>
      ' (requiere verificación de contraseña).';

  @override
  String get acceptOfferConfirmationTextLong =>
      'Confirmo que quiero aceptar esta oferta y firmar con mi firma digital. Entiendo que esta acción es legalmente vinculante.';

  @override
  String get acceptOfferSignAndAccept => 'Firmar y aceptar';

  @override
  String get entryReferenceLabel => 'REFERENCIA DE ENTRADA';

  @override
  String get statusLabel => 'ESTADO';

  @override
  String get providerIdentityLabel => 'IDENTIDAD DEL PROVEEDOR';

  @override
  String get valuationLabel => 'VALORACIÓN';

  @override
  String get offerReferenceLabel => 'REFERENCIA DE OFERTA';

  @override
  String get totalContractValueLabel => 'VALOR TOTAL DEL CONTRATO';

  @override
  String get serviceHeader => 'SERVICIO';

  @override
  String get costHeader => 'COSTE';

  @override
  String get chatbotSuggestionHelp => '¿En qué puedes ayudarme?';

  @override
  String get chatbotSuggestionExploreServices => 'Explorar servicios';

  @override
  String get chatbotSuggestionViewOffers => 'Ver mis ofertas';

  @override
  String get chatbotSuggestionFindCompany => 'Encontrar una empresa adecuada';

  @override
  String get chatbotSuggestionCreateRequest =>
      'Crear una solicitud de servicio';

  @override
  String get chatbotSuggestionTrackStatus => 'Seguir estado de solicitud';
}
