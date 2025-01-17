import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_custom.dart' as date_symbol_data_custom;
import 'package:intl/date_symbols.dart' as intl;
import 'package:intl/intl.dart' as intl;
import 'oz_intl.dart';

class _CyrillicCupertinoLocalizations
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _CyrillicCupertinoLocalizations();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'oz' && locale.countryCode == 'UZ';

  @override
  Future<CupertinoLocalizations> load(Locale locale) async {
    final String localeName = intl.Intl.canonicalizedLocale(locale.toString());
    date_symbol_data_custom.initializeDateFormattingCustom(
      locale: localeName,
      patterns: ozLocaleDatePatterns,
      symbols: intl.DateSymbols.deserializeFromMap(ozDateSymbols),
    );

    return await SynchronousFuture<CupertinoLocalizations>(
      CyrillicCupertinoLocalizations(
        localeName: localeName,
        dayFormat: intl.DateFormat.d(localeName),
        doubleDigitMinuteFormat: intl.DateFormat('mm', localeName),
        singleDigitHourFormat: intl.DateFormat('HH', localeName),
        singleDigitMinuteFormat: intl.DateFormat.m(localeName),
        singleDigitSecondFormat: intl.DateFormat.s(localeName),
        fullYearFormat: intl.DateFormat('y', localeName),
        mediumDateFormat: intl.DateFormat('EEE, MMM d', localeName),
        decimalFormat: intl.NumberFormat('#,##0.###', 'en_US'),
        weekdayFormat: intl.DateFormat.EEEE(localeName),
      ),
    );
  }

  @override
  bool shouldReload(_CyrillicCupertinoLocalizations old) => false;
}

class CyrillicCupertinoLocalizations extends GlobalCupertinoLocalizations {
  CyrillicCupertinoLocalizations({
    super.localeName = 'oz_UZ',
    required super.fullYearFormat,
    required super.dayFormat,
    required super.mediumDateFormat,
    required super.singleDigitHourFormat,
    required super.singleDigitMinuteFormat,
    required super.doubleDigitMinuteFormat,
    required super.singleDigitSecondFormat,
    required super.decimalFormat,
    required super.weekdayFormat,
  });

  static const LocalizationsDelegate<CupertinoLocalizations> delegate =
      _CyrillicCupertinoLocalizations();

  @override
  String get alertDialogLabel => 'Огоҳлантириш';

  @override
  String get anteMeridiemAbbreviation => 'AM';

  @override
  String get copyButtonLabel => 'Нусха олиш';

  @override
  String get cutButtonLabel => 'Кесиб олиш';

  @override
  String get datePickerDateOrderString => 'mdy';

  @override
  String get datePickerDateTimeOrderString => 'date_time_dayPeriod';

  @override
  String? get datePickerHourSemanticsLabelFew => null;

  @override
  String? get datePickerHourSemanticsLabelMany => null;

  @override
  String? get datePickerHourSemanticsLabelOne => r'$hour соат';

  @override
  String get datePickerHourSemanticsLabelOther => r'$hour соат';

  @override
  String? get datePickerHourSemanticsLabelTwo => null;

  @override
  String? get datePickerHourSemanticsLabelZero => null;

  @override
  String? get datePickerMinuteSemanticsLabelFew => null;

  @override
  String? get datePickerMinuteSemanticsLabelMany => null;

  @override
  String? get datePickerMinuteSemanticsLabelOne => '1 дақиқа';

  @override
  String get datePickerMinuteSemanticsLabelOther => r'$minute дақиқа';

  @override
  String? get datePickerMinuteSemanticsLabelTwo => null;

  @override
  String? get datePickerMinuteSemanticsLabelZero => null;

  @override
  String get modalBarrierDismissLabel => 'Ёпиш';

  @override
  String get noSpellCheckReplacementsLabel => 'No Replacements Found';

  @override
  String get pasteButtonLabel => 'Жойлаш';

  @override
  String get postMeridiemAbbreviation => 'PM';

  @override
  String get searchTextFieldPlaceholderLabel => 'Қидирув';

  @override
  String get selectAllButtonLabel => 'Барчасини танлаш';

  @override
  String get tabSemanticsLabelRaw => r'$tabCount варақдан $tabIndex';

  @override
  String? get timerPickerHourLabelFew => null;

  @override
  String? get timerPickerHourLabelMany => null;

  @override
  String? get timerPickerHourLabelOne => 'соат';

  @override
  String get timerPickerHourLabelOther => 'соат';

  @override
  String? get timerPickerHourLabelTwo => null;

  @override
  String? get timerPickerHourLabelZero => null;

  @override
  String? get timerPickerMinuteLabelFew => null;

  @override
  String? get timerPickerMinuteLabelMany => null;

  @override
  String? get timerPickerMinuteLabelOne => 'дақиқа';

  @override
  String get timerPickerMinuteLabelOther => 'дақиқа';

  @override
  String? get timerPickerMinuteLabelTwo => null;

  @override
  String? get timerPickerMinuteLabelZero => null;

  @override
  String? get timerPickerSecondLabelFew => null;

  @override
  String? get timerPickerSecondLabelMany => null;

  @override
  String? get timerPickerSecondLabelOne => 'сония';

  @override
  String get timerPickerSecondLabelOther => 'сония';

  @override
  String? get timerPickerSecondLabelTwo => null;

  @override
  String? get timerPickerSecondLabelZero => null;

  @override
  String get todayLabel => 'Бугун';

  @override
  String get lookUpButtonLabel => '';

  @override
  String get menuDismissLabel => '';

  @override
  String get searchWebButtonLabel => '';

  @override
  String get shareButtonLabel => '';

  @override
  String get clearButtonLabel => '';
}
