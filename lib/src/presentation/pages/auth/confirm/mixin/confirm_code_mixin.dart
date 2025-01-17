part of 'package:ozro_mobile/src/presentation/pages/auth/confirm/confirm_code_page.dart';

mixin ConfirmCodeMixin on State<ConfirmCodePage> {
  late PinTheme defaultPinTheme;
  late PinTheme focusedPinTheme;
  late PinTheme submittedPinTheme;
  late PinTheme errorPinTheme;
  late TextEditingController controller;
  late FocusNode focusNode;
  late ConfirmCodeBloc _bloc;

  @override
  void initState() {
    controller = TextEditingController();
    focusNode = FocusNode();

    _bloc = context.read<ConfirmCodeBloc>();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    controller.addListener(() {
      if (controller.text.isEmpty) {
        setState(() {});
      }
      if (controller.text.length == 6) {
        if (widget.args.password.trim().isNotEmpty) {
          context.read<ConfirmCodeBloc>().add(
                ConfirmCodeSubmitPasswordAndCodeEvent(
                  email: widget.args.email,
                  password: widget.args.password,
                  otp: controller.text.trim(),
                ),
              );
        } else {
          context.read<ConfirmCodeBloc>().add(
                ConfirmCodeCheckMessageEvent(
                  otp: controller.text.trim(),
                  email: widget.args.email,
                ),
              );
        }
      }
    });
    defaultPinTheme = PinTheme(
      width: context.kSize.width / 7.3,
      height: context.kSize.width / 7.3,
      textStyle: TextStyle(
        fontSize: 16,
        color: context.colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: context.color.disabled,
        border: const Border.fromBorderSide(BorderSide.none),
        borderRadius: AppUtils.kBorderRadius12,
      ),
    );
    focusedPinTheme = defaultPinTheme.copyDecorationWith(
      color: context.colorScheme.surface,
      border: Border.all(color: context.colorScheme.primary),
    );
    submittedPinTheme = defaultPinTheme.copyDecorationWith(
      color: context.colorScheme.surface,
      border: Border.all(color: context.colorScheme.primary),
    );
    errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: context.colorScheme.surface,
        border: Border.all(color: context.colorScheme.error),
      ),
      textStyle: defaultPinTheme.textStyle?.copyWith(
        color: context.colorScheme.error,
      ),
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    _bloc.close();
    super.dispose();
  }
}
//
// class SmsRetrieverImpl implements SmsRetriever {
//   const SmsRetrieverImpl(this.smartAuth);
//
//   final SmartAuth smartAuth;
//
//   @override
//   Future<void> dispose() => smartAuth.removeSmsListener();
//
//   @override
//   Future<String?> getSmsCode() async {
//     final signature = await smartAuth.getAppSignature();
//     debugPrint('App Signature: $signature');
//     final res = await smartAuth.getSmsCode(
//       useUserConsentApi: true,
//     );
//     if (res.succeed && res.codeFound) {
//       return res.code!;
//     }
//     return null;
//   }
//
//   @override
//   bool get listenForMultipleSms => false;
// }
