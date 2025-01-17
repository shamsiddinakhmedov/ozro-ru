import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:ozro_mobile/src/presentation/components/keyboard/keyboard_dismiss.dart';

import 'presentation/components/cupertino_back/cupertino_back_gesture.dart';

class AppOptions extends Equatable {
  const AppOptions({
    required this.themeMode,
    required this.locale,
  });

  final ThemeMode themeMode;
  final Locale locale;

  /// Returns a [SystemUiOverlayStyle] based on the [ThemeMode] setting.
  /// In other words, if the theme is dark, returns light; if the theme is
  /// light, returns dark.
  SystemUiOverlayStyle resolvedSystemUiOverlayStyle() {
    Brightness brightness;
    switch (themeMode) {
      case ThemeMode.light:
        brightness = Brightness.light;
      case ThemeMode.dark:
        brightness = Brightness.dark;
      default:
        brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    }

    final overlayStyle = brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;

    return overlayStyle;
  }

  AppOptions copyWith({
    ThemeMode? themeMode,
    double? textScaleFactor,
    Locale? locale,
    double? timeDilation,
    TargetPlatform? platform,
  }) =>
      AppOptions(
        themeMode: themeMode ?? this.themeMode,
        locale: locale ?? this.locale,
      );

  static AppOptions of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ModelBindingScope>()!;
    return scope.modelBindingState.currentModel;
  }

  static void update(BuildContext context, AppOptions newModel) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ModelBindingScope>()!;
    scope.modelBindingState.updateModel(newModel);
  }

  @override
  List<Object?> get props => [themeMode, locale];
}

class _ModelBindingScope extends InheritedWidget {
  const _ModelBindingScope({
    required this.modelBindingState,
    required super.child,
  });

  final _ModelBindingState modelBindingState;

  @override
  bool updateShouldNotify(_ModelBindingScope oldWidget) => true;
}

class ModelBinding extends StatefulWidget {
  const ModelBinding({
    super.key,
    required this.initialModel,
    required this.child,
  });

  final AppOptions initialModel;
  final Widget child;

  @override
  State<ModelBinding> createState() => _ModelBindingState();
}

class _ModelBindingState extends State<ModelBinding> {
  late AppOptions currentModel;

  @override
  void initState() {
    super.initState();
    currentModel = widget.initialModel;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateModel(AppOptions newModel) {
    if (newModel != currentModel) {
      setState(() {
        currentModel = newModel;
      });
    }
  }

  @override
  Widget build(BuildContext context) => KeyboardDismiss(
        child: BackGestureWidthTheme(
          backGestureWidth: BackGestureWidth.fraction(1 / 9),
          child: _ModelBindingScope(
            modelBindingState: this,
            child: widget.child,
          ),
        ),
      );
}
