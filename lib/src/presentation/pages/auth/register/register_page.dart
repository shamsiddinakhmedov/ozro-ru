// ignore_for_file: deprecated_member_use

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/formatters/custom_text_input_formatter.dart';
import 'package:ozro_mobile/src/core/utils/flash_bar_utils.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/auth/register_user_request.dart';
import 'package:ozro_mobile/src/data/models/enum_status.dart';
import 'package:ozro_mobile/src/presentation/bloc/auth/register/register_bloc.dart';
import 'package:ozro_mobile/src/presentation/components/buttons/bottom_navigation_button.dart';
import 'package:ozro_mobile/src/presentation/components/inputs/custom_text_field.dart';
import 'package:ozro_mobile/src/presentation/components/loading_widgets/modal_progress_hud.dart';
import 'package:ozro_mobile/src/presentation/pages/auth/confirm/confirm_code_page.dart';
import 'package:url_launcher/url_launcher.dart';

part 'package:ozro_mobile/src/presentation/pages/auth/register/mixin/register_mixin.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.email});

  final String email;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with RegisterMixin, TickerProviderStateMixin {
  @override
  void initState() {
    _emailController = TextEditingController(text: widget.email);
    if (mounted) {
      _bloc.add(RegisterEmailChangedEvent(_emailController.text.trim()));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => BlocListener<RegisterBloc, RegisterState>(
        listener: (_, state) {},
        child: BlocConsumer<RegisterBloc, RegisterState>(
          bloc: _bloc,
          listener: (_, state) {
            if (state.status.isError) {
              showFlashError(context: context, content: state.errorMessage);
            }
            if (state.status.isSuccess) {
              context.goNamed(
                Routes.confirmCode,
                extra: ConfirmCodePageArgs(
                  email: _emailController.text.trim(),
                ),
              );
            }
          },
          builder: (_, state) => WillPopScope(
            onWillPop: () async => !state.status.isLoading,
            child: ModalProgressHUD(
              inAsyncCall: state.status.isLoading,
              child: Scaffold(
                backgroundColor: context.color.white,
                appBar: AppBar(
                  elevation: 0,
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
                            'Создать аккаунт',
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
                          // AppUtils.kGap16,

                          /// SUBTITLE
                          Text('Заполните следующие пустые поля, чтобы полностью зарегистрироваться',
                              style: context.textStyle.regularSubheadline.copyWith(
                                color: const Color(0xFF92979B),
                              )),
                          AppUtils.kGap32,

                          CustomTextField(
                            inputAction: TextInputAction.done,
                            titleText: 'ФИО',
                            hintText: 'Введите ФИО',
                            controller: _nameController,
                            showError: context.watch<RegisterBloc>().state.showNameError,
                            textCapitalization: TextCapitalization.none,
                            // autofocus: true,
                            fillColor: context.color.disabled,
                            filled: true,
                            onTap: () {},
                            onChanged: (value) {
                              // final changedValue = value?.replaceAll(' ', '') ?? '';
                              context.read<RegisterBloc>().add(
                                    RegisterNameChangedEvent(value ?? ''),
                                  );
                            },
                            // contentPadding: AppUtils.kPaddingHor14Ver16,
                            keyboardType: TextInputType.emailAddress,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          AppUtils.kGap12,
                          CustomTextField(
                            inputAction: TextInputAction.done,
                            titleText: 'Электронная почта',
                            hintText: 'Введите электронная почта',
                            controller: _emailController,
                            showError: context.watch<RegisterBloc>().state.showEmailError,
                            textCapitalization: TextCapitalization.none,
                            // autofocus: true,
                            fillColor: context.color.disabled,
                            filled: true,
                            onTap: () {},
                            inputFormatters: [EmailInputFormatter()],
                            onChanged: (value) {
                              // final changedValue = value?.replaceAll(' ', '') ?? '';
                              context.read<RegisterBloc>().add(
                                    RegisterEmailChangedEvent(value ?? ''),
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
                              controller: _passwordController,
                              obscureText: !isVisiblePassword.value,
                              textCapitalization: TextCapitalization.none,
                              // autofocus: true,
                              fillColor: context.color.disabled,
                              // showError: context.watch<RegisterBloc>().state.showPasswordError,
                              filled: true,
                              onTap: () {},
                              onChanged: (value) {
                                // final changedValue = value?.replaceAll(' ', '') ?? '';
                                context.read<RegisterBloc>().add(
                                      RegisterPasswordChangeEvent(value ?? ''),
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
                          AppUtils.kGap12,
                          ValueListenableBuilder(
                            valueListenable: isVisiblePassword,
                            builder: (context, value, child) => CustomTextField(
                              inputAction: TextInputAction.done,
                              titleText: 'Подтвердите пароль',
                              hintText: 'Подтвердите пароль',
                              controller: _confirmPasswordController,
                              textCapitalization: TextCapitalization.none,
                              // autofocus: true,
                              fillColor: context.color.disabled,
                              obscureText: !isVisiblePassword.value,
                              showError: context.watch<RegisterBloc>().state.showPasswordError,
                              filled: true,
                              onTap: () {},
                              onChanged: (value) {
                                // final changedValue = value?.replaceAll(' ', '') ?? '';
                                context.read<RegisterBloc>().add(
                                      RegisterConfirmPasswordChangeEvent(value ?? ''),
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
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: AppUtils.kPaddingAll16,
                      sliver: SliverFillRemaining(
                        hasScrollBody: false,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: RichText(
                            textAlign: TextAlign.center,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: 'Нажав кнопку «Продолжить», вы подтверждаете\n',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF708393),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Политика конфеденциалности',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: context.colorScheme.primary,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => launchUrl(Uri.parse(
                                        'https://ozro.ru/privacy.html')),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                bottomNavigationBar: BottomNavigationButton(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: BlocBuilder<RegisterBloc, RegisterState>(
                          builder: (_, state) => ElevatedButton(
                            onPressed: state.validationSuccess ? _registerUser : null,
                            child: const Text(
                              'Продолжить',
                            ),
                          ),
                        ),
                      ),
                      AppUtils.kGap12,
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'У вас есть аккаунт?',
                            style: context.textStyle.regularSubheadline,
                          ),
                          AppUtils.kGap4,
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Text(
                              'Войти',
                              style: context.textStyle.regularSubheadline.copyWith(color: context.colorScheme.primary),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
