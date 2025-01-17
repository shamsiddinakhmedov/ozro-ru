// import 'package:appmetrica_plugin/appmetrica_plugin.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:ozro_mobile/src/core/utils/utils.dart';
//
// class AnalyticService {
//   factory AnalyticService() => _instance;
//
//   AnalyticService._internal();
//
//   static final AnalyticService _instance = AnalyticService._internal();
//
//   static Future<void> sendAnalyticsEvent({required String tag, Map<String, Object>? parameters}) async {
//     try {
//       await AppMetrica.reportEventWithMap(tag, parameters?.cast<String, Object>());
//       await FirebaseAnalytics.instance.logEvent(name: tag, parameters: parameters);
//       debugLog('sentAnalyticsEvent, tag:$tag');
//       debugLog('sentAnalyticsEvent, parameters:$parameters');
//     } on Exception catch (e) {
//       debugLog('sentAnalyticsEvent, error: ${e.toString()}');
//     }
//   }
// }
//
// class AnalyticServiceParams {
//   AnalyticServiceParams._();
//
//   static Map<String, Object> pageNameParam(String pageName) => {
//         'page_name': pageName,
//       };
//
//   static Map<String, Object> typeParam(String type) => {
//         'type': type,
//       };
// }
