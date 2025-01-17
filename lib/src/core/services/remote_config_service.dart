// ignore_for_file: void_checks

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/platform/network_info.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/injector_container.dart';
import 'package:package_info_plus/package_info_plus.dart';

sealed class RemoteConfigService {
  RemoteConfigService._();

  static FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  static Future<void> listenRemoteConfig({
    required void Function(AppUpdateStatus status) onVersionChanged,
  }) async {
    if (await sl<NetworkInfo>().isConnected) {
      try {
        await remoteConfig.setConfigSettings(
          RemoteConfigSettings(
            fetchTimeout: Duration.zero,
            minimumFetchInterval: Duration.zero,
          ),
        );
        AppUpdateStatus? status;
        remoteConfig.onConfigUpdated.listen(
          (event) async {
            debugLog('onConfigUpdated: ${event.updatedKeys}');
            try {
              final packageInfo = await PackageInfo.fromPlatform();
              await remoteConfig.setConfigSettings(
                RemoteConfigSettings(
                  fetchTimeout: Duration.zero,
                  minimumFetchInterval: Duration.zero,
                ),
              );
              RemoteConfigValue? version;
              if (Platform.isAndroid) {
                version = remoteConfig.getAll()['ozro_android'];
              } else {
                version = remoteConfig.getAll()['ozro_ios'];
              }
              final isNotLast = isNotLastVersion(packageInfo.version, version);
              debugLog('isNotLast: $isNotLast');
              status = AppUpdateStatus.forceUpdate;
              onVersionChanged(status ?? AppUpdateStatus.none);
            } on Exception catch (e, s) {
              log('Firebase initialize error: $e $s');
              status = AppUpdateStatus.none;
              onVersionChanged(status ?? AppUpdateStatus.none);
            }
          },
        );
      } on Exception catch (e, s) {
        log('Firebase initialize error: $e $s');
      }
    }
  }

  static Future<AppUpdateStatus> isCallCheckAppVersion() async {
    if (await sl<NetworkInfo>().isConnected) {
      try {
        final packageInfo = await PackageInfo.fromPlatform();
        await remoteConfig.setConfigSettings(
          RemoteConfigSettings(
            fetchTimeout: Duration.zero,
            minimumFetchInterval: Duration.zero,
          ),
        );
        await remoteConfig.fetchAndActivate();
        RemoteConfigValue? version;
        if (Platform.isAndroid) {
          version = remoteConfig.getAll()['ozro_android'];
        } else {
          version = remoteConfig.getAll()['ozro_ios'];
        }
        final isNotLast = isNotLastVersion(packageInfo.version, version);
        debugLog('isNotLast: $isNotLast');
        return isNotLast;
      } on Exception catch (e, s) {
        log('Firebase initialize error: $e $s');
        return AppUpdateStatus.none;
      }
    } else {
      // ignore: use_build_context_synchronously
      return router.pushNamed(Routes.internetConnection).then(
            (value) => isCallCheckAppVersion(),
          );
    }
  }


  static AppUpdateStatus isNotLastVersion(
    String packageInfo,
    RemoteConfigValue? employeeVersion,
  ) {
    if (employeeVersion == null) return AppUpdateStatus.none;
    final Map<String, dynamic> employeeVersionMap = jsonDecode(employeeVersion.asString());
    final String version = employeeVersionMap['version'];
    final bool isForce = employeeVersionMap['is_force'];
    final bool justNotWorking = employeeVersionMap['just_not_work'];
    final int employee = version.replaceAll('.', '').toVersion;
    final int package = packageInfo.replaceAll('.', '').toVersion;
    if (justNotWorking && !localSource.isSuperAdmin) return AppUpdateStatus.justNotWorking;
    if (package < employee && isForce) return AppUpdateStatus.forceUpdate;
    if (package < employee && !isForce) return AppUpdateStatus.softUpdate;
    return AppUpdateStatus.none;
  }
}

enum AppUpdateStatus {
  forceUpdate,
  softUpdate,
  justNotWorking,
  none;

  bool get isForceUpdate => this == AppUpdateStatus.forceUpdate;

  bool get isSoftUpdate => this == AppUpdateStatus.softUpdate;

  bool get isJustNotWorking => this == AppUpdateStatus.justNotWorking;

  bool get isNone => this == AppUpdateStatus.none;
}

extension VersionParsing on String {
  int get toVersion => int.tryParse(replaceAll('.', '')) ?? 0;
}
