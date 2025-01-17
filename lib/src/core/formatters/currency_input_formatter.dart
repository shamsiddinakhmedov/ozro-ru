import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

///Bu to'ri ishlashi uchun inputFormatter: [
/// FilteringTextInputFormatter.allow(RegExp(r"[0-9.0-9]")),
/// CurrencyInputFormatter(),
/// ]
/// qip ishlatish kere

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue.copyWith(text: '');
    }

    String clean = newValue.text.replaceAll(RegExp(r'\s+'), '');
    if (clean.isEmpty) {
      clean = '0';
    }

    final value = num.parse(clean);

    final String newText = moneyFormat(value);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
        offset: newText.length /*- currencySuffix.length*/,
      ),
    );
  }

  static String moneyFormat(num n) {
    final isNegative = n.isNegative;
    final num number = n.abs();
    String result = '0';
    if (number.toString().contains('.')) {
      String firstPart = number.toString().split('.').first;
      final int value = int.tryParse(firstPart) ?? 0;
      firstPart = NumberFormat.currency(
        locale: '',
      ).format(value).split(',').join(' ');
      final secondPart = number.toString().split('.').last;
      result = '$firstPart.$secondPart';
    } else {
      result = NumberFormat().format(number).split(',').join(' ');
    }
    return isNegative ? '-$result' : result;
  }
}
