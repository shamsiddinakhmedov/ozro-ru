// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomWillPopScope extends StatelessWidget {
  const CustomWillPopScope({
    super.key,
    this.isHaveWillPopScope = true,
    required this.onWillPop,
    required this.child,
  });

  final bool isHaveWillPopScope;
  final WillPopCallback onWillPop;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (isHaveWillPopScope) {
      return WillPopScope(
        onWillPop: onWillPop,
        child: child,
      );
    } else {
      return child;
    }
  }
}
