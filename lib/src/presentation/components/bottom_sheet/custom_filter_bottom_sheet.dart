import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';

class CustomFilterBottomSheet extends StatelessWidget {
  const CustomFilterBottomSheet({
    super.key,
    this.title = '',
    this.buttonText = '',
    this.showClearButton = false,
    this.showOnSubmitButton = true,
    this.children = const [],
    this.onClear,
    this.onSubmit,
  });

  final String title;
  final String buttonText;
  final bool showClearButton;
  final bool showOnSubmitButton;
  final List<Widget> children;
  final VoidCallback? onClear;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 12, 0),
            child: Row(
              children: [
                Text(
                  title,
                  style: context.textStyle.appBarTitle,
                ),
                AppUtils.kSpacer,
                if (showClearButton)
                  InkWell(
                    onTap: onClear,
                    borderRadius: AppUtils.kBorderRadius12,
                    child: Ink(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        context.tr('clear'),
                        // 'clear'.tr,
                        style: context.textStyle.regularSubheadline.copyWith(
                          color: context.color.midGrey4,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          ...children,
          if (showOnSubmitButton)
            SafeArea(
              child: Padding(
                padding: AppUtils.kPaddingAll16,
                child: ElevatedButton(
                  onPressed: onSubmit,
                  child: Text(buttonText),
                ),
              ),
            )
          else
            AppUtils.kGap32,
        ],
      );
}
