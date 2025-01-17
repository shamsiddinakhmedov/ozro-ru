import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/typedef/app_typedef.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';

import 'custom_search_drop_down.dart';

class CustomSearchDropDownButton<T> extends StatelessWidget {
  const CustomSearchDropDownButton({
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
    this.padding,
    this.controller,
    this.prefixIcon,
    this.isTextFieldActive,
    this.onClear,
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
  final SearchDropdownItem<T> Function(T, int index) itemBuilder;
  final bool showError;
  final String? errorText;
  final String? selectedItemText;
  final EdgeInsets? padding;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final ValueChanged<bool>? isTextFieldActive;
  final void Function()? onClear;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (labelText != null)
            Text(
              labelText!,
              style: mainTextStyle,
            ),
          if (labelText != null) const SizedBox(height: 6),
          Padding(
            padding: padding ?? EdgeInsets.zero,
            child: CustomSearchDropDown<T>(
              onClear: onClear,
              isSearchable: true,
              validator: validator,
              isTextFieldActive: isTextFieldActive,
              prefixIcon: prefixIcon,
              selectedItemText: selectedItemText,
              onChange: onChange,
              controller: controller,
              items: List.generate(
                items.length,
                (index) => itemBuilder(
                  items[index],
                  index,
                ),
              ),
              dropdownButtonStyle: SearchDropdownButtonStyle(
                foregroundColor: context.color.midGrey,
                height: 50,
                elevation: 0,
                borderColor: showError ? Colors.red : null,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                padding: EdgeInsets.zero,
                backgroundColor: backgroundColor ?? context.color.disabled,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppUtils.kBorderRadius8,
                ),
              ),
              // hideIcon: true,
              dropdownStyle: SearchDropdownStyle(
                offset: const Offset(0, 60),
                color: context.color.white,
                borderRadius: AppUtils.kBorderRadius12,
                padding: AppUtils.kPaddingHorizontal12,
              ),
              initialText: initialText ?? '',
              hinText: hint,
            ),
          ),
          if (showError && errorText != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Text(
                errorText!,
                style: mainTextStyle.copyWith(color: context.color.red),
              ),
            ),
          ]
        ],
      );
}
