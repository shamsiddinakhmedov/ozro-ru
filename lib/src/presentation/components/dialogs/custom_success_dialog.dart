import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';

Future showSuccessOrErrorDialog({
  required BuildContext context,
  String? title,
  bool isError = false,
}) async =>
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: CircleAvatar(
          radius: 40,
          backgroundColor: (isError ? colorLightScheme.error : colorLightScheme.primary).withOpacity(0.1),
          child: Center(
            child: Icon(
              isError ? Icons.error_outline : Icons.check_circle,
              color: isError ? colorLightScheme.error : colorLightScheme.primary,
              // size: 80,
            ),
          ),
        ),
        actions: [
          Text(
            title ?? '',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
