import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';

class SelectLangButton extends StatelessWidget {
  const SelectLangButton({
    super.key,
    required this.onPressed,
    required this.flag,
    required this.lang,
    this.isSelected = false,
  });

  final void Function() onPressed;
  final String flag;
  final String lang;
  final bool isSelected;

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: AppUtils.kBorderRadius12,
        onTap: onPressed,
        splashColor: context.colorScheme.primary.withOpacity(0.3),
        highlightColor: context.colorScheme.primary.withOpacity(0.1),
        child: Ink(
          width: double.infinity,
          decoration: BoxDecoration(
              color: isSelected
                  ? context.colorScheme.primary
                  : const Color(0xFFEDEFF2),
              borderRadius: AppUtils.kBorderRadius12),
          padding: AppUtils.kPaddingAll16,
          child: SizedBox(
            height: 24,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image(
                    image: AssetImage(flag),
                    height: 24,
                    width: 24,
                    fit: BoxFit.cover,
                  ),
                ),
                AppUtils.kGap6,
                Text(
                  lang,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
