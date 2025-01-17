part of 'extension.dart';

extension ParseString on DateTime {
  String get formatDate => DateFormat('dd.MM.yyyy').format(this);

  String get formatDateTime => DateFormat(
        "yyyy-MM-dd'T'HH:mm:ss'Z'",

      ).format(this);

  String timeZone() {
    var date = toIso8601String().split('.')[0];
    if (timeZoneOffset.isNegative) {
      date += '-';
    } else {
      date += '+';
    }
    final timeZoneSplit = timeZoneOffset.toString().split(':');

    final hour = int.parse(timeZoneSplit[0]);
    if (hour < 10) {
      date += '0${timeZoneSplit[0]}';
    }
    date += ':${timeZoneSplit[1]}';
    return date;
  }

  int calculateMonthDifference(DateTime date) {
    final diff = difference(date);
    return diff.inDays;
  }
}

extension ParseExtension on String {
  String Function() get dateAndTime => () {
        if (isEmpty || DateTime.tryParse(this) == null) {
          return '';
        }
        final DateFormat inputFormat = DateFormat(
          'yyyy-MM-ddTHH:mm:ssZ',
          'ru_RU',
        );
        final DateTime datetime = inputFormat.parse(this);

        final DateFormat outputFormat = DateFormat(
          'dd.MM.yyyy | HH:mm',
          'ru_RU',
        );
        final String formattedDatetime = outputFormat.format(datetime);

        return formattedDatetime;
      };

  String Function() get date => () {
        if (isEmpty || DateTime.tryParse(this) == null) {
          return '';
        }
        final int duration = DateTime.now().hour - DateTime.now().toUtc().hour;
        final DateTime date = DateFormat(
          'yyyy-MM-ddTHH:mm:ssZ',
          'ru_RU',
        ).parse(this);
        return DateFormat(
          'dd.MM.yyyy',
          'ru_RU',
        ).format(
          date.add(Duration(hours: duration)),
        );
      };

  String get dateLikeDayMonthAndTime {
    if (isEmpty || DateTime.tryParse(this) == null) {
      return '';
    }
    // Define the date format
    final DateFormat dateFormat = DateFormat('d MMM, HH:mm', 'ru_RU');

    // Format the date
    return dateFormat.format(DateTime.parse(this));
  }

  String get dateTime {
    if (isEmpty || DateTime.tryParse(this) == null) {
      return '';
    }
    debugLog('get date ---> $this');
    final int duration = DateTime.now().hour - DateTime.now().toUtc().hour;
    debugLog('duration---> $duration');
    final DateTime date = DateFormat(
      'yyyy-MM-ddTHH:mm:ssZ',
      'ru_RU',
    ).parse(this);
    debugLog('result date --->${DateFormat('dd.MM.yyyy HH:mm', 'ru_RU').format(date.add(Duration(hours: duration)))}');
    return DateFormat('dd.MM.yyyy HH:mm', 'ru_RU').format(
      date.add(
        Duration(hours: duration),
      ),
    );
  }

  String dateTime1() {
    if (isEmpty || DateTime.tryParse(this) == null) {
      return '';
    }
    final int duration = DateTime.now().hour - DateTime.now().toUtc().hour;
    final DateTime date = DateFormat('yyyy-MM-ddTHH:mm:ssZ').parse(this);
    return DateFormat('dd.MM.yyyy').format(
      date.add(Duration(hours: duration)),
    );
  }

  String dateTime2() {
    if (isEmpty || DateTime.tryParse(this) == null) {
      return '';
    }
    final int duration = DateTime.now().hour - DateTime.now().toUtc().hour;
    final DateTime date = DateFormat('MM.dd.yyyy').parse(this);
    return DateFormat('yyyy-MM-dd').format(
      date.add(Duration(hours: duration)),
    );
  }

  String time1() {
    if (isEmpty || DateTime.tryParse(this) == null) {
      return '';
    }
    final int duration = DateTime.now().hour - DateTime.now().toUtc().hour;
    final DateTime date = DateFormat('HH:mm').parse(this);
    return DateFormat('HH:mm').format(
      date.add(Duration(hours: duration)),
    );
  }

  String time() {
    if (isEmpty || DateTime.tryParse(this) == null) {
      return '';
    }
    final int duration = DateTime.now().hour - DateTime.now().toUtc().hour;
    final DateTime date = DateFormat('yyyy-MM-ddTHH:mm:ssZ').parse(this);
    return DateFormat('HH:mm').format(
      date.add(Duration(hours: duration)),
    );
  }

  DateTime fromApiFormatToDateTime({bool isUtc = true}) {
    if (isEmpty || DateTime.tryParse(this) == null) {
      return DateTime.now();
    }
    int? duration;
    if (isUtc) {
      duration = DateTime.now().hour - DateTime.now().toUtc().hour;
    }
    final DateTime formattedDateTime = DateFormat('yyyy-MM-ddTHH:mm:ssZ', localSource.localeName).parse(this).add(
          Duration(
            hours: duration ?? 0,
          ),
        );
    return formattedDateTime;
  }

  String get htmlToText => Bidi.stripHtmlIfNeeded(this);
}
