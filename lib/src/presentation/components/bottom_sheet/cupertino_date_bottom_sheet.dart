import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';

class CupertinoDatePickerBottomSheet extends StatefulWidget {
  const CupertinoDatePickerBottomSheet({
    super.key,
    this.initialDateTime,
    this.use24hFormat = true,
    this.mode = CupertinoDatePickerMode.dateAndTime,
    this.minimumDate,
    this.maximumDate,
    this.minuteInterval = 1,
  });

  final DateTime? initialDateTime;
  final bool use24hFormat;
  final CupertinoDatePickerMode mode;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final int minuteInterval;

  @override
  State<CupertinoDatePickerBottomSheet> createState() => _CupertinoDatePickerBottomSheetState();
}

class _CupertinoDatePickerBottomSheetState extends State<CupertinoDatePickerBottomSheet> {
  late DateTime dateTime;

  @override
  void initState() {
    dateTime = widget.initialDateTime ?? DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * .32,
            child: CupertinoDatePicker(
              initialDateTime: dateTime,
              mode: widget.mode,
              onDateTimeChanged: (value) {
                dateTime = value;
              },
              maximumDate: widget.maximumDate,
              minimumDate: widget.minimumDate,
              use24hFormat: widget.use24hFormat,
              minuteInterval: widget.minuteInterval,
            ),
          ),
          AppUtils.kSpacer,
          SafeArea(
            minimum: AppUtils.kPaddingAll16,
            child: ElevatedButton(
              onPressed: () {
                context.pop(dateTime);
              },
              child: const Text(
                'Продолжить',
              ),
            ),
          ),
        ],
      );
}
