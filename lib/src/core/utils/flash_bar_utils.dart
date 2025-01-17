import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';

Future<bool?> showFlashError({
  required BuildContext context,
  String? title,
  required String content,
  FlashPosition position = FlashPosition.bottom,
}) =>
    context.showFlash<bool>(
      barrierDismissible: true,
      duration: const Duration(seconds: 4),
      builder: (_, controller) => FlashBar(
        position: position,
        controller: controller,
        behavior: FlashBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppUtils.kBorderRadius16,
          side: BorderSide(
            color: context.colorScheme.error.withOpacity(0.6),
          ),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 60,
        ),
        clipBehavior: Clip.antiAlias,
        indicatorColor: context.colorScheme.error,
        backgroundColor: context.colorScheme.error.withOpacity(0.9),
        icon: Icon(
          Icons.tips_and_updates_outlined,
          color: context.colorScheme.onError,
        ),
        title: Text(
          title ?? 'Ошибка',
          style: context.textStyle.bodyCaption1.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: context.colorScheme.onError,
          ),
        ),
        content: Text(
          content,
          style: context.textStyle.bodyCaption1.copyWith(
            fontSize: 13,
            color: context.colorScheme.onError,
          ),
        ),
      ),
    );

Future<bool?> showFlashWarning({
  required BuildContext context,
  String? title,
  required String content,
  FlashPosition position = FlashPosition.bottom,
  int? durationInSeconds,
}) =>
    context.showFlash<bool>(
      barrierDismissible: true,
      duration: Duration(seconds: durationInSeconds ?? 4),
      builder: (_, controller) => FlashBar(
        position: position,
        controller: controller,
        behavior: FlashBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppUtils.kBorderRadius16,
          side: BorderSide(
            color: context.color.orange.withOpacity(0.6),
          ),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 60,
        ),
        clipBehavior: Clip.antiAlias,
        indicatorColor: context.color.orange,
        backgroundColor: const Color.fromRGBO(252, 238, 199, 1),
        icon: Icon(
          Icons.tips_and_updates_outlined,
          color: context.color.orange,
        ),
        title: Text(
          title ?? 'Внимание',
          style: context.textStyle.bodyCaption1.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        content: Text(
          content,
          style: context.textStyle.bodyCaption1.copyWith(fontSize: 13),
        ),
      ),
    );
