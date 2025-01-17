import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

part 'icon_constants.dart';

// part 'locale_constants.dart';

sealed class Constants {
  Constants._();

  /// test
  static const baseUrl = 'https://admin.ozro.ru/api/v1/';

  static const ruLan = Locale('ru', 'RU');

  /// id

  static GlobalKey<FormState> bottomNavigatorKey = GlobalKey<FormState>();

  static String adUnitId =
      Platform.isIOS ? 'ca-app-pub-9502198675049095/2215769334' : 'са-app-pub-9502198675049095/9764444105';

  /// social urls
  static final String appLink = Platform.isAndroid ? '' : '';

  static final String banner31Id = Platform.isIOS ? 'R-M-11704608-7' : 'R-M-11735161-6';
  static final String banner21Id = Platform.isIOS ? 'R-M-11704608-6' : 'R-M-11735161-5';
  static final String banner11Id = Platform.isIOS ? 'R-M-11704608-5' : 'R-M-11735161-4';
}

sealed class Urls {
  Urls._();

  /// auth
  static const String register = 'users/register';
  static const String confirmation = 'users/confirmation';
  static const String resendCode = 'users/resend-code';
  static const String login = 'users/login';
  static const String logout = 'users/logout';
  static const String user = 'users/user';
  static const String forgotPassword = 'users/forgot-password';
  static const String forgotPasswordCode = 'users/forgot-password-code';
  static const String resetPassword = 'users/reset-password';

  /// home
  static const String categories = 'wildberries/categories';
  static const String products = 'wildberries/products';
  static const String product = 'wildberries/product';
  static const String favorite = 'wildberries/favorite';
  static const String favorites = 'wildberries/favorites';
  static const String feedbacks = 'wildberries/feedbacks';
  static const String like = 'wildberries/like';
  static const String userComments = 'wildberries/user-comments';
  static const String userFeedbacks = 'wildberries/user-feedbacks';
  static const String comments = 'wildberries/comments';
  static const String getNotification = 'users/notifications';

}

/// Sentinel value for the system text scale factor option.
const double systemTextScaleFactorOption = -1;

/// The splash page animation duration.
const Duration splashPageAnimationDuration = Duration(milliseconds: 1000);

/// The animation display duration.
const Duration animationDuration = Duration(milliseconds: 250);
