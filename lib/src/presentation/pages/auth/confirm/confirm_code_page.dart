import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/enum_status.dart';
import 'package:ozro_mobile/src/presentation/bloc/auth/confirm/confirm_code_bloc.dart';
import 'package:ozro_mobile/src/presentation/components/buttons/bottom_navigation_button.dart';
import 'package:ozro_mobile/src/presentation/components/loading_widgets/modal_progress_hud.dart';
import 'package:ozro_mobile/src/presentation/components/loading_widgets/timer_widget.dart';
import 'package:pinput/pinput.dart';

part 'mixin/confirm_code_mixin.dart';

class ConfirmCodePage extends StatefulWidget {
  const ConfirmCodePage({
    super.key,
    required this.args,
  });

  final ConfirmCodePageArgs args;

  @override
  State<ConfirmCodePage> createState() => _ConfirmCodePageState();
}

class _ConfirmCodePageState extends State<ConfirmCodePage> with ConfirmCodeMixin {
  @override
  Widget build(BuildContext context) => BlocConsumer<ConfirmCodeBloc, ConfirmCodeState>(
        listener: (_, state) {
          if (state.status.isSuccess) {
            if (widget.args.password.trim().isNotEmpty) {
              context.goNamed(Routes.auth);
            } else {
              context.goNamed(Routes.main);
            }
          } else if (state.status.isInitial) {
            controller.clear();
            focusNode.requestFocus();
          }
        },
        builder: (_, state) => ModalProgressHUD(
          inAsyncCall: state.status.isLoading,
          child: Scaffold(
            backgroundColor: context.color.white,
            appBar: AppBar(
              backgroundColor: context.color.white,
              elevation: 0,
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: AppUtils.kPaddingHor16Ver12,
                    child: Text(
                      'Код подтверждения',
                      style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppUtils.kGap20,

                /// SUBTITLE
                const Padding(
                  padding: AppUtils.kPaddingHorizontal16,
                  child: Text(
                    'Введите 6-значный код из email. Не забудьте проверить папку со спамом.',
                    style: TextStyle(
                      color: Color(0xFF92979B),
                    ),
                  ),
                ),
                Padding(
                  padding: AppUtils.kPaddingHorizontal16,
                  child: Text(
                    widget.args.email,
                  ),
                ),
                AppUtils.kGap40,

                /// PINPUT TITLE
                Padding(
                  padding: AppUtils.kPaddingHorizontal16.copyWith(bottom: 6),
                  child: Text(
                    'OTP код',
                    style: TextStyle(
                      fontSize: 12,
                      height: 14 / 12,
                      fontWeight: FontWeight.w400,
                      color: context.color.darkGrey2,
                    ),
                  ),
                ),

                /// PINPUT
                Center(
                  child: Pinput(
                    length: 6,
                    autofocus: true,
                    cursor: Text(
                      '|',
                      style: TextStyle(
                        color: state.status.isLoading ? context.colorScheme.error : context.colorScheme.primary,
                      ),
                    ),
                    focusNode: focusNode,
                    controller: controller,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    errorPinTheme: errorPinTheme,
                    errorBuilder: (errorText, pin) => Padding(
                      padding: AppUtils.kPaddingAll4,
                      child: Text(
                        errorText ?? '',
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          height: 14 / 12,
                          fontWeight: FontWeight.w400,
                          color: context.colorScheme.error,
                        ),
                      ),
                    ),
                    errorText: state.status.isError ? state.errorMessage : '',
                    onChanged: (value) {
                      // context.read<ConfirmCodeBloc>().add(const ConfirmCodeEventInitial());
                    },

                    /// showError
                    forceErrorState: state.status.isError,
                    onCompleted: (pin) {},
                  ),
                ),
                AppUtils.kSpacer,

                /// TIMER
                Align(
                  child: TimerWidget(
                    onTap: () {
                      _bloc.add(ConfirmCodeSendAgainEvent(widget.args.email));
                    },
                  ),
                ),
                AppUtils.kGap24,
              ],
            ),
            bottomNavigationBar: BottomNavigationButton(
              withBottomViewInsets: true,
              child: ElevatedButton(
                onPressed: controller.text.length == 6
                    ? () {
                        _bloc.add(
                          ConfirmCodeCheckMessageEvent(
                            otp: controller.text.trim(),
                            email: widget.args.email,
                          ),
                        );
                      }
                    : null,
                child: const Text(
                  'Продолжить',
                ),
              ),
            ),
          ),
        ),
      );
}

class ConfirmCodePageArgs {
  const ConfirmCodePageArgs({
    required this.email,
    this.password = '',
  });

  final String email;
  final String password;
}
