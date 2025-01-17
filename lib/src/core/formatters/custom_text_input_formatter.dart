import 'package:flutter/services.dart';

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final regex = RegExp("[^a-zA-Zо'q-яА-Яўқ]+");

    if (regex.hasMatch(newValue.text)) {
      return oldValue;
    }

    return newValue;
  }
}

class EmailInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final regex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\\\\.[a-zA-Z]+',
    );

    if (regex.hasMatch(newValue.text)) {
      return oldValue;
    }

    return newValue;
  }
}
