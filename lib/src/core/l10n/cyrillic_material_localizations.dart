import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_custom.dart' as date_symbol_data_custom;
import 'package:intl/date_symbols.dart' as intl;
import 'package:intl/intl.dart' as intl;

import 'oz_intl.dart';

// #docregion Delegate
class _CyrillicMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _CyrillicMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'oz' && locale.countryCode == 'UZ';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    final String localeName = intl.Intl.canonicalizedLocale(locale.toString());
    // The locale (in this case `oz_UZ`) needs to be initialized into the custom
    // date symbols and patterns setup that Flutter uses.
    date_symbol_data_custom.initializeDateFormattingCustom(
      locale: localeName,
      patterns: ozLocaleDatePatterns,
      symbols: intl.DateSymbols.deserializeFromMap(ozDateSymbols),
    );

    return await SynchronousFuture<MaterialLocalizations>(
      CyrillicMaterialLocalizations(
        localeName: localeName,
        decimalFormat: intl.NumberFormat('#,##0.###', 'en_US'),
        twoDigitZeroPaddedFormat: intl.NumberFormat('00', 'en_US'),
        fullYearFormat: intl.DateFormat('y', localeName),
        compactDateFormat: intl.DateFormat('yMd', localeName),
        shortDateFormat: intl.DateFormat('yMMMd', localeName),
        mediumDateFormat: intl.DateFormat('EEE, MMM d', localeName),
        longDateFormat: intl.DateFormat('EEEE, MMMM d, y', localeName),
        yearMonthFormat: intl.DateFormat('MMMM y', localeName),
        shortMonthDayFormat: intl.DateFormat('MMM d', localeName),
      ),
    );
  }

  @override
  bool shouldReload(_CyrillicMaterialLocalizationsDelegate old) => false;
}
// #enddocregion Delegate

/// A custom set of localizations for the 'nn' locale. In this example, only
/// the value for openAppDrawerTooltip was modified to use a custom message as
/// an example. Everything else uses the American English (en_US) messages
/// and formatting.
class CyrillicMaterialLocalizations extends GlobalMaterialLocalizations {
  const CyrillicMaterialLocalizations({
    super.localeName = 'oz_UZ',
    required super.fullYearFormat,
    required super.compactDateFormat,
    required super.shortDateFormat,
    required super.mediumDateFormat,
    required super.longDateFormat,
    required super.yearMonthFormat,
    required super.shortMonthDayFormat,
    required super.decimalFormat,
    required super.twoDigitZeroPaddedFormat,
  });

  @override
  String get aboutListTileTitleRaw => r'$applicationName ҳақида';

  @override
  String get alertDialogLabel => 'Огоҳлантириш';

  @override
  String get anteMeridiemAbbreviation => '';

  @override
  String get backButtonTooltip => 'Орқага';

  @override
  String get bottomSheetLabel => 'Қуйи экран';

  @override
  String get calendarModeButtonLabel => 'Тақвимда очиш';

  @override
  String get cancelButtonLabel => 'Бекор қилиш';

  @override
  String get closeButtonLabel => 'Ёпиш';

  @override
  String get closeButtonTooltip => 'Ёпиш';

  @override
  String get collapsedHint => 'Expanded';

  @override
  String get collapsedIconTapHint => 'Ёйиш';

  @override
  String get continueButtonLabel => 'Давом этиш';

  @override
  String get copyButtonLabel => 'Нусха олиш';

  @override
  String get currentDateLabel => 'Бугун';

  @override
  String get cutButtonLabel => 'Кесиб олиш';

  @override
  String get dateHelpText => 'mm/dd/yyyy';

  @override
  String get dateInputLabel => 'Санани киритинг';

  @override
  String get dateOutOfRangeLabel => 'Диапазондан ташқарида.';

  @override
  String get datePickerHelpText => 'Санани танланг';

  @override
  String get dateRangeEndDateSemanticLabelRaw => r'Тугаш санаси: $fullDate';

  @override
  String get dateRangeEndLabel => 'Тугаш санаси';

  @override
  String get dateRangePickerHelpText => 'Оралиқни танланг';

  @override
  String get dateRangeStartDateSemanticLabelRaw =>
      r'Бошланиш санаси: $fullDate';

  @override
  String get dateRangeStartLabel => 'Бошланиш санаси';

  @override
  String get dateSeparator => '/';

  @override
  String get deleteButtonTooltip => 'Олиб ташлаш';

  @override
  String get dialModeButtonLabel => 'Вақтни бураб танлаш режими';

  @override
  String get dialogLabel => 'Мулоқот ойнаси';

  @override
  String get drawerLabel => 'Навигация менюси';

  @override
  String get expandedHint => 'Collapsed';

  @override
  String get expandedIconTapHint => 'Кичрайтириш';

  @override
  String get expansionTileCollapsedHint => 'double tap to expand';

