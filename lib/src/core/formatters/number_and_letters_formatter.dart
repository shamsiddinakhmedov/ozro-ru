import 'package:flutter/services.dart';

class NumberAndLettersFormatter extends TextInputFormatter {
  final RegExp _alphaNumericRegExp = RegExp('[a-zA-Z0-9]+');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newString = _alphaNumericRegExp.allMatches(newValue.text).map((match) => match.group(0)).join();
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}
