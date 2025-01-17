import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';

class LogOutDialog extends StatelessWidget {
  const LogOutDialog({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Dialog(
        insetPadding: AppUtils.kPaddingAll24,
        shape: AppUtils.kShapeRoundedAll16,
        child: Padding(
          padding: AppUtils.kPaddingAll16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Выйти',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Padding(
                padding: AppUtils.kPaddingVertical12,
                child: Text(
                  'Вы хотите выйти',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: const WidgetStatePropertyAll(
                            Color(0xffF1F1F1),
                          ),
                          foregroundColor: WidgetStatePropertyAll(context.color.black),
                        ),
                        onPressed: () async {
                          context.pop();
                        },
                        child: const Text('Нет'),
                      ),
                    ),
                    AppUtils.kGap12,
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onPressed,
                        child: const Text(
                          'Да',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
