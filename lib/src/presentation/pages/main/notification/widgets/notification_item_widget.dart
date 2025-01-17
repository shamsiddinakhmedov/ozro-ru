import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/main/notifications/notifications_response.dart';
import 'package:ozro_mobile/src/presentation/bloc/main/notification/notification_bloc.dart';

class NotificationItemWidget extends StatefulWidget {
  const NotificationItemWidget({
    super.key,
    this.data
  });

  final GetNotificationsResponse? data;

  @override
  State<NotificationItemWidget> createState() => _NotificationItemWidgetState();
}

class _NotificationItemWidgetState extends State<NotificationItemWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => InkWell(
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    hoverColor: Colors.transparent,
    focusColor: Colors.transparent,
    onTap: () {
      setState(() {
        widget.data?.isRead = true;
        context.read<NotificationBloc>().add(GetReadNotificationEvent(widget.data?.id ?? 0));
      });
    },
    child: Container(
      padding: AppUtils.kPaddingAll16,
      margin: AppUtils.kPaddingHor16Bottom12,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppUtils.kBorderRadius12,
        border: Border.all(color: widget.data?.isRead ?? true ? Colors.transparent : Colors.blue)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.data?.title ?? '',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(10),
          Text(
            widget.data?.body ?? '',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xff252C32)
            ),
          ),
          const Gap(10),
          Text(
            DateFormat('MMMM dd hh:MM').format(DateTime.parse(widget.data?.createdAt ?? '')),
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(0.4)
            ),
          )
        ],
      ),
    ),
  );
}