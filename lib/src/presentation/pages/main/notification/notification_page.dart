import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/presentation/bloc/main/notification/notification_bloc.dart';

import 'widgets/notification_item_widget.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(const GetNotificationEvent());
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<NotificationBloc, NotificationState>(
    buildWhen: (previous, current) => previous.dataNotification != current.dataNotification,
    builder: (_, state) => Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(title: const Text('Уведомление')),
      body: SafeArea(
        child: state.dataNotification?.isNotEmpty ?? true
            ? ListView.separated(
                separatorBuilder: (_, __) => AppUtils.kGap,
                itemCount: state.dataNotification?.length ?? 0,
                padding: AppUtils.kPaddingTop16,
                itemBuilder: (_, index) => NotificationItemWidget(data: state.dataNotification?[index]),
              )
            : const Center(
                child: SizedBox(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Уведомлений нет',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      Gap(12),
                      Text(
                        'На данный момент у вас нет уведомлений.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          color: Color(0xff828F89)
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    )
  );
}
