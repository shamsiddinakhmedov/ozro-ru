import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';

Future customWarningDialog({
  String content = '',
  required BuildContext context,
  required String title,
  required String buttonName,
  required VoidCallback onTap,
  VoidCallback? onSaveTap,
  String? saveActionText,
  bool forEditProfile = false,
  bool barrierDismissible = true,
}) =>
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => Dialog(
        child: Padding(
          padding: AppUtils.kPaddingAll16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: context.textStyle.bodyBody,
              ),
              content.isNotEmpty ? AppUtils.kGap8 : const SizedBox(),
              Text(
                content,
                textAlign: TextAlign.center,
                style: context.textStyle.regularFootnote.copyWith(
                  color: ThemeColors.light.black,
                ),
              ),
              AppUtils.kGap16,
              Visibility(
                visible: forEditProfile,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onSaveTap,
                        style: context.theme.elevatedButtonTheme.style?.copyWith(
                          padding: WidgetStatePropertyAll(AppUtils.kPaddingVertical8.copyWith(left: 4, right: 4)),
                        ),
                        child: Text(
                          saveActionText ?? 'Сохранить',
                        ),
                      ),
                    ),
                    AppUtils.kGap6,
                    Expanded(
                      child: ElevatedButton(
                        style: context.theme.elevatedButtonTheme.style?.copyWith(
                          backgroundColor: WidgetStatePropertyAll(context.colorScheme.primary.withOpacity(0.1)),
                          foregroundColor: WidgetStatePropertyAll(context.colorScheme.primary),
                        ),
                        onPressed: onTap,
                        child: Text(
                          buttonName,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: !forEditProfile,
                child: ElevatedButton(
                  onPressed: onTap,
                  child: Center(
                    child: Text(
                      buttonName,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
