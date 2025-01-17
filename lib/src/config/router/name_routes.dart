part of 'app_routes.dart';

sealed class Routes {
  Routes._();

  static const String initial = '/';
  static const String main = '/main';

  static const String superAdmin = '/super_admin';
  static const String internetConnection = '/internet_connection';
  static const String settings = '/settings';
  static const String auth = '/auth';
  static const String confirmCode = '/confirm_code';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String editProfile = '/edit_profile';
  static const String notifications = '/notifications';
  static const String aboutApp = '/about_app';
  static const String justNotWork = '/just_not_work';
  static const String onBoarding = '/on_boarding';
  static const String productDetail = '/product_detail';
  static const String forgotPassword = '/forgot_password';
  static const String enterNewPassword = '/enter_new_password';
  static const String searchProducts = '/search_products';
  static const String myComments = '/my_comments';
  static const String myFeedbacks = '/my_feedbacks';
  static const String editMyComment = '/edit_my_comment';
  static const String notification = '/notification';



}
