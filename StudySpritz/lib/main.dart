import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:ui';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:studyspritz/l10n/app_localizations.dart';

import 'core/state/settings_state.dart';
import 'core/services/hive_service.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();
  
  await HiveService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final state = SettingsState();
        state.load();
        return state;
      },
      child: const _AppView(),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SettingsState>();

    return AnimatedTheme(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
      data: _mapThemeData(state.settings?.themeMode),

      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            routerConfig: AppRouter.router,

            themeMode: _mapTheme(state.settings?.themeMode),

            theme: ThemeData.light(),

            darkTheme: ThemeData.dark(),

            locale: Locale(
              state.settings?.language ?? "en",
            ),

            supportedLocales: AppLocalizations.supportedLocales,

            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }

  ThemeMode _mapTheme(String? mode) {
    switch (mode) {
      case "dark":
        return ThemeMode.dark;

      case "light":
        return ThemeMode.light;

      default:
        return ThemeMode.system;
    }
  }

  ThemeData _mapThemeData(String? mode) {
    switch (mode) {
      case "dark":
        return ThemeData.dark();

      case "light":
        return ThemeData.light();

      default:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark
            ? ThemeData.dark()
            : ThemeData.light();
    }
  }
}