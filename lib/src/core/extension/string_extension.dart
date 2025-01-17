import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

extension StringExtension on String? {
  // String get tr => AppLocalizations.instance.translate(this);

  bool notContains(String value) => !(this ?? '').contains(value);

  bool get isVideo => (this ?? '').contains('VIDEO');

  bool get isImage => (this ?? '').contains('IMAGE');

  String get emptyOr {
    if ((this ?? '').isNotEmpty) {
      return this!;
    } else {
      return '';
    }
  }


  void launchPhone() {
    if (this != null) {
      launchUrlString("tel:${this?.replaceAll(" ", "")}");
    }
  }

  void launchSms() {
    if (this != null) {
      launchUrlString("sms:${this?.replaceAll(" ", " ")}");
    }
  }

  void launchWebSite() {
    if (this != null) {
      launchUrlString('$this');
    }
  }

  void launchMail() {
    if (this != null) {
      final String email = Uri.encodeComponent('$this');
      launchUrlString(
        'mailto:$email',
        mode: LaunchMode.externalApplication,
      );
    }
  }

  void launchTelegram() {
    if (this != null) {
      launchUrlString(
        "https://t.me/${this?.replaceAll("t.me", "").replaceAll("@", "").replaceAll("https://", "")}",
        mode: LaunchMode.externalApplication,
      );
    }
  }

  void launchWhatsApp() {
    if (this != null) {
      launchUrlString(
        "https://wa.me/${this?.replaceAll(" ", "").replaceAll("https://", "").replaceAll("wa.me", "").replaceAll("@", "")}",
        mode: LaunchMode.externalApplication,
      );
    }
  }

  void launchTwitter() {
    if (this != null) {
      launchUrlString(
        "https://twitter.com/${this?.replaceAll(" ", "").replaceAll("https://", "").replaceAll("twitter.com", "").replaceAll("@", "")}",
        mode: LaunchMode.externalApplication,
      );
    }
  }

  void launchFacebook() {
    if (this != null) {
      launchUrlString(
        "https://www.facebook.com/${this?.replaceAll(" ", "").replaceAll("https://", "").replaceAll("www.facebook.com", "").replaceAll("@", "")}",
        mode: LaunchMode.externalApplication,
      );
    }
  }



  String? get getDate {
    if (this == null) return '';
    late String formattedStr;
    try {
      final DateTime date = DateFormat('yyyy-MM-ddTHH:mm:ssZ').parse(this ?? '');
      formattedStr = DateFormat('dd.MM.yyyy | HH:mm').format(date);
      // ? DateFormat('dd.MM.yyyy | HH:mm:ss').format(date)
      // : isFromMobile
      // ? DateFormat('dd.MM.yyyy | HH:mm').format(date)
      // : DateFormat('dd.MM.yyyy').format(date);
      return formattedStr;
    } on Exception {
      formattedStr = '';
    }
    return formattedStr;
  }

  String get getLocaleCode {
    switch (this) {
      case 'oz':
        return 'oz_UZ';
      case 'ru':
        return 'ru_RU';
      case 'uz':
        return 'uz_UZ';
      case 'en':
        return 'en_US';
      default:
        return '';
    }
  }

  String get capitalize => this != null
      ? (this?.length ?? 0) > 1
          ? '${this![0].toUpperCase()}${this!.substring(1)}'
          : this ?? ''
      : '';
}

extension Numeric on String {
  bool get isNumeric => num.tryParse(this) != null ? true : false;
}

extension PhoneDecorateExt on String {
  String get decoratePhoneNumber {
    if (isEmpty) return this;
    const Map<int, String?> phoneIndexes = {4: ' ', 7: ' ', 11: ' ', 14: ' '};
    return split('').reduce((value, element) => '$value${phoneIndexes[value.length] ?? ''}$element');
  }
}