  @override
  String get expansionTileCollapsedTapHint => 'Expand for more details';

  @override
  String get expansionTileExpandedHint => "double tap to collapse'";

  @override
  String get expansionTileExpandedTapHint => 'Collapse';

  @override
  String get firstPageTooltip => 'Биринчи саҳифа';

  @override
  String get hideAccountsLabel => 'Ҳисобларни беркитиш';

  @override
  String get inputDateModeButtonLabel => 'Мустақил киритиш';

  @override
  String get inputTimeModeButtonLabel => 'Вақтни ёзиб танлаш режими';

  @override
  String get invalidDateFormatLabel => 'Яроқсиз формат.';

  @override
  String get invalidDateRangeLabel => 'Яроқсиз оралиқ.';

  @override
  String get invalidTimeLabel => 'Вақт хато киритилди';

  @override
  String get keyboardKeyAlt => 'Alt';

  @override
  String get keyboardKeyAltGraph => 'AltGr';

  @override
  String get keyboardKeyBackspace => 'Backspace';

  @override
  String get keyboardKeyCapsLock => 'Caps Lock';

  @override
  String get keyboardKeyChannelDown => 'Кейинги канал';

  @override
  String get keyboardKeyChannelUp => 'Aввалги канал';

  @override
  String get keyboardKeyControl => 'Ctrl';

  @override
  String get keyboardKeyDelete => 'Del';

  @override
  String get keyboardKeyEject => 'Eject';

  @override
  String get keyboardKeyEnd => 'End';

  @override
  String get keyboardKeyEscape => 'Esc';

  @override
  String get keyboardKeyFn => 'Fn';

  @override
  String get keyboardKeyHome => 'Home';

  @override
  String get keyboardKeyInsert => 'Insert';

  @override
  String get keyboardKeyMeta => 'Meta';

  @override
  String get keyboardKeyMetaMacOs => 'Command';

  @override
  String get keyboardKeyMetaWindows => 'Win';

  @override
  String get keyboardKeyNumLock => 'Num Lock';

  @override
  String get keyboardKeyNumpad0 => 'Num 0';

  @override
  String get keyboardKeyNumpad1 => 'Num 1';

  @override
  String get keyboardKeyNumpad2 => 'Num 2';

  @override
  String get keyboardKeyNumpad3 => 'Num 3';

  @override
  String get keyboardKeyNumpad4 => 'Num 4';

  @override
  String get keyboardKeyNumpad5 => 'Num 5';

  @override
  String get keyboardKeyNumpad6 => 'Num 6';

  @override
  String get keyboardKeyNumpad7 => 'Num 7';

  @override
  String get keyboardKeyNumpad8 => 'Num 8';

  @override
  String get keyboardKeyNumpad9 => 'Num 9';

  @override
  String get keyboardKeyNumpadAdd => 'Num +';

  @override
  String get keyboardKeyNumpadComma => 'Num ,';

  @override
  String get keyboardKeyNumpadDecimal => 'Num .';

  @override
  String get keyboardKeyNumpadDivide => 'Num /';

  @override
  String get keyboardKeyNumpadEnter => 'Num Enter';

  @override
  String get keyboardKeyNumpadEqual => 'Num =';

  @override
  String get keyboardKeyNumpadMultiply => 'Num *';

  @override
  String get keyboardKeyNumpadParenLeft => 'Num (';

  @override
  String get keyboardKeyNumpadParenRight => 'Num )';

  @override
  String get keyboardKeyNumpadSubtract => 'Num -';

  @override
  String get keyboardKeyPageDown => 'PgDown';

  @override
  String get keyboardKeyPageUp => 'PgUp';

  @override
  String get keyboardKeyPower => 'Power';

  @override
  String get keyboardKeyPowerOff => 'Power Off';

  @override
  String get keyboardKeyPrintScreen => 'Print Screen';

  @override
  String get keyboardKeyScrollLock => 'Scroll Lock';

  @override
  String get keyboardKeySelect => 'Select';

  @override
  String get keyboardKeyShift => 'Shift';

  @override
  String get keyboardKeySpace => 'Бўш жой';

  @override
  String get lastPageTooltip => 'Охирги саҳифа';

  @override
  String? get licensesPackageDetailTextFew => null;

  @override
  String? get licensesPackageDetailTextMany => null;

  @override
  String? get licensesPackageDetailTextOne => '1 та лицензия';

  @override
  String get licensesPackageDetailTextOther => r'$licenseCount та лицензия';

  @override
  String? get licensesPackageDetailTextTwo => null;

  @override
  String? get licensesPackageDetailTextZero => 'No licenses';

  @override
  String get licensesPageTitle => 'Лицензиялар';

  @override
  String get menuBarMenuLabel => 'Меню панели';

  @override
  String get modalBarrierDismissLabel => 'Ёпиш';

  @override
  String get moreButtonTooltip => 'Яна';

