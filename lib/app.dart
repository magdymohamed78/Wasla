import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/localization/l10n/AppLocalizations.dart';
import 'core/localization/locale_repository_impl.dart';
import 'core/localization/locale_cubit/locale_cubit.dart';
import 'core/localization/locale_cubit/locale_state.dart';
import 'core/networking/auth_interceptor.dart';
import 'features/auth/data/data_sources/auth_remote_data_source.dart';
import 'features/auth/data/data_sources/auth_local_data_source.dart';
import 'features/auth/data/data_sources/secure_auth_local_data_source.dart';
import 'features/auth/data/data_sources/in_memory_auth_local_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/use_cases/login_use_case.dart';
import 'features/auth/domain/use_cases/register_use_case.dart';
import 'features/auth/presentation/cubit/login_cubit.dart';
import 'features/auth/presentation/cubit/register_cubit.dart';
import 'features/home/data/data_sources/discovery_remote_data_source.dart';
import 'features/home/data/repositories/discovery_repository_impl.dart';
import 'features/home/domain/repositories/discovery_repository.dart';
import 'features/home/domain/use_cases/discovery_use_cases.dart';
import 'features/splash/presentation/cubit/splash_cubit.dart';

class App extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  const App({super.key, required this.sharedPreferences});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router;
  late final LocaleCubit _localeCubit;
  late final Dio _dio;
  late final AuthInterceptor _authInterceptor;
  late final AuthRemoteDataSource _authRemoteDataSource;
  late final FlutterSecureStorage _secureStorage;
  late final AuthLocalDataSource _secureAuthLocalDataSource;
  late final AuthLocalDataSource _inMemoryAuthLocalDataSource;
  late final AuthRepository _authRepository;
  late final LoginUseCase _loginUseCase;
  late final RegisterUseCase _registerUseCase;
  late final DiscoveryRemoteDataSource _discoveryRemoteDataSource;
  late final DiscoveryRepository _discoveryRepository;
  late final GetAllCompaniesUseCase _getAllCompaniesUseCase;
  late final GetRecommendedCompaniesUseCase _getRecommendedCompaniesUseCase;
  late final GetTrendingCompaniesUseCase _getTrendingCompaniesUseCase;
  late final GetCompanyDetailsUseCase _getCompanyDetailsUseCase;
  late final GetCompanyReviewsUseCase _getCompanyReviewsUseCase;
  late final LoginCubit _loginCubit;
  late final RegisterCubit _registerCubit;
  late final SplashCubit _splashCubit;

  @override
  void initState() {
    super.initState();
    _localeCubit = LocaleCubit(LocaleRepositoryImpl(widget.sharedPreferences))
      ..init();

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

    _authRemoteDataSource = AuthRemoteDataSourceImpl(_dio);
    _secureStorage = const FlutterSecureStorage();
    _secureAuthLocalDataSource = SecureAuthLocalDataSource(
      storage: _secureStorage,
    );
    _inMemoryAuthLocalDataSource = InMemoryAuthLocalDataSource();
    _authRepository = AuthRepositoryImpl(
      remoteDataSource: _authRemoteDataSource,
      secureLocalDataSource: _secureAuthLocalDataSource,
      inMemoryLocalDataSource: _inMemoryAuthLocalDataSource,
    );

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

    _authInterceptor.setAuthRepository(_authRepository);

    _loginUseCase = LoginUseCase(_authRepository);
    _registerUseCase = RegisterUseCase(_authRepository);
    _loginCubit = LoginCubit(
      loginUseCase: _loginUseCase,
      authRepository: _authRepository,
    );
    _registerCubit = RegisterCubit(
      registerUseCase: _registerUseCase,
      authRepository: _authRepository,
    );
    _splashCubit = SplashCubit();
    _router = AppRouter.router(_authRepository);
  }

  @override
  void dispose() {
    _localeCubit.close();
    _loginCubit.close();
    _registerCubit.close();
    _splashCubit.close();
    _dio.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<LocaleRepositoryImpl>(
          create: (_) => LocaleRepositoryImpl(widget.sharedPreferences),
        ),
        RepositoryProvider<AuthRepository>.value(value: _authRepository),
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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LocaleCubit>.value(value: _localeCubit),
          BlocProvider<LoginCubit>.value(value: _loginCubit),
          BlocProvider<RegisterCubit>.value(value: _registerCubit),
          BlocProvider<SplashCubit>.value(value: _splashCubit),
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
