import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/formatters/custom_text_input_formatter.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/presentation/components/buttons/bottom_navigation_button.dart';
import 'package:ozro_mobile/src/presentation/components/inputs/custom_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key, required this.email});

  final String email;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final TextEditingController _emailController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController(text: widget.email);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
                  'Забыли пароль?',
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
                  // AppUtils.kGap16,

                  /// SUBTITLE
                   Text(
                    'Не волнуйтесь, мы вышлем вам инструкции по сбросу пароля.',
                      style: context.textStyle.regularSubheadline.copyWith(
                        color: const Color(0xFF92979B),
                      )
                  ),
                  AppUtils.kGap32,
                  Form(
                    key: _formKey,
                    child: CustomTextField(
                      inputAction: TextInputAction.done,
                      titleText: 'Электронная почта',
                      hintText: 'Введите электронная почта',
                      controller: _emailController,
                      textCapitalization: TextCapitalization.none,
                      // autofocus: true,
                      fillColor: context.color.disabled,
                      filled: true,
                      onTap: () {},
                      inputFormatters: [EmailInputFormatter()],
                      onChanged: (value) {
                        if (value?.isNotEmpty ?? false) {
                          _formKey.currentState!.validate();
                        }
                      },
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return 'Электронная почта обязательна';
                        }
                        if (emailValidator(p0)) {
                          return 'Некорректная электронная почта';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationButton(
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.pushNamed(
                  Routes.enterNewPassword,
                  extra: _emailController.text.trim(),
                );
              }
            },
            child: const Text(
              'Продолжить',
            ),
          ),
        ),
      );
}
