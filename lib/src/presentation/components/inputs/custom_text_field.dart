import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.hintText,
    this.hintStyle,
    this.errorText,
    this.showError = false,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.inputAction,
    this.maxLines,
    this.onChanged,
    this.inputFormatters,
    this.obscureText,
    this.suffixIcon,
    this.suffix,
    this.titleText,
    this.isRequired = false,
    this.enabled,
    this.onTap,
    this.readOnly = false,
    this.fillColor,
    this.minLines,
    this.onComplete,
    this.validator,
    this.autofocus,
    this.prefixIcon,
    this.prefixText,
    this.prefixStyle,
    this.contentPadding,
    this.style,
    this.filled,
    this.maxLength,
    this.counterText,
    this.counterWidget,
    this.withErrorText = false,
    this.textCapitalization = TextCapitalization.sentences,
  });

  final String? hintText;
  final String? counterText;
  final Widget? counterWidget;
  final TextStyle? hintStyle;
  final String? errorText;
  final bool withErrorText;
  final bool showError;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? inputAction;
  final int? maxLines;
  final int? minLines;
  final String? titleText;
  final bool isRequired;
  final void Function(String?)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool? obscureText;
  final bool readOnly;
  final Color? fillColor;
  final bool? autofocus;
  final bool? enabled;
  final void Function()? onTap;
  final Widget? suffixIcon;
  final Widget? suffix;
  final Widget? prefixIcon;
  final void Function()? onComplete;
  final String? Function(String?)? validator;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final EdgeInsets? contentPadding;
  final TextStyle? style;
  final bool? filled;
  final int? maxLength;
  final TextCapitalization textCapitalization;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
    }
    _focusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.titleText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: widget.isRequired
                  ? Row(
                      children: [
                        Text(
                          '*',
                          style: TextStyle(
                            fontSize: 12,
                            height: 14 / 12,
                            fontWeight: FontWeight.w400,
                            color: context.colorScheme.error,
                          ),
                        ),
                        Text(
                          '${widget.titleText}',
                          style: TextStyle(
                            fontSize: 12,
                            height: 14 / 12,
                            fontWeight: FontWeight.w400,
                            color: context.color.darkGrey2,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      '${widget.titleText}',
                      style: TextStyle(
                        fontSize: 12,
                        height: 14 / 12,
                        fontWeight: FontWeight.w400,
                        color: context.color.darkGrey2,
                      ),
                    ),
            ),
          TextFormField(
            maxLength: widget.maxLength,
            validator: widget.validator,
            textCapitalization: widget.textCapitalization,
            readOnly: widget.readOnly,
            enabled: widget.enabled ?? true,
            autofocus: widget.autofocus ?? false,
            obscureText: widget.obscureText ?? false,
            controller: widget.controller,
            focusNode: _focusNode,
            onTap: widget.onTap,
            style: widget.style ??
                const TextStyle(
                  fontSize: 13,
                  height: 16 / 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
            textInputAction: widget.inputAction ?? TextInputAction.next,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              counter: widget.counterWidget,
              counterText: widget.counterText,
              hintStyle: widget.hintStyle,
              fillColor: _focusNode.hasFocus
                  ? context.color.white
                  : widget.showError
                      ? context.colorScheme.error.withOpacity(0.03)
                      : widget.fillColor,
              filled: widget.filled,
              suffixIcon: widget.suffixIcon,
              suffix: widget.suffix,
              prefixIcon: widget.prefixIcon,
              disabledBorder: OutlineInputBorder(
                borderRadius: AppUtils.kBorderRadius12,
                borderSide: BorderSide(
                  color: widget.showError ? context.colorScheme.error : Colors.transparent,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppUtils.kBorderRadius12,
                borderSide: BorderSide(
                  color: widget.showError ? context.colorScheme.error : Colors.transparent,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppUtils.kBorderRadius12,
                borderSide: BorderSide(
                  color: widget.showError ? context.colorScheme.error : context.colorScheme.primary,
                  width: 2,
                ),
              ),
              errorText: widget.showError && widget.withErrorText ? widget.errorText : null,
              errorStyle: TextStyle(fontSize: 13, color: context.colorScheme.error),
              errorMaxLines: 2,
              hintText: widget.hintText,
              contentPadding: widget.contentPadding,
              prefixText: widget.prefixText,
              prefixStyle: widget.prefixStyle,
            ),
            cursorColor: context.theme.colorScheme.primary,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines ?? 1,
            minLines: widget.minLines ?? 1,
            inputFormatters: widget.inputFormatters,
            onEditingComplete: widget.onComplete,
          ),
        ],
      );
}
