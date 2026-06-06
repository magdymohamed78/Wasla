import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/localization/l10n/AppLocalizations.dart';
import 'core/localization/locale_cubit/locale_cubit.dart';
import 'core/localization/locale_cubit/locale_state.dart';
import 'core/localization/locale_repository_impl.dart';
import 'core/networking/auth_interceptor.dart';
import 'core/networking/chatbot_auth_interceptor.dart';
import 'core/routing/app_router.dart';
import 'core/session/pending_intent_store.dart';
import 'core/session/role_resolver.dart';
import 'core/session/session_cubit.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/data_sources/auth_local_data_source.dart';
import 'features/auth/data/data_sources/auth_remote_data_source.dart';
import 'features/auth/data/data_sources/in_memory_auth_local_data_source.dart';
import 'features/auth/data/data_sources/secure_auth_local_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/use_cases/change_password_use_case.dart';
import 'features/auth/domain/use_cases/login_use_case.dart';
import 'features/auth/domain/use_cases/register_use_case.dart';
import 'features/auth/presentation/cubit/login_cubit.dart';
import 'features/auth/presentation/cubit/register_cubit.dart';
import 'features/home/data/data_sources/customer_portal_remote_data_source.dart';
import 'features/home/data/data_sources/discovery_remote_data_source.dart';
import 'features/home/data/data_sources/service_request_remote_data_source.dart';
import 'features/home/data/repositories/customer_portal_repository_impl.dart';
import 'features/home/data/repositories/discovery_repository_impl.dart';
import 'features/home/data/repositories/service_request_repository_impl.dart';
import 'features/home/domain/repositories/customer_offers_repository.dart';
import 'features/offers/data/data_sources/offers_remote_data_source.dart';
import 'features/offers/data/repositories/offers_repository_impl.dart';
import 'features/offers/domain/repositories/offers_repository.dart';
import 'features/offers/domain/use_cases/get_offer_details_use_case.dart';
import 'features/offers/domain/use_cases/accept_offer_use_case.dart';
import 'features/offers/domain/use_cases/reject_offer_use_case.dart';
import 'features/home/domain/repositories/customer_portal_repository.dart';
import 'features/home/domain/repositories/customer_reviews_repository.dart';
import 'features/home/domain/repositories/customer_requests_repository.dart';
import 'features/home/domain/repositories/digital_signature_repository.dart';
import 'features/home/domain/repositories/discovery_repository.dart';
import 'features/home/domain/repositories/logout_repository.dart';
import 'features/home/domain/repositories/profile_repository.dart';
import 'features/home/domain/repositories/service_request_repository.dart';
import 'features/home/domain/use_cases/customer_portal_use_cases.dart';
import 'features/home/domain/use_cases/discovery_use_cases.dart';
import 'features/home/domain/use_cases/logout_all_use_case.dart';
import 'features/home/domain/use_cases/logout_use_case.dart';
import 'features/home/domain/use_cases/reveal_signature_use_case.dart';
import 'features/home/domain/use_cases/role_guard_use_cases.dart';
import 'features/home/domain/use_cases/service_request_use_cases.dart';
import 'features/chatbot/data/data_sources/chatbot_remote_data_source.dart';
import 'features/chatbot/data/data_sources/chat_history_local_data_source.dart';
import 'features/chatbot/data/repositories/chatbot_repository_impl.dart';
import 'features/chatbot/domain/repositories/chatbot_repository.dart';
import 'features/chatbot/domain/use_cases/send_message_use_case.dart';
import 'features/splash/presentation/cubit/splash_cubit.dart';

