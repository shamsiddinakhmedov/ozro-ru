import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/constants/app_keys.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/flash_bar_utils.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/enum_status.dart';
import 'package:ozro_mobile/src/presentation/bloc/main/main/main_bloc.dart';
import 'package:ozro_mobile/src/presentation/components/dialogs/custom_dialog.dart';
import 'package:ozro_mobile/src/presentation/components/image_network/custom_cached_network_image.dart';
import 'package:ozro_mobile/src/presentation/components/loading_widgets/modal_progress_hud.dart';
import 'package:ozro_mobile/src/presentation/pages/main/profile/widgets/logout_dialog.dart';
import 'package:ozro_mobile/src/presentation/pages/main/profile/widgets/profile_item_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Профиль'),
        ),
        body: BlocListener<MainBloc, MainState>(
          listenWhen: (previous, current) => previous.deleteAccountStatus != current.deleteAccountStatus,
          listener: (context, state) {
            if (state.deleteAccountStatus.isSuccess) {
              localSource.userClear();
              context.goNamed(Routes.initial);
            }
            if (state.deleteAccountStatus.isError) {
              showFlashError(context: context, content: state.errorMessageDeleteAccount);
            }
          },
          child: BlocBuilder<MainBloc, MainState>(
            builder: (_, state) => ModalProgressHUD(
              inAsyncCall: state.deleteAccountStatus.isLoading,
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(
                    const Duration(milliseconds: 200),
                    () {
                      if (context.mounted) context.read<MainBloc>().add(const MainFetchMyCommentsEvent());
                    },
                  );
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    /// user info
                    SliverToBoxAdapter(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: AppUtils.kBorderRadiusOnlyBottom16,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFFf8f8f8),
                              context.color.white,
                              context.color.white,
                              context.color.white,
                              context.color.white,
                              context.color.white,
                              context.color.white,
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: AppUtils.kPaddingHor16Ver32,
                          child: ValueListenableBuilder(
                            valueListenable: localSource.prefes.listenable(
                              keys: [
                                AppKeys.imageUrl,
                                AppKeys.name,
                              ],
                            ),
                            builder: (_, box, ___) => Column(
                              children: [
                                /// EDIT PROFILE
                                GestureDetector(
                                  onTap: () {
                                    context.pushNamed(Routes.editProfile);
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 88,
                                        width: 88,
                                        child: Stack(
                                          children: [
                                            Positioned.fill(
                                              child: Hero(
                                                tag: const ValueKey('user_photo'),
                                                child: CustomCachedNetworkImage(
                                                  imageUrl: box.get(AppKeys.imageUrl) ?? '',
                                                  borderRadius: AppUtils.kBorderRadius100,
                                                  height: 88,
                                                  width: 88,
                                                  defaultWord: box.get(AppKeys.name) ?? '',
                                                  imageColor: context.colorScheme.primary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      AppUtils.kGap16,
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            localSource.name,
                                            style: context.textStyle.buttonStyle.copyWith(
                                              color: context.color.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                          AppUtils.kGap4,
                                          // if (box.get(AppKeys.isVerified, defaultValue: false) as bool) ...[
                                          //   SvgPicture.asset(IconConstants.verified),
                                          //   AppUtils.kGap4,
                                          // ],
                                          Icon(
                                            AppIcons.editUnderLine,
                                            color: context.color.iconColor,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                AppUtils.kGap6,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    AppUtils.kSliverGap16,

                    /// menu
                    SliverToBoxAdapter(
                      child: Material(
                        borderRadius: AppUtils.kBorderRadius16,
                        color: context.color.white,
                        child: Column(
                          children: [
                            ProfileItemWidget(
                              isTopRadius: true,
                              text: 'Мое избранное',
                              onTap: () {
                                context.read<MainBloc>()
                                  ..add(const MainEventChanged(BottomMenu.favorites))
                                  ..add(const MainFetchFavoriteProducts());
                              },
                              icon: AppIcons.favorite,
                              trailing: Text(
                                state.myFavoriteCount.toString(),
                                style:
                                    context.textStyle.regularSubheadline.copyWith(color: context.colorScheme.primary),
                              ),
                            ),
                            AppUtils.kPadDividerLeft55Right16,
                            ProfileItemWidget(
                              text: 'Мои отзывы',
                              onTap: () {
                                context.pushNamed(Routes.myFeedbacks);
                              },
                              icon: AppIcons.like,
                              trailing: Text(
                                state.myFeedbackCount.toString(),
                                style:
                                    context.textStyle.regularSubheadline.copyWith(color: context.colorScheme.primary),
                              ),
                            ),
                            AppUtils.kPadDividerLeft55Right16,
                            ProfileItemWidget(
                              text: 'Мои комментарии',
                              onTap: () {
                                context.pushNamed(Routes.myComments);
                              },
                              icon: AppIcons.comment,
                              trailing: Text(
                                state.myCommentsCount.toString(),
                                style:
                                    context.textStyle.regularSubheadline.copyWith(color: context.colorScheme.primary),
                              ),
                            ),
                            AppUtils.kPadDividerLeft55Right16,
                            ProfileItemWidget(
                              text: 'Выйти',
                              onTap: () {
                                showDialog<void>(
                                  context: context,
                                  builder: (_) => BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 8,
                                      sigmaY: 8,
                                    ),
                                    child: LogOutDialog(
                                      onPressed: () {
                                        context.read<MainBloc>().add(
                                              const MainDeleteProfileEvent(isLogout: true),
                                            );
                                      },
                                    ),
                                  ),
                                );
                                // context.goNamed(Routes.auth);
                              },
                              icon: AppIcons.logout,
                            ),
                            AppUtils.kPadDividerLeft55Right16,
                            ProfileItemWidget(
                              text: 'Удалить аккаунт',
                              onTap: () async {
                                await showCustomDialog(
                                  context: context,
                                  title: 'Удалить аккаунт',
                                  content: 'Вы уверены? Действие невозможно отменить.',
                                  defaultActionText: 'Да',
                                  cancelActionText: 'Нет',
                                  contentPadding: AppUtils.kPaddingVertical16,
                                  contentTextStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  isDefaultActionDisabled: true,
                                ).then(
                                  (value) async {
                                    if (value is bool && value && context.mounted) {
                                      context.read<MainBloc>().add(
                                            const MainDeleteProfileEvent(),
                                          );
                                    }
                                  },
                                );
                              },
                              isBottomRadius: true,
                              icon: AppIcons.delete,
                              iconColor: context.colorScheme.error,
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppUtils.kSliverGap16,
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
