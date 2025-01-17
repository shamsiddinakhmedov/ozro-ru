import 'package:flutter/services.dart';

class MaxValueFormatter extends TextInputFormatter {
  MaxValueFormatter(this.maxValue);

  final int maxValue;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      final int? enteredNumber = int.tryParse(newValue.text);
      if (enteredNumber != null && enteredNumber > maxValue) {
        // Return the old value if the entered number exceeds the maximum value
        return oldValue;
      }
    }
    return newValue;
  }
}
