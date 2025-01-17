import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer? _timer;
  late String _timerText = '01:00';
  late int secondsRemaining = 60;
  late bool reverseSendCode = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (secondsRemaining == 0) {
          setState(() {
            reverseSendCode = true;
          });
        } else {
          secondsRemaining--;
          setState(() {
            _timerText = "00:${secondsRemaining.toString().padLeft(2, '0')}";
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (reverseSendCode) {
      return GestureDetector(
        onTap: () {
          widget.onTap();
          reverseSendCode = false;
          secondsRemaining = 60;
          _timerText = '01:00';
        },
        child: Text(
          'Отправить еще раз',
          style: context.textStyle.regularSubheadline.copyWith(
            color: context.colorScheme.primary,
          ),
        ),
      );
    }
    return Text(
      _timerText,
      style: context.textStyle.regularSubheadline,
    );
  }
}
