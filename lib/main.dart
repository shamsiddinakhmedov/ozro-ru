import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ozro_mobile/src/core/bloc_observer/log_bloc_observer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'src/app.dart';
import 'src/app_options.dart';
import 'src/config/router/app_routes.dart';
import 'src/core/services/notification_service.dart';
import 'src/injector_container.dart';
import 'src/presentation/bloc/main/main/main_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await NotificationService.initialize();
  } on Exception catch (e) {
    log('NotificationService initialize error: $e');
  }

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await Permission.storage.isDenied.then((value) {
    if (value) {
      Permission.storage.request();
    }
  });

  /// bloc logger
  if (kDebugMode) {
    Bloc.observer = LogBlocObserver();
  }
  await init();

  /// global CERTIFICATE_VERIFY_FAILEd_KEY
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    ModelBinding(
      initialModel: AppOptions(
        themeMode: localSource.themeMode,
        locale: Locale(localSource.locale),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<MainBloc>(
            create: (_) => sl<MainBloc>(),
          ),
        ],
        child: const MainApp(),
      ),
    ),
  );
  FlutterNativeSplash.remove();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) =>
      super.createHttpClient(context)
        ..badCertificateCallback = (cert, host, port) => true;
}

/// flutter pub run flutter_launcher_icons:main
/// flutter run -d windows
/// flutter build apk --release
/// flutter build apk --split-per-abi
/// flutter build appbundle --release
/// flutter pub run build_runner watch --delete-conflicting-outputs
/// flutter pub ipa
