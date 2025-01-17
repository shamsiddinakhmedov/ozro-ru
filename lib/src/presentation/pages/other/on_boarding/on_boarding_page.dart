import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:ozro_mobile/generated/assets.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';

part 'widgets/on_boarding_item_widget.dart';

part 'widgets/go_back_button.dart';

part 'widgets/go_next_button.dart';

part 'mixin/on_boarding_mixin.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> with _OnBoardingMixin {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.colorScheme.surface,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: context.colorScheme.surface,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: SafeArea(
            minimum: AppUtils.kPaddingVertical12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 5,
                  child: PageView(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    onPageChanged: (value) {
                      debugPrint('value---> $value');
                      pageIndex.value = value;
                    },
                    children: List.generate(
                      _boards.length,
                      (index) => _OnBoardingItemWidget(
                        key: ObjectKey('board $index'),
                        board: _boards[index],
                        onSkipPressed: () => context.goNamed(Routes.main),
                      ),
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: pageIndex,
                  builder: (_, value, __) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      _boards.length,
                      (index) => Padding(
                        padding: AppUtils.kPaddingAll4,
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: index == value
                              ? context.colorScheme.primary
                              : context.color.lightGrey,
                        ),
                      ),
                    ),
                  ),
                ),
                AppUtils.kSpacer,
                ValueListenableBuilder(
                  valueListenable: pageIndex,
                  builder: (_, value, __) => Row(
                    children: [
                      _GoBackButton(
                        // key: ObjectKey('GoBackButton $value'),
                        backIsActive: value != 0,
                        onGoBack: () {
                          pageIndex.value -= 1;
                          _pageController.animateToPage(
                            pageIndex.value,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                      _GoNextButton(
                        // key: ObjectKey('GoNextButton $value'),
                        onGoBack: () {
                          if (pageIndex.value == _boards.length - 1) {
                            context.goNamed(Routes.main);
                          } else {
                            pageIndex.value += 1;
                            _pageController.animateToPage(
                              pageIndex.value,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        isNext: value != _boards.length - 1,
                        backIsActive: value != 0,
                      ),
                    ],
                  ),
                ),
                // AppUtils.kGap6,
              ],
            ),
          ),
        ),
      );
}
