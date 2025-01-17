import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/config/themes/themes.dart';
import 'package:ozro_mobile/src/core/constants/constants.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/domain/repositories/main/main_repository.dart';
import 'package:ozro_mobile/src/injector_container.dart';
import 'package:ozro_mobile/src/presentation/bloc/main/main/main_bloc.dart';
import 'package:ozro_mobile/src/presentation/components/loading_widgets/modal_progress_hud.dart';
import 'package:ozro_mobile/src/presentation/pages/main/add_review/add_review_page.dart';
import 'package:ozro_mobile/src/presentation/pages/main/home/home_page.dart';
import 'package:ozro_mobile/src/presentation/pages/main/my_favorites/my_favorites_page.dart';
import 'package:ozro_mobile/src/presentation/pages/main/profile/profile_page.dart';

part 'mixin/main_mixin.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with MainMixin, WidgetsBindingObserver {
  @override
  void initState() {
    // Configure the user privacy data policy before init sdk
    // MobileAds.setUserConsent(true);
    // MobileAds.setAgeRestrictedUser(true);
    localSource.setFirstInit();
    context.read<MainBloc>()
        ..add(const MainFetchFavoriteProducts())
        ..add(const MainFetchMyCommentsEvent());
    // if (localSource.accessToken.isNotEmpty) {
    //   sl<MainRepository>().getUserInfo();
    // }
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    lifeCycleState = state;
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocSelector<MainBloc, MainState, BottomMenu>(
        selector: (state) => state.bottomMenu,
        builder: (_, bottomMenu) => WillPopScope(
          onWillPop: () async {
            if (bottomMenu.index != 0) {
              context.read<MainBloc>().add(MainEventChanged(BottomMenu.values.first));
              return false;
            }
            return true;
          },
          child: ModalProgressHUD(
          child: Scaffold(
            body: IndexedStack(
              index: bottomMenu.index,
              children: const [
                HomePage(),
                AddReviewPage(),
                MyFavoritesPage(),
                ProfilePage(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              key: Constants.bottomNavigatorKey,
              onTap: (i) {
                if (i != 0) {
                  if (!localSource.hasProfile) {
                    context.pushNamed(
                      Routes.auth,
                      extra: true,
                    );
                    return;
                  }
                }
                if (i == 0 && bottomMenu == BottomMenu.home) {
                  debugLog('i = 1 && bottomMenu == BottomMenu.home');
                  context.read<MainBloc>().add(const MainScrollToTopHomeEvent());
                }
                if (i == 3 && bottomMenu.index != 3) {
                  context.read<MainBloc>().add(const MainFetchMyCommentsEvent());
                }
                context.read<MainBloc>().add(MainEventChanged(BottomMenu.values[i]));
              },
              currentIndex: bottomMenu.index,
              // selectedLabelStyle: const TextStyle(overflow: TextOverflow.visible),
              // unselectedLabelStyle: const TextStyle(overflow: TextOverflow.visible),
              items: [
                _navigationBarItem(label: 'Главная', icon: AppIcons.home, activeIcon: AppIcons.homeFilled),
                _navigationBarItem(
                  label: 'Отзыв',
                  icon: AppIcons.chat,
                  activeIcon: AppIcons.chatFilled,
                ),
                _navigationBarItem(
                  label: 'Избранные',
                  icon: AppIcons.favorite,
                  activeIcon: AppIcons.favoriteFilled,
                ),
                _navigationBarItem(
                  label: 'Профиль',
                  icon: AppIcons.accountCircle,
                  activeIcon: AppIcons.accountCircleFilled,
                ),
              ],
            ),
          ),
                     )
        ),
      );

  BottomNavigationBarItem _navigationBarItem({
    required String label,
    required IconData icon,
    IconData? activeIcon,
  }) =>
      BottomNavigationBarItem(
        icon: Badge(
          isLabelVisible: false,
          label: const Text(''),
          child: Padding(
            padding: AppUtils.kPaddingZero,
            child: Icon(icon),
          ),
        ),
        activeIcon: Badge(
          isLabelVisible: false,
          label: const Text(''),
          child: Padding(
            padding: AppUtils.kPaddingZero,
            child: Icon(activeIcon ?? icon),
          ),
        ),
        label: label,
        tooltip: label,
      );
}
