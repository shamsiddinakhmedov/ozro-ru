import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/typedef/app_typedef.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/presentation/components/dropdown/main_drop_down/custom_main_drop_down.dart';

class CustomMainDropDownButton<T> extends StatelessWidget {
  const CustomMainDropDownButton({
    super.key,
    required this.items,
    this.hint,
    required this.onChange,
    this.borderColor,
    this.backgroundColor,
    this.textEditingController,
    this.initialText,
    this.validator,
    this.labelText,
    required this.itemBuilder,
    this.showError = false,
    this.errorText,
    this.selectedItemText,
    this.hideIcon = false,
    this.prefixIcon,
    this.mainAxisAlignment,
    this.readOnly = false,
  });

  final List<T> items;
  final String? hint;
  final String? initialText;
  final OnDropDownChanged<T> onChange;
  final Color? borderColor;
  final Color? backgroundColor;
  final TextEditingController? textEditingController;
  final Validator? validator;
  final String? labelText;
  final DropdownItem<T> Function(T, int index) itemBuilder;
  final bool showError;
  final String? errorText;
  final String? selectedItemText;
  final bool hideIcon;
  final Widget? prefixIcon;
  final MainAxisAlignment? mainAxisAlignment;
  final bool readOnly;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null)
            Text(
              labelText!,
              style: context.textStyle.regularFootnote,
            ),
          if (labelText != null) AppUtils.kGap6,
          CustomMainDropdown<T>(
            selectedItemText: selectedItemText,

            icon: Icon(
              Icons.keyboard_arrow_down,
              size: 22,
              color: context.color.midGrey4,
            ),
            prefixIcon: prefixIcon,
            onChange: readOnly ? null : onChange,
            hideIcon: hideIcon,
            items: List.generate(
              items.length,
              (index) => itemBuilder(items[index], index),
            ),
            dropdownButtonStyle: DropdownButtonStyle(
              foregroundColor: context.color.midGrey,
              height: 50,
              elevation: 0,
              borderColor: showError ? context.colorScheme.error : null,
              mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.spaceBetween,
              padding: AppUtils.kPaddingHorizontal12,
              backgroundColor: backgroundColor ?? context.color.disabled,
              shape: const RoundedRectangleBorder(
                borderRadius: AppUtils.kBorderRadius8,
              ),
            ),
            // hideIcon: true,
            dropdownStyle: DropdownStyle(
              offset: const Offset(0, 60),
              color: context.color.white,
              borderRadius: AppUtils.kBorderRadius12,
              padding: AppUtils.kPaddingHorizontal12,
            ),
            initialText: initialText ?? '',
          ),
          if (showError && errorText != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Text(
                errorText!,
                style: context.textStyle.bodyFootnote.copyWith(
                  color: context.colorScheme.error,
                ),
              ),
            ),
          ]
        ],
      );
}
