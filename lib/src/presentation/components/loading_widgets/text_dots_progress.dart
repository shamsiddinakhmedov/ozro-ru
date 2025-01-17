import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';

class TextDotsProgress extends StatefulWidget {
  const TextDotsProgress({
    super.key,
    required this.text,
    this.textStyle,
    this.duration = const Duration(milliseconds: 700),
  });

  final String text;
  final TextStyle? textStyle;
  final Duration duration;

  @override
  State<TextDotsProgress> createState() => _TextDotsProgressState();
}

class _TextDotsProgressState extends State<TextDotsProgress> {
  late Timer _timer;
  @override
  void initState() {
    _timer = Timer.periodic(widget.duration, (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text(
        '${widget.text}${'.' * (_timer.tick % 4)}${' ' * (3 - (_timer.tick % 4))}',
        style: widget.textStyle ?? context.textStyle.regularFootnote,
      );
}
