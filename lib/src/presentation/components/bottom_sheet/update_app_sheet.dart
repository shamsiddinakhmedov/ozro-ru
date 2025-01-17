import 'package:flutter/material.dart';

import '../../../core/utils/utils.dart';

class AppUpdateBottomSheetWidget extends StatelessWidget {
  const AppUpdateBottomSheetWidget({
    super.key,
    this.onTap,
    required this.isForceUpdate,
  });

  final bool isForceUpdate;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        child: SafeArea(
          minimum: AppUtils.kPaddingAll16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Новая версия',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              const Text(
                'Доступна новая версия приложения',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (!isForceUpdate)
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Остаться на этой версии'),
                ),
              if (!isForceUpdate) const SizedBox(height: 8),
              ElevatedButton(
                onPressed: onTap,
                child: const Text('Обновить'),
              ),
            ],
          ),
        ),
      );
}
