import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';

class CustomDatePicker {
  CustomDatePicker._();

  static Future<DateTime?> showCustomDatePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2010),
      lastDate: lastDate ?? DateTime.now(),
      keyboardType: TextInputType.number,
      builder: (context, child) =>
          Theme(
            data: lightTheme.copyWith(
              colorScheme: ColorScheme.light(
                primary: context.colorScheme.primary,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
              ),
              dialogTheme: const DialogTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: AppUtils.kBorderRadius12,
                ),
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
              ),
            ),
            child: child!,
          ),
    );
    return date;
  }
}
