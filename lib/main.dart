import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/app.router.dart';
import 'di/manual_locator.dart';
import 'localization/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupDependencies(); // Use manual DI setup

  final navigatorKey = locator<NavigationService>().navigatorKey;
  setupSnackbarUI(navigatorKey!);

  runApp(const MyApp());
}

void setupSnackbarUI(GlobalKey<NavigatorState> navigatorKey) {
  final service = locator<SnackbarService>();
  service.registerSnackbarConfig(
    SnackbarConfig(
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      mainButtonTextColor: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posts App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      supportedLocales: const [Locale('en', ''), Locale('es', '')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (final supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
    );
  }
}
