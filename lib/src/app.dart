import 'package:flutter/material.dart';

import 'config/router/app_routes.dart';
import 'core/extension/extension.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        /// title
    debugShowCheckedModeBanner: false,
    scaffoldMessengerKey: scaffoldMessengerKey,
    /// theme style
    theme: lightTheme,
    darkTheme: darkTheme,
    themeMode: ThemeMode.light,
    // context.options.themeMode,
    /// lang
    // locale: context.options.locale,
    // supportedLocales: AppLocalizations.supportedLocales,
    // localizationsDelegates: AppLocalizations.localizationsDelegates,
    /// pages
    routerDelegate: router.routerDelegate,
    routeInformationParser: router.routeInformationParser,
    routeInformationProvider: router.routeInformationProvider,
  );
}
