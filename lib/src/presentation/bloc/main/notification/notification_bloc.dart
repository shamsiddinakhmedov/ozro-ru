import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ozro_mobile/src/core/either_dart/future_extension.dart';
import 'package:ozro_mobile/src/data/models/enum_status.dart';
import 'package:ozro_mobile/src/data/models/main/notifications/notifications_response.dart';
import 'package:ozro_mobile/src/domain/repositories/main/main_repository.dart';

part 'notification_event.dart';

part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc(this.mainRepository) : super(const NotificationState()) {
    on<GetNotificationEvent>(_getNotification);
    on<GetReadNotificationEvent>(_getReadNotification);
  }

  final MainRepository mainRepository;

  Future<void> _getNotification(
    NotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(status: ApiStatus.loading));
    final result = mainRepository.getNotifications();
    await result.fold(
      (left) {
        emit(state.copyWith(status: ApiStatus.error));
      },
      (right) {
        emit(state.copyWith(status: ApiStatus.success, dataNotification: right));
      },
    );
  }

  Future<void> _getReadNotification(
      GetReadNotificationEvent event,
      Emitter<NotificationState> emit,
      ) async {
    emit(state.copyWith(status: ApiStatus.loading));
    final result = mainRepository.readNotification(id: event.id);
    await result.fold(
          (left) {
            emit(state.copyWith(status: ApiStatus.error));
          },
          (right) {
            emit(state.copyWith(status: ApiStatus.success));
          },
    );
  }
}
