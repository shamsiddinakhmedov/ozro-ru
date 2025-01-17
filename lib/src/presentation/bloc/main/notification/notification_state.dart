part of 'notification_bloc.dart';

final class NotificationState extends Equatable {
  const NotificationState({this.status = ApiStatus.initial, this.dataNotification});

  final ApiStatus status;
  final List<GetNotificationsResponse>? dataNotification;

  NotificationState copyWith({
    ApiStatus? status,
    List<GetNotificationsResponse>? dataNotification
  }) => NotificationState(
      status: status ?? this.status,
      dataNotification: dataNotification ?? this.dataNotification
  );

  @override
  List<Object?> get props => [ status, dataNotification ];
}
