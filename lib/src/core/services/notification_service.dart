import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ozro_mobile/firebase_options.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
InitializationSettings initializationSettings = const InitializationSettings(
  android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  iOS: DarwinInitializationSettings(),
);

sealed class NotificationService {
  const NotificationService._();

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      // final token = await FirebaseMessaging.instance.getToken();
      // log('FCM TOKEN: ---> $token');
      // log('FCM TOKEN: ---> ${localSource.getFCMToken()}');
      await setupFlutterNotifications();
      if (Platform.isAndroid) {
        foregroundNotification();
      }

      backgroundNotification();
      await terminateNotification();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } on Exception catch (e, s) {
      log('Firebase initialize error: $e $s');
    }
    try {
      await FirebaseMessaging.instance.getAPNSToken().then((token) => log('FCM TOKEN: $token'));
    } on Exception catch (e, s) {
      log('Firebase initialize error: $e $s');
    }
    // try {
    //   await FirebaseMessaging.instance.unsubscribeFromTopic('life1');
    //   await FirebaseMessaging.instance.unsubscribeFromTopic('life');
    //   // ignore: avoid_catches_without_on_clauses
    // } catch (e, s) {
    //   log('Firebase subscribe error: $e $s');
    // }
  }

  static Future<void> setupFlutterNotifications() async {
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission(
        announcement: true,
        badge: false
      );
    }

    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
    );
  }

  static Future<void> showFlutterNotification(RemoteMessage message, String fromWhere) async {
    final RemoteNotification? notification = message.notification;
    final String title = message.data['title'] ?? notification?.title ?? '';
    final String body = message.data['body'] ?? notification?.body ?? '';

    if (!kIsWeb) {
      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            styleInformation: BigTextStyleInformation(
              body,
              contentTitle: title,
            ),
            icon: '@mipmap/ic_launcher',
            priority: Priority.high,
            importance: Importance.max,
            visibility: NotificationVisibility.public,
            channelShowBadge: false,
            number: 0
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: false,
            presentSound: true,
            badgeNumber: 0,
            sound: 'default',
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
    // }
  }

  static void foregroundNotification() {
    FirebaseMessaging.onMessage.listen(
      (event) {
        showFlutterNotification(event, 'foregroundNotification');
      },
    );

    /// When tapped from Android device
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) async {
        debugPrint('response.payload ---- > ${response.payload}');
        // if(kDebugMode) chuck.showInspector();
      },
    );
  }

  static void backgroundNotification() {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        debugPrint('message.data');
        debugPrint(message.data.toString());
        if (rootNavigatorKey.currentContext == null) {
          return;
        }
        debugPrint('A new onMessageOpenedApp event was published!');
      },
    );
  }

  void cancelAllNotifications() {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> terminateNotification() async {
    final RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage == null) {
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } else {
      await showFlutterNotification(remoteMessage, 'terminateNotification');
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationService.setupFlutterNotifications();
  debugLog('_firebaseMessagingBackgroundHandler ----');
  await NotificationService.showFlutterNotification(message, '_firebaseMessagingBackgroundHandler');
}
//
// class GetMessageTitleBody {
//   const GetMessageTitleBody({
//     required this.title,
//     required this.body,
//   });
//
//   final String title;
//   final String body;
// }
//
// GetMessageTitleBody _getMessageTitleBodyForSpecificPlatform(RemoteMessage message) {
//   String? title;
//   String? body;
//   if (Platform.isIOS) {
//     title = message.notification?.title ?? message.data['title'] ?? '';
//     body = message.notification?.body ?? message.data['body'] ?? '';
//   } else {
//     title = message.data['title'] ?? message.notification?.title ?? '';
//     body = message.data['body'] ?? message.notification?.body ?? '';
//   }
//   return GetMessageTitleBody(
//     title: title ?? '',
//     body: body ?? '',
//   );
// }
