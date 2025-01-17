import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flash/flash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/formatters/custom_text_input_formatter.dart';
import 'package:ozro_mobile/src/core/utils/flash_bar_utils.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/enum_status.dart';
import 'package:ozro_mobile/src/presentation/bloc/auth/auth_bloc/auth_bloc.dart';
import 'package:ozro_mobile/src/presentation/components/buttons/bottom_navigation_button.dart';
import 'package:ozro_mobile/src/presentation/components/inputs/custom_text_field.dart';
import 'package:ozro_mobile/src/presentation/components/loading_widgets/modal_progress_hud.dart';

part 'mixin/auth_mixin.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.withLeading});

  final bool withLeading;

  @override
  State<AuthPage> createState() => _AuthPageState();
}


class _AuthPageState extends State<AuthPage> with AuthMixin {
  @override
  Widget build(BuildContext context) => BlocListener<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state.status.isSuccess) {
            context.goNamed(Routes.main);
          } else if (state.status.isError) {
            showFlashError(
              context: context,
              content: state.errorMessage,
              position: FlashPosition.top,
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (_, state) => ModalProgressHUD(
            inAsyncCall: state.status.isLoading,
            child: Scaffold(
              backgroundColor: context.color.white,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: context.color.white,
                leading: widget.withLeading
                    ? IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back_ios))
                    : null,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: GestureDetector(
                    onHorizontalDragEnd: (detail) {
                      if (localSource.isSuperAdmin) {
                        context.pushNamed(Routes.superAdmin);
                      }
                    },
                    onLongPress: () async {
                      await _superAdminStart(longPress: true);
                    },
                    onTap: () {
                      _superAdminStart(simpleFiveTimesPress: true);
                    },
                    onDoubleTap: () {
                      _superAdminStart(doubleFiveTimesPress: true);
                    },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: AppUtils.kPaddingHor16Ver12,
                        child: Text(
                          'Добро пожаловать!',
                          style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              body: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverPadding(
                    padding: AppUtils.kPaddingAll16,
                    sliver: SliverList.list(
                      children: [
                        AppUtils.kGap16,

                        /// SUBTITLE
                         Text(
                          'Пожалуйста, введите свой адрес электронной почты и пароль для входа.',
                          style: context.textStyle.regularSubheadline.copyWith(
                            color: const Color(0xFF92979B),
                          )
                        ),
                        AppUtils.kGap32,

                        CustomTextField(
                          inputAction: TextInputAction.done,
                          titleText: 'Электронная почта',
                          hintText: 'Введите электронная почта',
                          controller: emailController,
                          showError: context.watch<AuthBloc>().state.showEmailError,
                          textCapitalization: TextCapitalization.none,
                          // autofocus: true,
                          fillColor: context.color.disabled,
                          filled: true,
                          onTap: () {},
                          inputFormatters: [EmailInputFormatter()],
                          onChanged: (value) {
                            // final changedValue = value?.replaceAll(' ', '') ?? '';
                            context.read<AuthBloc>().add(
                                  AuthEmailChangeEvent(value ?? ''),
                                );
                          },
                          // contentPadding: AppUtils.kPaddingHor14Ver16,
                          keyboardType: TextInputType.emailAddress,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        AppUtils.kGap12,

                        ValueListenableBuilder(
                          valueListenable: isVisiblePassword,
                          builder: (context, value, child) => CustomTextField(
                            inputAction: TextInputAction.done,
                            titleText: 'Пароль',
                            hintText: 'Введите',
                            controller: passwordController,
                            textCapitalization: TextCapitalization.none,
                            obscureText: !isVisiblePassword.value,
                            fillColor: context.color.disabled,
                            showError: context.select<AuthBloc, bool>(
                              (bloc) => bloc.state.showPasswordError || bloc.state.status.isError,
                            ),
                            errorText: context.watch<AuthBloc>().state.errorMessage,
                            withErrorText: true,
                            filled: true,
                            onTap: () {},
                            onChanged: (value) {
                              context.read<AuthBloc>().add(
                                    AuthPasswordChangeEvent(value ?? ''),
                                  );
                            },
                            // contentPadding: AppUtils.kPaddingHor14Ver16,
                            keyboardType: TextInputType.visiblePassword,
                            style: Theme.of(context).textTheme.titleMedium,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                isVisiblePassword.value = !value;
                              },
                              child: Icon(
                                value ? Icons.visibility_rounded : Icons.visibility_off_outlined,
                                size: 24,
                                color: context.color.midGrey4,
                              ),
                            ),
                          ),
                        ),
                        AppUtils.kGap8,
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              context.pushNamed(
                                Routes.forgotPassword,
                                extra: emailController.text.trim(),
                              );
                            },
                            child: Text(
                              'Забыли пароль?',
                              style: context.textStyle.regularSubheadline.copyWith(
                                color: context.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: BlocBuilder<AuthBloc, AuthState>(
                builder: (_, state) => BottomNavigationButton(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: !state.validationSuccess
                              ? null
                              : () {
                                  FocusScope.of(context).unfocus();
                                  context.read<AuthBloc>().add(const AuthLoginEvent());
                                },
                          child: const Text(
                            'Войти',
                          ),
                        ),
                      ),
                      AppUtils.kGap12,
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'У вас нет аккаунта?',
                            style: context.textStyle.regularSubheadline,
                          ),
                          AppUtils.kGap4,
                          GestureDetector(
                            onTap: () => context.pushNamed(
                              Routes.register,
                              extra: emailController.text.trim(),
                            ),
                            child: Text(
                              'Создать аккаунт',
                              style: context.textStyle.regularSubheadline.copyWith(color: context.colorScheme.primary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
