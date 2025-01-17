import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ozro_mobile/src/core/extension/string_extension.dart';

class ValidatorInputFormatter implements TextInputFormatter {
  ValidatorInputFormatter({required this.editingValidator});

  final StringValidator editingValidator;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final oldValueValid =
    editingValidator.isValid(oldValue.text.replaceAll(RegExp(r'\s+'), ''));
    final newValueValid =
    editingValidator.isValid(newValue.text.replaceAll(RegExp(r'\s+'), ''));
    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    if (newValue.selection.baseOffset == 0) {
      return newValue.copyWith(text: '');
    }

    String clean = newValue.text.replaceAll(RegExp(r'\s+'), '');
    if (clean.isEmpty) {
      clean = '0';
    }

    final String newText = moneyFormatForFormatter(clean);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
        offset: newText.length /*- currencySuffix.length*/,
      ),
    );
  }

  static String moneyFormatForFormatter(String number) {
    String result = '0';
    if (number.contains('.')) {
      if (number.isNumeric) {
        String firstPart = number.split('.').first;
        final int value = int.tryParse(firstPart) ?? 0;
        firstPart = NumberFormat().format(value.abs()).split(',').join(' ');
        final secondPart = number.split('.').last;
        result = '$firstPart.$secondPart';
      }
    } else {
      if (number.isNumeric) {
        final int? part = int.tryParse(number);
        result = NumberFormat().format(part?.abs()).split(',').join(' ');
      }
    }
    return result;
  }
}

abstract class StringValidator {
  bool isValid(String value);
}

class RegexValidator implements StringValidator {
  RegexValidator({required this.regexSource});

  final String regexSource;

  @override
  bool isValid(String value) {
    try {
      final regex = RegExp(regexSource);
      final matches = regex.allMatches(value);
      for (final Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } on FormatException catch  (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}

class DecimalNumberEditingRegexValidator extends RegexValidator {
  DecimalNumberEditingRegexValidator({int maxLength = 8, int minLength = 0})
      : super(
    regexSource: '^([0-9]{$minLength,$maxLength})',
  );
}