// import 'package:flutter/material.dart';
// import 'package:screen_protector/screen_protector.dart';
//
// mixin ScreenshotMixin{
//   Future<void> preventScreenshotOn() async => ScreenProtector.preventScreenshotOn();
//
//   Future<void> preventScreenshotOff() async => ScreenProtector.preventScreenshotOff();
//
//   Future<void> addListenerPreventScreenshot(BuildContext context) async {
//     ScreenProtector.addListener(() {
//       // Screenshot
//       debugPrint('Screenshot:');
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Screenshot!'),
//       ));
//     }, (isCaptured) {
//       // Screen Record
//       debugPrint('Screen Record:');
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Screen Record!'),
//       ));
//     });
//   }
//
//   Future<void> removeListenerPreventScreenshot() async {
//     ScreenProtector.removeListener();
//   }
// }