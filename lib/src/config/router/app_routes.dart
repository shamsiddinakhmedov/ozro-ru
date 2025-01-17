import 'package:chuck_interceptor/chuck.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ozro_mobile/src/data/source/local_source.dart';
import 'package:ozro_mobile/src/injector_container.dart';
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
import 'package:ozro_mobile/src/presentation/pages/auth/auth_page/auth_page.dart';
import 'package:ozro_mobile/src/presentation/pages/auth/confirm/confirm_code_page.dart';
import 'package:ozro_mobile/src/presentation/pages/auth/forgot_password/enter_new_password_page.dart';
import 'package:ozro_mobile/src/presentation/pages/auth/forgot_password/forgot_password_page.dart';
import 'package:ozro_mobile/src/presentation/pages/auth/register/register_page.dart';
import 'package:ozro_mobile/src/presentation/pages/main/home/product_detail_page/product_detail_page.dart';
import 'package:ozro_mobile/src/presentation/pages/main/home/search_products_page.dart';
import 'package:ozro_mobile/src/presentation/pages/main/main_page/main_page.dart';
import 'package:ozro_mobile/src/presentation/pages/main/notification/notification_page.dart';
import 'package:ozro_mobile/src/presentation/pages/main/profile/edit_profile/edit_profile_page.dart';
import 'package:ozro_mobile/src/presentation/pages/main/profile/edit_profile/super_admin/super_admin_page.dart';
import 'package:ozro_mobile/src/presentation/pages/main/profile/my_comments_page/my_comments_page.dart';
import 'package:ozro_mobile/src/presentation/pages/main/profile/my_feedbacks_page/edit_my_comment/edit_my_comment_page.dart';
import 'package:ozro_mobile/src/presentation/pages/main/profile/my_feedbacks_page/my_feedbacks_page.dart';
import 'package:ozro_mobile/src/presentation/pages/other/on_boarding/on_boarding_page.dart';
import 'package:ozro_mobile/src/presentation/pages/other/splash/splash_page.dart';

part 'name_routes.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

final localSource = sl<LocalSource>();
final Chuck chuck = Chuck(navigatorKey: rootNavigatorKey);

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: Routes.initial,
  routes: <RouteBase>[
    GoRoute(
      path: Routes.initial,
      name: Routes.initial,
      builder: (_, __) => BlocProvider(
        create: (context) => sl<SplashBloc>(),
        child: const SplashPage(),
      ),
    ),
    GoRoute(
      path: Routes.onBoarding,
      name: Routes.onBoarding,
      builder: (_, __) => const OnBoardingPage(),
    ),
    GoRoute(
      path: Routes.main,
      name: Routes.main,
      builder: (_, __) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => sl<MainBloc>(),
          ),
          BlocProvider(
            create: (_) => sl<HomeBloc>()..add(const HomeFetchCategoriesEvent()),
          ),
        ],
        child: const MainPage(),
      ),
    ),
    GoRoute(
      path: Routes.auth,
      name: Routes.auth,
      builder: (_, state) => BlocProvider(
        create: (_) => sl<AuthBloc>(),
        child: AuthPage(withLeading: state.extra as bool? ?? false),
      ),
    ),
    GoRoute(
      path: Routes.register,
      name: Routes.register,
      builder: (_, state) => BlocProvider(
        create: (_) => sl<RegisterBloc>(),
        child: RegisterPage(
          email: state.extra as String? ?? '',
        ),
      ),
    ),
    GoRoute(
      path: Routes.confirmCode,
      name: Routes.confirmCode,
      builder: (_, state) => BlocProvider(
        create: (_) => sl<ConfirmCodeBloc>(),
        child: ConfirmCodePage(
          args: state.extra! as ConfirmCodePageArgs,
        ),
      ),
    ),
    GoRoute(
      path: Routes.forgotPassword,
      name: Routes.forgotPassword,
      builder: (_, state) => ForgotPasswordPage(
        email: state.extra as String? ?? '',
      ),
    ),
    GoRoute(
      path: Routes.enterNewPassword,
      name: Routes.enterNewPassword,
      builder: (_, state) => EnterNewPasswordPage(
        email: state.extra as String? ?? '',
      ),
    ),
    GoRoute(
      path: Routes.notification,
      name: Routes.notification,
      builder: (_, state) => BlocProvider(
        create: (_) => sl<NotificationBloc>(),
        child: const NotificationPage(),
      ),
    ),

    GoRoute(
      path: Routes.productDetail,
      name: Routes.productDetail,
      builder: (_, state) => BlocProvider(
        create: (_) => sl<ProductDetailBloc>(),
        child: ProductDetailPage(args: state.extra! as ProductDetailPageArgs),
      ),
    ),
    GoRoute(
      path: Routes.searchProducts,
      name: Routes.searchProducts,
      builder: (_, state) => BlocProvider(
        create: (_) => sl<HomeBloc>(),
        child: const SearchProductsPage(),
      ),
    ),
    GoRoute(
      path: Routes.editProfile,
      name: Routes.editProfile,
      builder: (_, state) => BlocProvider(
        create: (_) => sl<EditProfileBloc>(),
        child: const EditProfilePage(),
      ),
    ),
    GoRoute(
      path: Routes.myComments,
      name: Routes.myComments,
      builder: (_, state) => BlocProvider(
        create: (_) => sl<MyCommentsBloc>(),
        child: const MyCommentsPage(),
      ),
    ),
    GoRoute(
      path: Routes.myFeedbacks,
      name: Routes.myFeedbacks,
      builder: (_, state) => BlocProvider(
        create: (_) => sl<MyFeedbacksBloc>(),
        child: const MyFeedbacksPage(),
      ),
    ),
    GoRoute(
      path: Routes.superAdmin,
      name: Routes.superAdmin,
      builder: (_, state) => const SuperAdminPage(),
    ),
    GoRoute(
      path: Routes.editMyComment,
      name: Routes.editMyComment,
      builder: (_, state) => EditMyCommentPage(args: state.extra! as EditMyCommentArgs),
    ),
  ],
);

class FadePageRoute<T> extends PageRouteBuilder<T> {
  FadePageRoute({required this.builder})
      : super(
          pageBuilder: (
            context,
            animation,
            secondaryAnimation,
          ) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
  final WidgetBuilder builder;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 1000);
}
