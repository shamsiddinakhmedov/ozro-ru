import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';

class RowTextAndSwitchWidget extends StatelessWidget {
  const RowTextAndSwitchWidget({
    super.key,
    required this.onChanged,
    required this.text,
    this.value = false,
    this.isSwitch = true,
    this.padding = EdgeInsets.zero,
    this.textStyle,
    this.icon,
  });

  final ValueChanged<bool> onChanged;
  final String text;
  final bool value;
  final bool isSwitch;
  final EdgeInsets padding;
  final TextStyle? textStyle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: AppUtils.kBorderRadius8,
        onTap: () {
          onChanged(!value);
        },
        child: Padding(
          padding: padding,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: context.color.iconColor,
                ),
                AppUtils.kGap16,
              ],
              Expanded(
                child: Text(
                  text,
                  style: textStyle ?? context.textStyle.fontSize15FontWeight600ColorDarkGrey,
                ),
              ),
              if (isSwitch) ...[
                Transform.scale(
                  scale: .8,
                  child: CupertinoSwitch(
                    value: value,
                    activeColor: context.colorScheme.primary,
                    onChanged: _onChange,
                  ),
                ),
              ] else ...[
                Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                    side: BorderSide(
                      color: context.color.lightGrey,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppUtils.kBorderRadius6,
                    ),
                    value: value,
                    onChanged: _onChange,
                  ),
                ),
              ],
            ],
          ),
        ),
      );

  void _onChange(bool? value) {
    onChanged(value ?? false);
  }
}
