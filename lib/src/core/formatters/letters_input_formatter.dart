import 'package:flutter/services.dart';

class LetterInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(RegExp('[^a-zA-Z]'), '');

    return TextEditingValue(
      text: newText,
      selection: newValue.selection,
    );
  }
}
