part of 'utils.dart';

final String defaultSystemLocale = Platform.localeName.split('_').first;

String get defaultLocale => 'ru';
// switch (defaultSystemLocale) {
//   'ru' => 'ru',
//   'en' => 'en',
//   'uz' => 'uz',
//   _ => 'ru',
// };

String get defaultTheme => SchedulerBinding.instance.platformDispatcher.platformBrightness.name;

String phoneFormat(String phone) {
  if (phone.length >= 13) {
    String t = phone;
    t = t.replaceAll('+998', '');
    t = '${t.substring(0, 2)} ${t.substring(2, 5)} ${t.substring(5, 7)} ${t.substring(7, 9)}';
    return '+998 $t';
  } else {
    return phone;
  }
}

String getLocaleText({
  required String? uz,
  required String? oz,
  required String? ru,
  required String? en,
}) {
  switch (localSource.locale) {
    case 'en':
      return en ?? '';
    case 'ru':
      return ru ?? '';
    case 'uz':
      return uz ?? '';
    case 'oz':
      return oz ?? '';
    default:
      return uz ?? '';
  }
}

String getRate(num? rate) {
  final ratingList = (rate ?? 0).toString().split('.');
  final rateFirstCount = ratingList.firstOrNull ?? '0';
  String rateSecondCount = '0';
  if (ratingList.length == 1) {
    return rateFirstCount;
  }
  if ((ratingList.lastOrNull?.length ?? 0) >= 2) {
    rateSecondCount = ratingList.lastOrNull?.substring(0, 1) ?? '0';
  } else if ((ratingList.lastOrNull?.length ?? 0) == 1) {
    rateSecondCount = ratingList.lastOrNull ?? '0';
  }

  return '$rateFirstCount.$rateSecondCount';
}

void debugLog(
  Object? message, {
  bool withEmptySpace = false,
}) {
  if (kDebugMode) {
    if (withEmptySpace) print('\n====   ====    == START ==    ====    ====');
    print('$message');
    if (withEmptySpace) print('\n====   ====    == END ==    ====    ====');
  }
}

void beforeLog(Object? message) {
  if (kDebugMode) {
    print('\n====   ====    == BEFORE ==    ====    ====');
    print('$message');
  }
}

void afterLog(Object? message) {
  if (kDebugMode) {
    print('\n====   ====    == AFTER ==    ====    ====');
    print('$message');
  }
}

bool emailValidator(String value) => !RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(value);

// Future<List<int>> downloadFile(String fileUrl, String fileName) async {
//   try {
//     debugLog('downloading file: $fileUrl, $fileName');
//     final dir = await getApplicationDocumentsDirectory();
//     final filePath = '${dir.path}/$fileName';
//     final response = await http.get(Uri.parse(fileUrl));
//     final bytes = response.bodyBytes;
//     final file = File(filePath);
//     await file.writeAsBytes(bytes);
//     debugLog('result file path: $filePath');
//     return bytes;
//     // ignore: avoid_catches_without_on_clauses
//   } catch (e, s) {
//     debugLog('download file error: $e, $s');
//     return [];
//   }
// }
MediaType getMediaType(File file) {
  final String type = file.path.split('.').last;

  return MediaType(
    switch (type) {
      'jpg' => 'image',
      'png' => 'image',
      'jpeg' => 'image',
      'pdf' => 'application',
      'mp3' => 'audio',
      'm4a' => 'audio',
      'mp4' => 'video',
      'ogg' => 'audio',
      _ => '',
    },
    type,
  );
}
