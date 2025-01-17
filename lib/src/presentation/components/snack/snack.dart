import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';

void show(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
}

void showSnackBar(
  BuildContext context,
  String message,
  SnackBarType type, {
  EdgeInsetsGeometry? padding,
}) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        padding: padding ?? AppUtils.kPaddingAll16,
        behavior: SnackBarBehavior.fixed,
        showCloseIcon: true,
        backgroundColor: type == SnackBarType.success
            ? context.theme.colorScheme.primary
            // : type == SnackBarType.error
            //     ? context.theme.colorScheme.error
            : context.colorScheme.primary,
        clipBehavior: Clip.antiAlias,
        dismissDirection: DismissDirection.none,
        content: GestureDetector(
          onPanDown: (details) {
            ScaffoldMessenger.of(context).clearSnackBars();
          },
          child: Text(message),
        ),
      ),
    );
}

void showCustomSnack(
  BuildContext context, {
  String? svgPath,
  Color? color,
  required String title,
  required String description,
  Color? textColor,
  double? bottom,
}) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: AppUtils.kBorderRadius12,
          // side: BorderSide(
          //   width: 1.5,
          //   style: BorderStyle.none,
          //   color: textColor?.withOpacity(0.5) ?? context.color.black,
          // ),
        ),
        backgroundColor: color ?? const Color.fromRGBO(182, 246, 174, 1),
        content: Row(
          children: [
            if (svgPath != null)
            SvgPicture.asset(
              svgPath,
              colorFilter: ColorFilter.mode(
                textColor ?? context.color.black,
                BlendMode.srcIn,
              ),
            ),
            AppUtils.kGap12,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: textColor ?? context.color.black,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: textColor ?? context.color.midGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        margin: AppUtils.kPaddingAll2.copyWith(
          bottom: bottom ?? context.kSize.height * 0.55,
          right: 10,
          left: 10,
        ),
      ),
    );
}

enum SnackBarType {
  success,
  warning,
  // error,
}
