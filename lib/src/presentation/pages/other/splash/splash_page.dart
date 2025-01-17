import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ozro_mobile/generated/assets.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/constants/constants.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/presentation/bloc/other/splash/splash_bloc.dart';
import 'package:ozro_mobile/src/presentation/components/bottom_sheet/custom_bottom_sheet.dart';
import 'package:ozro_mobile/src/presentation/components/bottom_sheet/update_app_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

part 'mixin/splash_mixin.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin, SplashMixin {
  @override
  Widget build(BuildContext context) => BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          debugLog('state.isTimerFinished ${state.isTimerFinished}');
          if (state.isTimerFinished) {
            debugLog('localSource.isFirstInit ${localSource.isFirstInit}');
            if (localSource.isFirstInit) {
              context.pushReplacementNamed(Routes.onBoarding);
            } else {
              // if (localSource.hasProfile) {
              context.pushReplacementNamed(Routes.main);
              // } else {
              //   context.pushReplacementNamed(Routes.auth);
              // }
            }
          }
        },
        child: Scaffold(
          backgroundColor: context.colorScheme.surface,
          body: const Stack(
            children: [
              Positioned.fill(
                child: Center(
                  child: Padding(
                    padding: AppUtils.kPaddingAll100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage(Assets.pngLogo)),
                        AppUtils.kGap12,
                        Text(
                          'Честные отзывы',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 80,
                left: 0,
                right: 0,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeCap: StrokeCap.round,
                    // color: context.colorScheme.surface,
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
