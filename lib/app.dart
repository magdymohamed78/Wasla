import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/localization/l10n/AppLocalizations.dart';
import 'core/localization/locale_repository_impl.dart';
import 'core/localization/locale_cubit/locale_cubit.dart';
import 'core/localization/locale_cubit/locale_state.dart';
import 'features/auth/data/data_sources/auth_remote_data_source.dart';
import 'features/auth/data/data_sources/auth_local_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/use_cases/login_use_case.dart';
import 'features/auth/presentation/cubit/login_cubit.dart';

class App extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  const App({
    super.key,
    required this.sharedPreferences,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router;
  late final LocaleCubit _localeCubit;
  late final Dio _dio;
  late final AuthRemoteDataSource _authRemoteDataSource;
  late final AuthLocalDataSource _authLocalDataSource;
  late final AuthRepository _authRepository;
  late final LoginUseCase _loginUseCase;
  late final LoginCubit _loginCubit;

  @override
  void initState() {
    super.initState();
    _localeCubit = LocaleCubit(
      LocaleRepositoryImpl(widget.sharedPreferences),
    )..init();

    _dio = Dio(BaseOptions(
      baseUrl: 'http://waslacrm.runasp.net/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));
    _authRemoteDataSource = AuthRemoteDataSourceImpl(_dio);
    _authLocalDataSource = AuthLocalDataSourceImpl(
      sharedPreferences: widget.sharedPreferences,
    );
    _authRepository = AuthRepositoryImpl(
      remoteDataSource: _authRemoteDataSource,
      localDataSource: _authLocalDataSource,
    );
    _loginUseCase = LoginUseCase(_authRepository);
    _loginCubit = LoginCubit(
      loginUseCase: _loginUseCase,
      authRepository: _authRepository,
    );
    _router = AppRouter.router(_authRepository);
  }

  @override
  void dispose() {
    _localeCubit.close();
    _loginCubit.close();
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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LocaleCubit>.value(value: _localeCubit),
          BlocProvider<LoginCubit>.value(value: _loginCubit),
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
