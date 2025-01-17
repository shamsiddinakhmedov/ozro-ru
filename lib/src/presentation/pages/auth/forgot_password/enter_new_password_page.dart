import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/flash_bar_utils.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/domain/repositories/auth/auth_repository.dart';
import 'package:ozro_mobile/src/injector_container.dart';
import 'package:ozro_mobile/src/presentation/components/buttons/bottom_navigation_button.dart';
import 'package:ozro_mobile/src/presentation/components/inputs/custom_text_field.dart';
import 'package:ozro_mobile/src/presentation/components/loading_widgets/modal_progress_hud.dart';
import 'package:ozro_mobile/src/presentation/pages/auth/confirm/confirm_code_page.dart';

class EnterNewPasswordPage extends StatefulWidget {
  const EnterNewPasswordPage({super.key, required this.email});

  final String email;

  @override
  State<EnterNewPasswordPage> createState() => _EnterNewPasswordPageState();
}

class _EnterNewPasswordPageState extends State<EnterNewPasswordPage> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isVisiblePassword = ValueNotifier(false);
  late final TextEditingController _passwordController = TextEditingController();
  late final TextEditingController _confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _confirmPasswordFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    isVisiblePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
      valueListenable: isLoading,
      builder: (_, value, __) => ModalProgressHUD(
            inAsyncCall: value,
            child: Scaffold(
              backgroundColor: context.color.white,
              appBar: AppBar(
                elevation: 0,
                bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: AppUtils.kPaddingHor16Ver12,
                      child: Text(
                        'Создать новый пароль',
                        style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
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
                        /// SUBTITLE
                         Text(
                          'Создайте новый пароль так, чтобы в дальнейшем смогли запомнить',
                             style: context.textStyle.regularSubheadline.copyWith(
                               color: const Color(0xFF92979B),
                             )
                        ),
                        AppUtils.kGap32,

                        ValueListenableBuilder(
                          valueListenable: isVisiblePassword,
                          builder: (context, value, child) => Form(
                            key: _passwordFormKey,
                            child: CustomTextField(
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
                                if (value?.isNotEmpty ?? false) {
                                  _passwordFormKey.currentState?.validate();
                                }
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
                              validator: (p0) {
                                if (p0?.isEmpty ?? false) {
                                  return 'Поле не может быть пустым';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        AppUtils.kGap12,
                        ValueListenableBuilder(
                          valueListenable: isVisiblePassword,
                          builder: (context, value, child) => Form(
                            key: _confirmPasswordFormKey,
                            child: CustomTextField(
                              inputAction: TextInputAction.done,
                              titleText: 'Подтвердите пароль',
                              hintText: 'Подтвердите пароль',
                              controller: _confirmPasswordController,
                              textCapitalization: TextCapitalization.none,
                              // autofocus: true,
                              fillColor: context.color.disabled,
                              obscureText: !isVisiblePassword.value,
                              filled: true,
                              onTap: () {},
                              onChanged: (value) {
                                if (value?.isNotEmpty ?? false) {
                                  _confirmPasswordFormKey.currentState?.validate();
                                }
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
                              validator: (p0) {
                                if (p0?.isNotEmpty ?? false) {
                                  if (p0 == _passwordController.text) {
                                    return null;
                                  } else {
                                    return 'Пароли не совпадают';
                                  }
                                } else {
                                  return 'Поле не может быть пустым';
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: BottomNavigationButton(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_passwordFormKey.currentState!.validate() && _confirmPasswordFormKey.currentState!.validate()) {
                      await submit();
                    }
                  },
                  child: const Text(
                    'Продолжить',
                  ),
                ),
              ),
            ),
          ));

  Future<void> submit() async {
    isLoading.value = true;
    final result = await sl<AuthRepository>().forgotPasswordCode(
      request: {
        'email': widget.email,
      },
    );
    result.fold(
      (l) {
        isLoading.value = false;
        showFlashError(context: context, content: l.message);
      },
      (r) {
        isLoading.value = false;
        context.pushNamed(
          Routes.confirmCode,
          extra: ConfirmCodePageArgs(
            email: widget.email,
            password: _passwordController.text.trim(),
          ),
        );
      },
    );
  }
}
