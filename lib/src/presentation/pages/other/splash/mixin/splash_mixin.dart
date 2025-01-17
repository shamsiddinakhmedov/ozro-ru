part of 'package:ozro_mobile/src/presentation/pages/other/splash/splash_page.dart';

mixin SplashMixin on State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(const SplashEvent());

    // RemoteConfigService.isCallCheckAppVersion().then(
    //   (value) {
    //     if (!mounted) return;
    //     // context.read<MainBloc>().add(const MainCheckAppVersionEvent());
    //     if (value.isForceUpdate) {
    //       context.pushNamed(
    //         Routes.update,
    //         extra: () async {
    //           await launchUrl(
    //             Uri.parse(Constants.appLink),
    //             mode: LaunchMode.externalApplication,
    //           ).then(
    //             (value) async {
    //               await RemoteConfigService.isCallCheckAppVersion().then(
    //                 (v) {
    //                   debugLog('mystate---> ${v.toString()}');
    //                   if (v.isNone && mounted) {
    //                     Navigator.of(context).pop();
    //                   }
    //                 },
    //               );
    //             },
    //           );
    //         },
    //       ).then(
    //         (value) async {},
    //       );
    //     } else if (value.isJustNotWorking && mounted) {
    //       context.goNamed(Routes.justNotWork);
    //     } else {
    //       if (mounted) {
    //         context.read<SplashBloc>().add(const SplashEvent());
    //       }
    //     }
    //   },
    // );
  }

  Future<void> appUpdateBottomSheet({
    required bool isForceUpdate,
  }) async {
    await customModalBottomSheet<bool>(
      context: context,
      enableDrag: false,
      builder: (_, controller) => AppUpdateBottomSheetWidget(
        onTap: () async {
          await launchUrl(
            Uri.parse(Constants.appLink),
            mode: LaunchMode.externalApplication,
          ).then(
            (value) async {},
          );
        },
        isForceUpdate: isForceUpdate,
      ),
    );
  }
}