class App extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  const App({super.key, required this.sharedPreferences});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router;

  // ── Core ──────────────────────────────────────────────────────
  late final LocaleCubit _localeCubit;
  late final LocaleRepositoryImpl _localeRepository;
  late final Dio _dio;
  late final AuthInterceptor _authInterceptor;
  late final RoleResolver _roleResolver;
  late final PendingIntentStore _pendingIntentStore;
  late final SessionCubit _sessionCubit;
  late final SplashCubit _splashCubit;

  // ── Auth ──────────────────────────────────────────────────────
  late final AuthRemoteDataSource _authRemoteDataSource;
  late final FlutterSecureStorage _secureStorage;
  late final AuthLocalDataSource _secureAuthLocalDataSource;
  late final AuthLocalDataSource _inMemoryAuthLocalDataSource;
  late final AuthRepository _authRepository;
  late final LoginUseCase _loginUseCase;
  late final RegisterUseCase _registerUseCase;
  late final ChangePasswordUseCase _changePasswordUseCase;
  late final LoginCubit _loginCubit;
  late final RegisterCubit _registerCubit;

  // ── Home / Navigation ─────────────────────────────────────────
  late final RoleGuardUseCases _roleGuardUseCases;

  // ── Companies / Discovery ─────────────────────────────────────
  late final DiscoveryRemoteDataSource _discoveryRemoteDataSource;
  late final DiscoveryRepository _discoveryRepository;
  late final GetAllCompaniesUseCase _getAllCompaniesUseCase;
  late final GetRecommendedCompaniesUseCase _getRecommendedCompaniesUseCase;
  late final GetTrendingCompaniesUseCase _getTrendingCompaniesUseCase;
  late final GetCompanyDetailsUseCase _getCompanyDetailsUseCase;
  late final GetCompanyReviewsUseCase _getCompanyReviewsUseCase;

  // ── Profile ───────────────────────────────────────────────────
  late final CustomerPortalRemoteDataSource _customerPortalRemoteDataSource;
  late final CustomerPortalRepository _customerPortalRepository;
  late final GetCustomerProfileUseCase _getCustomerProfileUseCase;
  late final RefreshCustomerSessionUseCase _refreshCustomerSessionUseCase;
  late final GetLeadProfileUseCase _getLeadProfileUseCase;
  late final UpdateCustomerProfileUseCase _updateCustomerProfileUseCase;
  late final UpdateLeadProfileUseCase _updateLeadProfileUseCase;

  // ── Requests ──────────────────────────────────────────────────
  late final GetCustomerServiceRequestsUseCase
  _getCustomerServiceRequestsUseCase;
  late final GetCustomerServiceRequestDetailsUseCase
  _getCustomerServiceRequestDetailsUseCase;
  late final ServiceRequestRemoteDataSource _serviceRequestRemoteDataSource;
  late final ServiceRequestRepository _serviceRequestRepository;
  late final SubmitServiceRequestUseCase _submitServiceRequestUseCase;

  // ── Offers ────────────────────────────────────────────────────
  late final GetCustomerOffersUseCase _getCustomerOffersUseCase;
  late final OffersRemoteDataSource _offersRemoteDataSource;
  late final OffersRepository _offersRepository;
  late final GetOfferDetailsUseCase _getOfferDetailsUseCase;
  late final AcceptOfferUseCase _acceptOfferUseCase;
  late final RejectOfferUseCase _rejectOfferUseCase;

  // ── Settings / Signature / Logout ─────────────────────────────
  late final RevealDigitalSignatureUseCase _revealDigitalSignatureUseCase;
  late final LogoutUseCase _logoutUseCase;
  late final LogoutAllUseCase _logoutAllUseCase;

  // ── Chatbot ─────────────────────────────────────────────────────
  late final Dio _chatbotDio;
  late final ChatbotAuthInterceptor _chatbotAuthInterceptor =
      ChatbotAuthInterceptor();
  late final ChatbotRemoteDataSource _chatbotRemoteDataSource;
  late final ChatHistoryLocalDataSource _chatbotHistoryLocalDataSource;
  late final ChatbotRepository _chatbotRepository;
  late final SendMessageUseCase _sendMessageUseCase;

  @override
  void initState() {
    super.initState();

    // ── Core ────────────────────────────────────────────────────
    _localeRepository = LocaleRepositoryImpl(widget.sharedPreferences);
    _localeCubit = LocaleCubit(_localeRepository)..init();

    const baseUrl = 'http://waslacrm.runasp.net/';
    _authInterceptor = AuthInterceptor(baseUrl: baseUrl);
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    _dio.interceptors.add(_authInterceptor);

    _roleResolver = const RoleResolver();
    _pendingIntentStore = SharedPrefsPendingIntentStore(
      widget.sharedPreferences,
    );
    _splashCubit = SplashCubit();

    // ── Auth ────────────────────────────────────────────────────
    _authRemoteDataSource = AuthRemoteDataSourceImpl(_dio);
    _secureStorage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
        resetOnError: true,
      ),
    );
    _secureAuthLocalDataSource = SecureAuthLocalDataSource(
      storage: _secureStorage,
    );
    _inMemoryAuthLocalDataSource = InMemoryAuthLocalDataSource();
    _authRepository = AuthRepositoryImpl(
      remoteDataSource: _authRemoteDataSource,
      secureLocalDataSource: _secureAuthLocalDataSource,
      inMemoryLocalDataSource: _inMemoryAuthLocalDataSource,
    );
    _authInterceptor.setAuthRepository(_authRepository);
    _chatbotAuthInterceptor.setAuthRepository(_authRepository);

    _sessionCubit = SessionCubit(
      authRepository: _authRepository,
      pendingIntentStore: _pendingIntentStore,
      roleResolver: _roleResolver,
    )..initialize();

    _loginUseCase = LoginUseCase(_authRepository);
    _registerUseCase = RegisterUseCase(_authRepository);
    _changePasswordUseCase = ChangePasswordUseCase(_authRepository);
    _loginCubit = LoginCubit(
      loginUseCase: _loginUseCase,
      authRepository: _authRepository,
      sessionCubit: _sessionCubit,
    );
    _registerCubit = RegisterCubit(
      registerUseCase: _registerUseCase,
      authRepository: _authRepository,
    );

    // ── Home / Navigation ───────────────────────────────────────
    _roleGuardUseCases = const RoleGuardUseCases();

    // ── Companies / Discovery ───────────────────────────────────
    _discoveryRemoteDataSource = DiscoveryRemoteDataSourceImpl(_dio);
    _discoveryRepository = DiscoveryRepositoryImpl(
      remote: _discoveryRemoteDataSource,
    );
    _getAllCompaniesUseCase = GetAllCompaniesUseCase(_discoveryRepository);
    _getRecommendedCompaniesUseCase = GetRecommendedCompaniesUseCase(
      _discoveryRepository,
    );
    _getTrendingCompaniesUseCase = GetTrendingCompaniesUseCase(
      _discoveryRepository,
    );
    _getCompanyDetailsUseCase = GetCompanyDetailsUseCase(_discoveryRepository);
    _getCompanyReviewsUseCase = GetCompanyReviewsUseCase(_discoveryRepository);

    // ── Portal (Profile + Requests + Offers + Signature + Logout) ──
    _customerPortalRemoteDataSource = CustomerPortalRemoteDataSourceImpl(_dio);
    _customerPortalRepository = CustomerPortalRepositoryImpl(
      remote: _customerPortalRemoteDataSource,
    );

    _getCustomerProfileUseCase = GetCustomerProfileUseCase(
      _customerPortalRepository,
    );
    _refreshCustomerSessionUseCase = RefreshCustomerSessionUseCase(
      repository: _customerPortalRepository,
      authRepository: _authRepository,
      roleResolver: _roleResolver,
    );
    _getLeadProfileUseCase = GetLeadProfileUseCase(_customerPortalRepository);
    _updateCustomerProfileUseCase = UpdateCustomerProfileUseCase(
      _customerPortalRepository,
    );
    _updateLeadProfileUseCase = UpdateLeadProfileUseCase(
      _customerPortalRepository,
    );

    _getCustomerServiceRequestsUseCase = GetCustomerServiceRequestsUseCase(
      _customerPortalRepository,
    );
    _getCustomerServiceRequestDetailsUseCase =
        GetCustomerServiceRequestDetailsUseCase(_customerPortalRepository);
    _getCustomerOffersUseCase = GetCustomerOffersUseCase(
      _customerPortalRepository,
    );

    // ── Offer Details / Accept / Reject ─────────────────────────
    _offersRemoteDataSource = OffersRemoteDataSource(_dio);
    _offersRepository = OffersRepositoryImpl(remote: _offersRemoteDataSource);
    _getOfferDetailsUseCase = GetOfferDetailsUseCase(_offersRepository);
    _acceptOfferUseCase = AcceptOfferUseCase(_offersRepository);
    _rejectOfferUseCase = RejectOfferUseCase(_offersRepository);

    _revealDigitalSignatureUseCase = RevealDigitalSignatureUseCase(
      _customerPortalRepository,
    );
    _logoutUseCase = LogoutUseCase(_customerPortalRepository);
    _logoutAllUseCase = LogoutAllUseCase(_customerPortalRepository);

    // ── Service Requests ────────────────────────────────────────
    _serviceRequestRemoteDataSource = ServiceRequestRemoteDataSourceImpl(_dio);
    _serviceRequestRepository = ServiceRequestRepositoryImpl(
      remote: _serviceRequestRemoteDataSource,
    );
    _submitServiceRequestUseCase = SubmitServiceRequestUseCase(
      _serviceRequestRepository,
    );

    // ── Chatbot ────────────────────────────────────────────────────
    _chatbotDio = Dio(
      BaseOptions(
        baseUrl: 'https://mohameddda-wasla-ai-agent.hf.space/',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    _chatbotDio.interceptors.add(_chatbotAuthInterceptor);
    _chatbotRemoteDataSource = ChatbotRemoteDataSourceImpl(_chatbotDio);
    _chatbotHistoryLocalDataSource = ChatHistoryLocalDataSourceImpl(
      sharedPreferences: widget.sharedPreferences,
      customerIdProvider: () {
        final user = _sessionCubit.state.user;
        final tokenCustomerId = _roleResolver.customerIdFromToken(user?.token);
        if (tokenCustomerId != null) {
          return 'customer_$tokenCustomerId';
        }
        return 'guest';
      },
    );
    _chatbotRepository = ChatbotRepositoryImpl(
      remote: _chatbotRemoteDataSource,
      historyLocal: _chatbotHistoryLocalDataSource,
      sharedPreferences: widget.sharedPreferences,
      customerIdProvider: () {
        final user = _sessionCubit.state.user;
        final tokenCustomerId = _roleResolver.customerIdFromToken(user?.token);
        if (tokenCustomerId != null) {
          return 'customer_$tokenCustomerId';
        }
        return 'guest';
      },
    );
    _sendMessageUseCase = SendMessageUseCase(_chatbotRepository);

    // ── Routing ─────────────────────────────────────────────────
    _router = AppRouter.router(_authRepository, roleResolver: _roleResolver);
  }

  @override
  void dispose() {
    _localeCubit.close();
    _loginCubit.close();
    _registerCubit.close();
    _splashCubit.close();
    _sessionCubit.close();
    _dio.close();
    _chatbotDio.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // ── Core ────────────────────────────────────────────────
        RepositoryProvider<LocaleRepositoryImpl>.value(
          value: _localeRepository,
        ),
        RepositoryProvider<RoleResolver>.value(value: _roleResolver),
        RepositoryProvider<PendingIntentStore>.value(
          value: _pendingIntentStore,
        ),
        RepositoryProvider<RoleGuardUseCases>.value(value: _roleGuardUseCases),

        // ── Auth ────────────────────────────────────────────────
        RepositoryProvider<AuthRepository>.value(value: _authRepository),
        RepositoryProvider<LoginUseCase>.value(value: _loginUseCase),
        RepositoryProvider<RegisterUseCase>.value(value: _registerUseCase),
        RepositoryProvider<ChangePasswordUseCase>.value(
          value: _changePasswordUseCase,
        ),

        // ── Companies / Discovery ───────────────────────────────
        RepositoryProvider<DiscoveryRepository>.value(
          value: _discoveryRepository,
        ),
        RepositoryProvider<GetAllCompaniesUseCase>.value(
          value: _getAllCompaniesUseCase,
        ),
        RepositoryProvider<GetRecommendedCompaniesUseCase>.value(
          value: _getRecommendedCompaniesUseCase,
        ),
        RepositoryProvider<GetTrendingCompaniesUseCase>.value(
          value: _getTrendingCompaniesUseCase,
        ),
        RepositoryProvider<GetCompanyDetailsUseCase>.value(
          value: _getCompanyDetailsUseCase,
        ),
        RepositoryProvider<GetCompanyReviewsUseCase>.value(
          value: _getCompanyReviewsUseCase,
        ),

        // ── Portal Composite + Sub-interfaces ───────────────────
        RepositoryProvider<CustomerPortalRepository>.value(
          value: _customerPortalRepository,
        ),
        RepositoryProvider<ProfileRepository>.value(
          value: _customerPortalRepository,
        ),
        RepositoryProvider<CustomerRequestsRepository>.value(
          value: _customerPortalRepository,
        ),
        RepositoryProvider<CustomerOffersRepository>.value(
          value: _customerPortalRepository,
        ),
        // Shared by dashboard metrics and My Reviews management features.
        RepositoryProvider<CustomerReviewsRepository>.value(
          value: _customerPortalRepository,
        ),
        RepositoryProvider<DigitalSignatureRepository>.value(
          value: _customerPortalRepository,
        ),
        RepositoryProvider<LogoutRepository>.value(
          value: _customerPortalRepository,
        ),

        // ── Profile ─────────────────────────────────────────────
        RepositoryProvider<GetCustomerProfileUseCase>.value(
          value: _getCustomerProfileUseCase,
        ),
        RepositoryProvider<RefreshCustomerSessionUseCase>.value(
          value: _refreshCustomerSessionUseCase,
        ),
        RepositoryProvider<GetLeadProfileUseCase>.value(
          value: _getLeadProfileUseCase,
        ),
        RepositoryProvider<UpdateCustomerProfileUseCase>.value(
          value: _updateCustomerProfileUseCase,
        ),
        RepositoryProvider<UpdateLeadProfileUseCase>.value(
          value: _updateLeadProfileUseCase,
        ),

        // ── Requests ────────────────────────────────────────────
        RepositoryProvider<ServiceRequestRepository>.value(
          value: _serviceRequestRepository,
        ),
        RepositoryProvider<SubmitServiceRequestUseCase>.value(
          value: _submitServiceRequestUseCase,
        ),
        RepositoryProvider<GetCustomerServiceRequestsUseCase>.value(
          value: _getCustomerServiceRequestsUseCase,
        ),
        RepositoryProvider<GetCustomerServiceRequestDetailsUseCase>.value(
          value: _getCustomerServiceRequestDetailsUseCase,
        ),

        // ── Offers ──────────────────────────────────────────────
        RepositoryProvider<GetCustomerOffersUseCase>.value(
          value: _getCustomerOffersUseCase,
        ),
        RepositoryProvider<OffersRepository>.value(
          value: _offersRepository,
        ),
        RepositoryProvider<GetOfferDetailsUseCase>.value(
          value: _getOfferDetailsUseCase,
        ),
        RepositoryProvider<AcceptOfferUseCase>.value(
          value: _acceptOfferUseCase,
        ),
        RepositoryProvider<RejectOfferUseCase>.value(
          value: _rejectOfferUseCase,
        ),

        // ── Settings / Signature / Logout ───────────────────────
        RepositoryProvider<RevealDigitalSignatureUseCase>.value(
          value: _revealDigitalSignatureUseCase,
        ),
        RepositoryProvider<LogoutUseCase>.value(value: _logoutUseCase),
        RepositoryProvider<LogoutAllUseCase>.value(value: _logoutAllUseCase),

        // ── Chatbot ──────────────────────────────────────────────
        RepositoryProvider<ChatbotRepository>.value(value: _chatbotRepository),
        RepositoryProvider<SendMessageUseCase>.value(
          value: _sendMessageUseCase,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // ── Core ────────────────────────────────────────────────
          BlocProvider<LocaleCubit>.value(value: _localeCubit),
          BlocProvider<SessionCubit>.value(value: _sessionCubit),
          BlocProvider<SplashCubit>.value(value: _splashCubit),

          // ── Auth ────────────────────────────────────────────────
          BlocProvider<LoginCubit>.value(value: _loginCubit),
          BlocProvider<RegisterCubit>.value(value: _registerCubit),
        ],
        child: BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, localeState) {
            return MaterialApp.router(
              title: 'Wasla',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              locale: localeState.locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: _router,
            );
          },
        ),
      ),
    );
  }
}
