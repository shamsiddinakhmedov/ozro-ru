import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/presentation/components/inputs/custom_text_field.dart';

class CustomSearchWidget<T extends Object> extends StatelessWidget {
  const CustomSearchWidget({
    super.key,
    required this.onSearch,
    required this.onSelected,
    required this.titleText,
    required this.displayStringForOption,
    required this.initialItems,
    this.hint,
    this.initialText,
  });

  final Future<Iterable<T>> Function(String value) onSearch;
  final ValueChanged<T> onSelected;
  final String Function(T option) displayStringForOption;
  final String titleText;
  final Future<List<T>> initialItems;
  final String? hint;
  final String? initialText;

  @override
  Widget build(BuildContext context) {
    FocusNode focus = FocusNode();
    return Autocomplete<T>(
      initialValue: TextEditingValue(text: initialText ?? 'test'),
      optionsMaxHeight: context.kSize.height * 0.5,
      fieldViewBuilder: (_, controller, focusNode, onSubmitted) {
        if (focusNode.hasFocus) {
          focus = focusNode;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titleText,
              style: context.textStyle.bodyHeadline.copyWith(fontSize: 12),
            ),
            AppUtils.kGap6,
            CustomTextField(
              focusNode: focusNode,
              onComplete: onSubmitted,
              hintText: hint,
              filled: true,
              fillColor: context.color.disabled,
              controller: controller,
            ),
          ],
        );
      },
      displayStringForOption: displayStringForOption,
      optionsBuilder: (textEditingValue) async {
        if (textEditingValue.text.isEmpty) {
          return initialItems;
        } else if (textEditingValue.text.length < 2) {
          final items = await initialItems;
          final result =
              items.where((element) => element.toString().toLowerCase().contains(textEditingValue.text.toLowerCase()));
          return result.isEmpty ? await onSearch(textEditingValue.text) : result;
        } else {
          return onSearch(textEditingValue.text);
        }
      },
      onSelected: (option) {
        onSelected(option);
        if (focus.hasFocus) {
          focus.nextFocus();
        }
      },
      optionsViewBuilder: (_, onSelected, options) => Align(
        alignment: Alignment.topLeft,
        child: Material(
          color: context.color.white,
          type: MaterialType.card,
          elevation: 5,
          borderRadius: AppUtils.kBorderRadius6,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.91,
            height: options.length > 5 ? 240 : options.length * 48,
            child: CustomScrollView(
              shrinkWrap: true,
              slivers: [
                SliverList.separated(
                  itemCount: options.length,
                  itemBuilder: (_, index) => InkWell(
                    borderRadius: AppUtils.kBorderRadius6,
                    onTap: () => onSelected(
                      options.elementAt(index),
                    ),
                    child: Ink(
                      padding: AppUtils.kPaddingAll12,
                      child: Text(
                        displayStringForOption(
                          options.toList()[index],
                        ),
                      ),
                    ),
                  ),
                  separatorBuilder: (_, __) => AppUtils.kDividerHor12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
