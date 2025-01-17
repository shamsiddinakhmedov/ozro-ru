import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';

class ModalProgressHUD extends StatelessWidget {
  const ModalProgressHUD({
    super.key,
    this.inAsyncCall = false,
    this.opacity = 0.3,
    this.color = Colors.transparent,
    this.progressIndicator,
    this.offset,
    this.dismissible = false,
    required this.child,
    this.isBackgroundWhite = false,
    this.gradient,
  });

  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Widget? progressIndicator;
  final Offset? offset;
  final bool dismissible;
  final Widget child;
  final LinearGradient? gradient;
  final bool isBackgroundWhite;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Positioned.fill(child: isBackgroundWhite && inAsyncCall ? const Material(color: Colors.white) : child),
          if (inAsyncCall) ...[
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5,
                tileMode: TileMode.mirror,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: gradient ??
                      LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        tileMode: TileMode.mirror,
                        colors: [
                          context.colorScheme.surface.withOpacity(0.05),
                          context.colorScheme.surface.withOpacity(0.1),
                          context.colorScheme.surface.withOpacity(0.05),
                        ],
                      ),
                ),
                child: const ModalBarrier(
                  dismissible: false,
                ),
              ),
            ),
            Center(
                child: progressIndicator ??
                    CircularProgressIndicator.adaptive(
                      strokeCap: StrokeCap.round,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        context.colorScheme.primary,
                      ),
                    )
                // AwesomeLoader(
                //   loaderType: awesomeLoader3,
                //   color: context.colorScheme.primary,
                // ),
                ),
          ],
        ],
      );
}
