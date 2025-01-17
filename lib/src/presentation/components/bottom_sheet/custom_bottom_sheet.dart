import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';

Future<T?> customCupertinoModalPopup<T>(
  BuildContext context, {
  String title = '',
  String actionTitleOne = '',
  String actionTitleTwo = '',
  required void Function() actionOne,
  required void Function() actionTwo,
}) async =>
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: Text(title),
        actions: [
          CupertinoActionSheetAction(
            onPressed: actionOne,
            child: Text(actionTitleOne),
          ),
          CupertinoActionSheetAction(
            onPressed: actionTwo,
            child: Text(actionTitleTwo),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Отмена'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );

typedef WidgetScrollBuilder = Widget Function(
  BuildContext context,
  ScrollController? controller,
);

Future<T?> customModalBottomSheet<T>({
  required BuildContext context,
  required WidgetScrollBuilder builder,
  bool isScrollControlled = false,
  bool shouldCloseOnMinExtent = true,
  double maxHeight = 0.9,
  double minHeight = 0.2,
  bool enableDrag = true,
  double initialChildSize = 1,
  bool isDismissible = true,
  Color? barrierColor,
  Color? backgroundColor,
  ShapeBorder? shape,
}) async =>
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      barrierColor: barrierColor,
      backgroundColor: backgroundColor,
      shape: shape,
      constraints: BoxConstraints(
        maxHeight: context.kSize.height * maxHeight,
        minHeight: context.kSize.height * minHeight,
      ),
      builder: (_) {
        if (isScrollControlled) {
          return DraggableScrollableSheet(
            shouldCloseOnMinExtent: shouldCloseOnMinExtent,
            initialChildSize: initialChildSize,
            minChildSize: 0.5,
            expand: false,
            snap: true,
            builder: (context, controller) => builder(context, controller),
          );
        } else {
          return builder(context, null);
        }
      },
    );
