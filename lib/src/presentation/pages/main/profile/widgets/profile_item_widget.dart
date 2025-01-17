import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';

class ProfileItemWidget extends StatelessWidget {
  const ProfileItemWidget({
    super.key,
     this.icon,
    required this.text,
    this.isTopRadius = false,
    this.isBottomRadius = false,
    this.onTap,
    this.trailing,
    this.tileColor,
    this.textStyle,
    this.hasIndicator = false,
    this.iconColor,
  });

  final IconData? icon;
  final Color? iconColor;
  final Widget? trailing;
  final String text;
  final bool isTopRadius;
  final bool isBottomRadius;
  final VoidCallback? onTap;
  final Color? tileColor;
  final TextStyle? textStyle;
  final bool hasIndicator;

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: onTap,
        tileColor: tileColor ?? Colors.white,
        contentPadding: AppUtils.kPaddingHorizontal16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: isTopRadius ? AppUtils.kRadius12 : Radius.zero,
            bottom: isBottomRadius ? AppUtils.kRadius12 : Radius.zero,
          ),
        ),
        leading: icon == null ? null : SizedBox(
          width: 24,
          height: 24,
          child: Icon(
            icon,
            color: iconColor??context.colorScheme.primary,
          ),
        ),
        title: Row(
          children: [
            Text(
              text,
              style: textStyle ?? context.textStyle.fontSize15FontWeight600ColorDarkGrey.copyWith(color: context.colorScheme.onSurface),
            ),

          ],
        ),
        trailing: trailing ??
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: context.colorScheme.primary,
            ),
      );
}
