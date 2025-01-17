import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ozro_mobile/src/core/constants/app_keys.dart';
import 'package:ozro_mobile/src/core/constants/constants.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';

final class LocalSource {
  const LocalSource(this.box);

  final Box<dynamic> box;

  void setHasProfile({
    required bool value,
  }) {
    box.put(AppKeys.hasProfile, value);
  }

  bool get hasProfile => box.get(AppKeys.hasProfile, defaultValue: false) as bool;

  Box get prefes => box;

  Locale get localeObj => switch (locale) {
        'ru' => Constants.ruLan,
        _ => Constants.ruLan,
      };

  String get localeName => '${localeObj.languageCode}_${localeObj.countryCode}';

  Future<void> setUser({
    String? name,
    String? email,
    String? accessToken,
    String? userId,
    String? imageUrl,
  }) async {
    await box.put(AppKeys.hasProfile, true);
    if (name != null) await box.put(AppKeys.name, name);
    if (accessToken != null) await box.put(AppKeys.accessToken, accessToken);
    if (userId != null) await box.put(AppKeys.userId, userId);
    if (email != null) await box.put(AppKeys.email, email);
    if (imageUrl != null) await box.put(AppKeys.imageUrl, imageUrl);
  }

  String get accessToken => box.get(AppKeys.accessToken, defaultValue: '') as String;

  String get refreshToken => box.get(AppKeys.refreshToken, defaultValue: '') as String;

  String get name => box.get(AppKeys.name, defaultValue: '') as String;

  String get imageUrl => box.get(AppKeys.imageUrl, defaultValue: '') as String;

  String get login => box.get(AppKeys.login, defaultValue: '') as String;

  String get email => box.get(AppKeys.email, defaultValue: '') as String;

  String get phone => box.get(AppKeys.phone, defaultValue: '') as String;

  String get userId => box.get(AppKeys.userId, defaultValue: '') as String;

  bool get isFirstInit => box.get(AppKeys.firstInit, defaultValue: true);

  String get locale => box.get(
        AppKeys.languageCode,
        defaultValue: defaultLocale,
      ) as String;

  bool get lanSelected => box.get(AppKeys.langSelected, defaultValue: false) is bool
      ? box.get(AppKeys.langSelected, defaultValue: false) as bool
      : false;

  Future<void> setFirstInit() async {
    await box.put(AppKeys.firstInit, false);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await box.put(AppKeys.themeMode, mode.name);
  }

  Future<void> setLocale(String lang) async {
    await box.put(AppKeys.languageCode, lang);
  }

  Future<void> setKey(String key, String value) async {
    await box.put(key, value);
  }

  Future<void> setLangSelected({
    required bool value,
  }) async {
    await box.put(AppKeys.langSelected, value);
  }

  Future<void> setAccessToken({required String? token}) async {
    await box.put(AppKeys.accessToken, token);
  }

  Future<void> setRefreshToken({required String token}) async {
    await box.put(AppKeys.refreshToken, token);
  }

  String getKey(String key) => box.get(key, defaultValue: '') as String;


  Future<void> setFCMToken(String firstName) async {
    await box.put(AppKeys.FCMToken, firstName);
  }

  String getFCMToken() => box.get(AppKeys.FCMToken, defaultValue: '');

  Future<void> setDeviceId(String firstName) async {
    await box.put(AppKeys.deviceId, firstName);
  }

  String getDeviceId() => box.get(AppKeys.deviceId, defaultValue: '');




  ThemeMode get themeMode => switch (box.get(AppKeys.themeMode)) {
        'system' => ThemeMode.system,
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  Future<void> clear() async {
    await box.clear();
  }

  /// clear user's info
  Future<void> userClear() async {
    try {
      await box.deleteAll(
        [
          AppKeys.hasProfile,
          AppKeys.phone,
          AppKeys.email,
          AppKeys.name,
          AppKeys.accessToken,
          AppKeys.userId,
          AppKeys.imageUrl,
        ],
      );

      debugPrint('AppKeys.languageCode => ${box.get(AppKeys.languageCode)}');
    } on Exception catch (e, s) {
      if (kDebugMode) {
        log('ERROR USERCLEAR e => $e');
        log('ERROR USERCLEAR s => $s');
      }
    }

    // await box.delete(AppKeys.hasProfile);
    // await box.delete(AppKeys.phone);
    // await box.delete(AppKeys.email);
    // await box.delete(AppKeys.name);
    // await box.delete(AppKeys.surname);
    // await box.delete(AppKeys.accessToken);
    // await box.delete(AppKeys.refreshToken);
    // await box.delete(AppKeys.userId);
    // await box.delete(AppKeys.imageUrl);
  }

  // clear setting's config and anothers
  Future<void> configClear() async {
    await box.delete(AppKeys.firstInit);
  }

  /// ================ SUPER ADMIN (FOR DEVELOPER IN PRODUCTION) ======================
  Future<void> setSuperAdmin() async {
    await box.put(AppKeys.isSuperAdmin, true);
  }

  bool get isSuperAdmin => box.get(AppKeys.isSuperAdmin, defaultValue: false);

  Future<void> setEnableChuck({required bool enableChuck}) async {
    await box.put(AppKeys.enableChuck, enableChuck);
  }

  bool get enableChuck => box.get(AppKeys.enableChuck, defaultValue: false);

  Future<void> setTestEnvironment({required bool testEnvironment}) async {
    await box.put(AppKeys.testEnvironment, testEnvironment);
  }

  bool get testEnvironment => box.get(AppKeys.testEnvironment, defaultValue: false);

  Future<void> setSignInWithOutSendCode({required bool signInWithOutSendCode}) async {
    await box.put(AppKeys.signInWithOutSendCode, signInWithOutSendCode);
  }

  bool get signInWithOutSendCode => box.get(AppKeys.signInWithOutSendCode, defaultValue: false);

}