  @override
  String get nextMonthTooltip => 'Кейинги ой';

  @override
  String get nextPageTooltip => 'Кейинги саҳифа';

  @override
  String get okButtonLabel => 'OK';

  @override
  String get openAppDrawerTooltip => 'Навигация менюсини очиш';

  @override
  String get pageRowsInfoTitleRaw => r'$firstRow–$lastRow, жами: $rowCount';

  @override
  String get pageRowsInfoTitleApproximateRaw =>
      r'$firstRow–$lastRow, жами: $rowCount';

  @override
  String get pasteButtonLabel => 'Жойлаш';

  @override
  String get popupMenuLabel => 'Поп-ап менюси';

  @override
  String get postMeridiemAbbreviation => 'PM';

  @override
  String get previousMonthTooltip => 'Aввалги ой';

  @override
  String get previousPageTooltip => 'Aввалги саҳифа';

  @override
  String get refreshIndicatorSemanticLabel => 'Янгилаш';

  @override
  String? get remainingTextFieldCharacterCountFew => null;

  @override
  String? get remainingTextFieldCharacterCountMany => null;

  @override
  String? get remainingTextFieldCharacterCountOne => '1 та белги қолди';

  @override
  String get remainingTextFieldCharacterCountOther =>
      r'$remainingCount та белги қолди';

  @override
  String? get remainingTextFieldCharacterCountTwo => null;

  @override
  String? get remainingTextFieldCharacterCountZero => null;

  @override
  String get reorderItemDown => 'Пастга силжитиш';

  @override
  String get reorderItemLeft => 'Чапга силжитиш';

  @override
  String get reorderItemRight => 'Ўнгга силжитиш';

  @override
  String get reorderItemToEnd => 'Охирига силжитиш';

  @override
  String get reorderItemToStart => 'Бошига силжитиш';

  @override
  String get reorderItemUp => 'Тепага силжитиш';

  @override
  String get rowsPerPageTitle => 'Ҳар бир саҳифадаги қаторлар сони:';

  @override
  String get saveButtonLabel => 'Сақлаш';

  @override
  String get scanTextButtonLabel => 'Матнни сканерлаш';

  @override
  String get scrimLabel => 'Каноп';

  @override
  String get scrimOnTapHintRaw => r'Ёпиш: $modalRouteContentName';

  @override
  ScriptCategory get scriptCategory => ScriptCategory.englishLike;

  @override
  String get searchFieldLabel => 'Қидириш';

  @override
  String get selectAllButtonLabel => 'Ҳаммаси';

  @override
  String get selectYearSemanticsLabel => 'Йилни танланг';

  @override
  String? get selectedRowCountTitleFew => null;

  @override
  String? get selectedRowCountTitleMany => null;

  @override
  String? get selectedRowCountTitleOne => '1 та элемент танланди';

  @override
  String get selectedRowCountTitleOther =>
      r'$selectedRowCount та элемент танланди';

  @override
  String? get selectedRowCountTitleTwo => null;

  @override
  String? get selectedRowCountTitleZero => null;

  @override
  String get showAccountsLabel => 'Ҳисобларни кўрсатиш';

  @override
  String get showMenuTooltip => 'Менюни кўрсатиш';

  @override
  String get signedInLabel => 'Ҳисобингизга киргансиз';

  @override
  String get tabLabelRaw => r'$tabCount варақдан $tabIndex';

  @override
  TimeOfDayFormat get timeOfDayFormatRaw => TimeOfDayFormat.H_colon_mm;

  @override
  String get timePickerDialHelpText => 'Вақтни танланг';

  @override
  String get timePickerHourLabel => 'Соат';

  @override
  String get timePickerHourModeAnnouncement => 'Соатни танланг';

  @override
  String get timePickerInputHelpText => 'Вақтни киритинг';

  @override
  String get timePickerMinuteLabel => 'Дақиқа';

  @override
  String get timePickerMinuteModeAnnouncement => 'Дақиқани танланг';

  @override
  String get unspecifiedDate => 'Сана';

  @override
  String get unspecifiedDateRange => 'Сана оралиғи';

  @override
  String get viewLicensesButtonLabel => 'Лицензияларни кўриш';

  @override
  List<String> get narrowWeekdays =>
      const <String>['Й', 'Д', 'С', 'Ч', 'П', 'Ж', 'Ш'];

  @override
  int get firstDayOfWeekIndex => 0;

  @override
  String get lookUpButtonLabel => '';

  @override
  String get menuDismissLabel => '';

  @override
  String get searchWebButtonLabel => '';

  @override
  String get shareButtonLabel => '';

  static const LocalizationsDelegate<MaterialLocalizations> delegate =
  _CyrillicMaterialLocalizationsDelegate();

  @override
  String get clearButtonTooltip => '';

  @override
  String get selectedDateLabel => '';
}
