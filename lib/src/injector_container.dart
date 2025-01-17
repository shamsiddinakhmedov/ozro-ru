import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_retry_plus/dio_retry_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/constants/app_keys.dart';
import 'package:ozro_mobile/src/core/constants/constants.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/source/local_source.dart';
import 'package:ozro_mobile/src/domain/repositories/auth/auth_repository.dart';
import 'package:ozro_mobile/src/domain/repositories/main/main_repository.dart';
import 'package:ozro_mobile/src/presentation/bloc/auth/auth_bloc/auth_bloc.dart';
import 'package:ozro_mobile/src/presentation/bloc/auth/confirm/confirm_code_bloc.dart';
import 'package:ozro_mobile/src/presentation/bloc/auth/register/register_bloc.dart';
import 'package:ozro_mobile/src/presentation/bloc/main/home/home_bloc.dart';
import 'package:ozro_mobile/src/presentation/bloc/main/home/product_detail/product_detail_bloc.dart';
import 'package:ozro_mobile/src/presentation/bloc/main/main/main_bloc.dart';
import 'package:ozro_mobile/src/presentation/bloc/main/notification/notification_bloc.dart';
import 'package:ozro_mobile/src/presentation/bloc/main/profile/edit_profile/edit_profile_bloc.dart';
import 'package:ozro_mobile/src/presentation/bloc/main/profile/my_comments/my_comments_bloc.dart';
import 'package:ozro_mobile/src/presentation/bloc/main/profile/my_feedbacks/my_feedbacks_bloc.dart';
import 'package:ozro_mobile/src/presentation/bloc/other/splash/splash_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'core/connectivity/internet_connection_checker.dart';
import 'core/platform/network_info.dart';

final sl = GetIt.instance;
late Box<dynamic> _box;

Future<void> init() async {
  /// External
  final bool isChuckVisible = await initHive();

  sl.registerLazySingleton(
    () => Dio()
      ..options = BaseOptions(
        baseUrl: Constants.baseUrl,
        contentType: 'application/json',
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        connectTimeout: const Duration(seconds: 30),
      )
      // ..httpClientAdapter = IOHttpClientAdapter(
      //   createHttpClient: () {
      //     final HttpClient client = HttpClient()
      //       ..badCertificateCallback = (cert, host, __) {
      //
      //         // log('cert: ${cert.pem}');
      //         // log('host: $host');
      //         // return cert.pem == certificate;
      //         return true;
      //       };
      //     return client;
      //   },
      //   validateCertificate: (cert, host, __) {
      //     // log('cert: ${cert?.pem}');
      //     // log('host: $host');
      //     if (cert == null) {
      //       return true;
      //     }
      //     // Clipboard.setData(ClipboardData(text: cert.pem));
      //     return true;
      //     // return cert.pem == certificate;
      //   },
      // )
      ..interceptors.addAll(
        [
          LogInterceptor(
            requestBody: kDebugMode,
            responseBody: kDebugMode,
            logPrint: (object) => kDebugMode
                ? log(
                    'Dio Log: ${object.toString().length > 2000 ? '${object.toString().substring(0, 2000)}...' : object.toString()}',
                  )
                : null,
          ),
          // if (isChuckVisible)
          chuck.getDioInterceptor()
        ],
      ),
  );
  sl<Dio>().interceptors.addAll(
    [
      // chuck.getDioInterceptor(),
      RetryInterceptor(
        dio: sl<Dio>(),
        forbiddenFunction: () async {
          await localSource.userClear().then(
            (value) {
              rootNavigatorKey.currentContext!.goNamed(
                Routes.initial,
              );
            },
          );
        },
        toNoInternetPageNavigator: () async {
          final GoRouter myRouter = GoRouter.of(rootNavigatorKey.currentContext!);
          final RouteMatch lastMatch = myRouter.routerDelegate.currentConfiguration.last;
          final RouteMatchList matchList =
              lastMatch is ImperativeRouteMatch ? lastMatch.matches : myRouter.routerDelegate.currentConfiguration;
          final String location = matchList.uri.toString();
          if (location.contains(Routes.internetConnection)) {
            return;
          }
          debugLog('current location when internet not connection--->$location');

          await rootNavigatorKey.currentContext!.pushNamed(
            Routes.internetConnection,
          );
        },
        accessTokenGetter: () => 'Bearer ${localSource.accessToken}',
        refreshTokenFunction: () async {
          await localSource.userClear().whenComplete(() {});
          debugPrint('refreshTokenFunction before => ${localSource.accessToken}');
          // final result = await sl<MainRepository>().refreshToken();
          // await result.fold(
          //   (left) async {
          //     // await localSource.clear();
          //     await localSource.userClear().whenComplete(() {
          //       rootNavigatorKey.currentContext!.goNamed(Routes.initial);
          //     });
          //   },
          //   (right) async {
          //     await localSource.setAccessToken(token: right.data?.token?.accessToken ?? '');
          //     debugPrint('refreshTokenFunction after => ${localSource.accessToken}');
          //   },
          // );
        },
        logPrint: (message) {},
      ),
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (localSource.hasProfile) {
            options.headers['Authorization'] = 'Bearer ${localSource.accessToken}';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) => handler.next(response),
        onError: (error, handler) => handler.next(error),
      ),
    ],
  );

  sl
    ..registerSingleton<LocalSource>(LocalSource(_box))
    ..registerLazySingleton(
      () => InternetConnectionChecker.createInstance(
        checkInterval: const Duration(seconds: 3),
      ),
    )
    ..registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(sl()),
    );

  /// main
  _mainFeature();

  /// auth
  _authFeature();
}

void _mainFeature() {
  /// splash
  sl
    ..registerFactory(SplashBloc.new)

    /// main
    ..registerFactory(
      () => MainBloc(
        homeRepository: sl(),
        authRepository: sl(),
      ),
    )

    /// home
    ..registerFactory(
      () => HomeBloc(
        repository: sl(),
      ),
    )
    ..registerFactory(
      () => ProductDetailBloc(
        sl(),
      ),
    )
    ..registerFactory(
      () => EditProfileBloc(
        authRepository: sl(),
      ),
    )
    ..registerFactory(
      () => MyCommentsBloc(sl()),
    )
    ..registerFactory(
      () => MyFeedbacksBloc(sl()),
    )
    ..registerFactory(
          () => NotificationBloc(sl()),
    )

    ..registerLazySingleton<MainRepository>(
      () => MainRepositoryImpl(
        networkInfo: sl(),
        dio: sl(),
      ),
    );
}

void _authFeature() {
  sl
    ..registerFactory<AuthBloc>(() => AuthBloc(sl<AuthRepository>()))
    ..registerFactory<ConfirmCodeBloc>(() => ConfirmCodeBloc(
          authRepository: sl(),
        ))
    ..registerFactory<RegisterBloc>(
      () => RegisterBloc(authRepository: sl()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        dio: sl(),
        networkInfo: sl(),
      ),
    );
}

Future<bool> initHive() async {
  const boxName = 'bloc_mobile_box';
  final Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  _box = await Hive.openBox<dynamic>(boxName);
  return _box.get(AppKeys.enableChuck, defaultValue: false);
}
