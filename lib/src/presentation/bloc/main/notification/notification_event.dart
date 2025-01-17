part of 'notification_bloc.dart';

abstract class NotificationEvent {
  const NotificationEvent();
}

class GetNotificationEvent extends NotificationEvent {
  const GetNotificationEvent();
}

class GetReadNotificationEvent extends NotificationEvent {
  const GetReadNotificationEvent(this.id);
  final int id;
  List<Object?> get props => [ id ];
}