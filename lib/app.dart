import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/localization/l10n/AppLocalizations.dart';
import 'core/localization/locale_repository_impl.dart';
import 'core/localization/locale_cubit/locale_cubit.dart';
import 'core/localization/locale_cubit/locale_state.dart';

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

  @override
  void initState() {
    super.initState();
    _router = AppRouter.router();
    _localeCubit = LocaleCubit(
      LocaleRepositoryImpl(widget.sharedPreferences),
    )..init();
  }

  @override
  void dispose() {
    _localeCubit.close();
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
      child: BlocProvider<LocaleCubit>.value(
        value: _localeCubit,
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
