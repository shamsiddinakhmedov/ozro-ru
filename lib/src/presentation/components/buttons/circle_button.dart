import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
    required this.onTap,
    this.svgPath = '',
    this.iconColor,
    this.title,
    this.size = 40,
    this.padding = AppUtils.kPaddingAll4,
    this.circleColor,
    this.isSvg = true,
    this.iconData,
    this.iconSize,
    this.borderRadius,
    this.withAnimation = false,
  });

  final VoidCallback onTap;
  final String svgPath;
  final IconData? iconData;
  final Color? iconColor;
  final double size;
  final String? title;
  final EdgeInsetsGeometry padding;
  final Color? circleColor;
  final bool isSvg;
  final double? iconSize;
  final BorderRadius? borderRadius;
  final bool withAnimation;

  @override
  Widget build(BuildContext context) => withAnimation
      ? _CircleButtonWithAnimation(
          onTap: onTap,
          svgPath: svgPath,
          iconData: iconData,
          iconColor: iconColor,
          size: size,
          padding: padding,
          circleColor: circleColor,
          isSvg: isSvg,
          iconSize: iconSize,
          borderRadius: borderRadius,
        )
      : _CircleButtonWithoutAnimation(
          onTap: onTap,
          svgPath: svgPath,
          iconData: iconData,
          iconColor: iconColor,
          title: title,
          size: size,
          padding: padding,
          circleColor: circleColor,
          isSvg: isSvg,
          iconSize: iconSize,
          borderRadius: borderRadius,
        );
}

/// [_CircleButtonWithoutAnimation] without animation
class _CircleButtonWithoutAnimation extends StatelessWidget {
  const _CircleButtonWithoutAnimation({
    required this.onTap,
    this.svgPath = '',
    this.iconColor,
    this.title,
    this.size = 40,
    this.padding = AppUtils.kPaddingAll4,
    this.circleColor,
    this.isSvg = true,
    this.iconData,
    this.iconSize,
    this.borderRadius,
  });

  final VoidCallback onTap;
  final String svgPath;
  final IconData? iconData;
  final Color? iconColor;
  final double size;
  final String? title;
  final EdgeInsetsGeometry padding;
  final Color? circleColor;
  final bool isSvg;
  final double? iconSize;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            type: MaterialType.transparency,
            child: Ink(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: circleColor ?? context.color.disabled,
                shape: borderRadius == null ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: borderRadius,
              ),
              child: InkWell(
                borderRadius: borderRadius ?? AppUtils.kBorderRadius100,
                onTap: onTap,
                child: Padding(
                  padding: padding,
                  child: isSvg
                      ? SvgPicture.asset(
                          svgPath,
                          colorFilter: ColorFilter.mode(
                            iconColor ?? context.color.iconColor,
                            BlendMode.srcIn,
                          ),
                        )
                      : Icon(
                          iconData,
                          color: iconColor ?? context.color.darkGrey5,
                          size: iconSize,
                        ),
                ),
              ),
            ),
          ),
          if (title != null) ...[
            AppUtils.kGap4,
            Text(
              title!,
              style: context.textStyle.bodyFootnote.copyWith(
                color: context.color.midGrey2,
              ),
            ),
          ],
        ],
      );
}

/// [_CircleButtonWithAnimation] with animation
class _CircleButtonWithAnimation extends StatefulWidget {
  const _CircleButtonWithAnimation({
    required this.onTap,
    this.svgPath = '',
    this.iconColor,
    this.size = 40,
    this.padding = AppUtils.kPaddingAll4,
    this.circleColor,
    this.isSvg = true,
    this.iconData,
    this.iconSize,
    this.borderRadius,
  });

  final VoidCallback onTap;
  final String svgPath;
  final IconData? iconData;
  final Color? iconColor;
  final double size;
  final EdgeInsetsGeometry padding;
  final Color? circleColor;
  final bool isSvg;
  final double? iconSize;
  final BorderRadius? borderRadius;

  @override
  State<_CircleButtonWithAnimation> createState() => _CircleButtonWithAnimationState();
}

class _CircleButtonWithAnimationState extends State<_CircleButtonWithAnimation> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _animationRadius;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )
      ..addListener(() {
        setState(() {});
      })
      ..repeat();

    _animation = Tween<double>(begin: 0.6, end: 0).animate(
      CurveTween(curve: Curves.ease).animate(_controller),
    );
    _animationRadius = Tween<double>(begin: 1, end: 1.5).animate(
      CurveTween(curve: Curves.ease).animate(_controller),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: widget.size * 1.5,
        width: widget.size * 1.5,
        child: Center(
          child: SizedBox(
            height: widget.size * _animationRadius.value,
            width: widget.size * _animationRadius.value,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: AppUtils.kBorderRadius100,
                color: (widget.circleColor ?? context.colorScheme.primary).withOpacity(_animation.value),
              ),
              child: Center(
                child: SizedBox(
                  height: widget.size,
                  width: widget.size,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: widget.circleColor ?? context.color.disabled,
                      borderRadius: AppUtils.kBorderRadius100,
                      boxShadow: [
                        BoxShadow(
                          color: ThemeColors.light.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: InkWell(
                      borderRadius: widget.borderRadius ?? AppUtils.kBorderRadius100,
                      onTap: widget.onTap,
                      child: Padding(
                        padding: widget.padding,
                        child: widget.isSvg
                            ? SvgPicture.asset(
                                widget.svgPath,
                                colorFilter: ColorFilter.mode(
                                  widget.iconColor ?? context.color.iconColor,
                                  BlendMode.srcIn,
                                ),
                              )
                            : Icon(
                                widget.iconData,
                                color: widget.iconColor ?? context.color.darkGrey5,
                                size: widget.iconSize,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
