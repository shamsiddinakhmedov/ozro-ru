import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';

class BottomNavigationButton extends StatelessWidget {
  const BottomNavigationButton({
    super.key,
    required this.child,
    this.withBottomViewInsets = false,
  });

  final Widget child;
  final bool withBottomViewInsets;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: context.colorScheme.surface,
        child: SafeArea(
          minimum: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: 16 + (withBottomViewInsets ? MediaQuery.of(context).viewInsets.bottom : 0),
          ),
          child: child,
        ),
      );
}
