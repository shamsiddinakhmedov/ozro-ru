import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';

Future showCustomDialog({
  required BuildContext context,
  required String title,
  String? subTitle,
  required String content,
  String? cancelActionText,
  bool isDefaultActionDisabled = false,
  String? iconPath,
  required String defaultActionText,
  VoidCallback? onDefaultActionTap,
  VoidCallback? onCancelActionTap,
  EdgeInsetsGeometry? contentPadding,
  TextStyle? contentTextStyle,
  TextStyle? titleTextStyle,
}) async =>
    showDialog(
      barrierDismissible: false,
      traversalEdgeBehavior: TraversalEdgeBehavior.leaveFlutterView,
      context: context,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 8,
          sigmaY: 8,
        ),
        child: Dialog(
          // insetPadding: AppUtils.kPaddingAll16,
          shape: const RoundedRectangleBorder(
            borderRadius: AppUtils.kBorderRadius16,
          ),
          backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
          shadowColor: Theme.of(context).dialogTheme.shadowColor,
          surfaceTintColor: Theme.of(context).dialogTheme.surfaceTintColor,
          child: Padding(
            padding: AppUtils.kPaddingAll16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: titleTextStyle ?? context.textStyle.appBarTitle.copyWith(fontSize: 21),
                  textAlign: TextAlign.center,
                ),
                AppUtils.kGap2,
                if (subTitle != null) ...[
                  Text(
                    subTitle,
                    style: context.textStyle.appBarTitle.copyWith(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  AppUtils.kGap2,
                ],
                Padding(
                  padding: contentPadding ?? AppUtils.kPaddingZero,
                  child: Text(
                    content,
                    style: contentTextStyle ??
                        context.textStyle.regularFootnote.copyWith(
                          color: context.color.darkGrey5,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                AppUtils.kGap12,
                Row(
                  children: [
                    if (cancelActionText != null)
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: const WidgetStatePropertyAll(
                              Color(0xffF1F1F1),
                            ),
                            foregroundColor: WidgetStatePropertyAll(context.color.black),
                          ),
                          child: Text(
                            cancelActionText,
                            style: Theme.of(context).dialogTheme.contentTextStyle,
                          ),
                          onPressed: () {
                            if (onCancelActionTap != null) onCancelActionTap();
                            Navigator.of(context).pop(false);
                          },
                        ),
                      ),
                    if (cancelActionText != null) AppUtils.kGap12,
                    Expanded(
                      child: ElevatedButton(
                        child: Text(
                          defaultActionText,
                          style: Theme.of(context).dialogTheme.contentTextStyle,
                        ),
                        onPressed: () {
                          if (onDefaultActionTap != null) onDefaultActionTap();
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
