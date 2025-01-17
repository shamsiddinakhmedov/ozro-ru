// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/connectivity/internet_connection_checker.dart';
import 'package:ozro_mobile/src/core/platform/network_info.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/injector_container.dart';

class InternetConnectionPage extends StatefulWidget {
  const InternetConnectionPage({super.key});

  @override
  InternetConnectionPageState createState() => InternetConnectionPageState();
}

class InternetConnectionPageState extends State<InternetConnectionPage> {
  late NetworkInfo networkInfo;
  late StreamSubscription<InternetConnectionStatus> listener;

  @override
  void initState() {
    super.initState();
    networkInfo = sl<NetworkInfo>();
    listener = networkInfo.onStatusChange.listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(InternetConnectionStatus status) async {
    switch (status) {
      case InternetConnectionStatus.connected:
        Navigator.of(context).pop();
      case InternetConnectionStatus.disconnected:
        break;
    }
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(36),
              //   child: Image.asset(
              //     // 'https://static.vecteezy.com/system/resources/previews/002/737/785/original/no-internet-connection-illustration-concept-free-vector.jpg',
              //     Assets.pngNoInternet,
              //     fit: BoxFit.fitWidth,
              //   ),
              // ),
              Text(
                'Нет доступа в Интернет',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Проверьте подключение к Интернету',
                style: TextStyle(
                  color: Color(0xff818C99),
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            minimum: AppUtils.kPaddingAll16,
            child: ElevatedButton(
              child: const Text('Попробуйте еще раз'),
              onPressed: () async {
                // await Future<void>.delayed(const Duration(milliseconds: 300));
                final isConnected = await networkInfo.isConnected;
                if (isConnected) {
                  // if (!mounted) return;
                  // Navigator.of(context).pop();
                }
              },
            ),
          ),
        ),
      );
}
