part of 'extension.dart';

extension BuildContextExt on BuildContext {
  Locale get locale => Localizations.localeOf(this);

  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  ThemeColors get color => Theme.of(this).extension<ThemeColors>()!;

  ThemeTextStyles get textStyle => Theme.of(this).extension<ThemeTextStyles>()!;

  String tr(
    String key, {
    Map<String, String>? namedArgs,
  }) =>
      AppLocalizations.of(this).translate(key, namedArgs: namedArgs);

  AppOptions get options => AppOptions.of(this);

  void setLocale(Locale locale) {
    AppOptions.update(
      this,
      AppOptions.of(this).copyWith(locale: locale),
    );
    localSource.setLocale(locale.languageCode);
  }

  String get currentRouteName {
    final GoRouter myRouter = GoRouter.of(rootNavigatorKey.currentContext!);
    final RouteMatch lastMatch = myRouter.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList =
    lastMatch is ImperativeRouteMatch ? lastMatch.matches : myRouter.routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();
    return location;
  }

  void setThemeMode(ThemeMode themeMode) {
    AppOptions.update(
      this,
      AppOptions.of(this).copyWith(themeMode: themeMode),
    );
  }
}

extension LocalizationExtension on String {
  String tr({
    BuildContext? context,
    Map<String, String>? namedArgs,
  }) =>
      context == null
          ? AppLocalizations.instance.translate(this, namedArgs: namedArgs)
          : AppLocalizations.of(context).translate(this, namedArgs: namedArgs);
}
