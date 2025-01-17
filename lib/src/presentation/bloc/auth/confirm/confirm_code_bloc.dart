import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/mixin/cache_mixin.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/enum_status.dart';
import 'package:ozro_mobile/src/domain/repositories/auth/auth_repository.dart';

part 'confirm_code_event.dart';

part 'confirm_code_state.dart';

class ConfirmCodeBloc extends Bloc<ConfirmCodeEvent, ConfirmCodeState> with CacheMixin {
  ConfirmCodeBloc({
    required this.authRepository,
  }) : super(const ConfirmCodeState()) {
    on<ConfirmCodeCheckMessageEvent>(_onConfirmCode);
    on<ConfirmCodeSubmitPasswordAndCodeEvent>(_onConfirmCodeSubmitPasswordAndCode);
    on<ConfirmCodeSendAgainEvent>(_onSendAgain);
  }

  final AuthRepository authRepository;

  Future<void> _onConfirmCode(
    ConfirmCodeCheckMessageEvent event,
    Emitter<ConfirmCodeState> emit,
  ) async {
    emit(state.copyWith(status: ApiStatus.loading));
    final result = await authRepository.confirmCode(
      request: {
        'email': event.email,
        'code': event.otp,
        'fcm_token': localSource.getFCMToken(),
        'device_id': localSource.getDeviceId(),
        'device_type': null
      },
    );
    await result.fold(
      (l) async {
        debugLog('message error: ${l.message}');
        emit(
          state.copyWith(
            errorMessage: l.message,
            status: ApiStatus.error,
          ),
        );
        await Future<void>.delayed(const Duration(seconds: 1));
        emit(state.copyWith(status: ApiStatus.initial));
      },
      (r) async {
        await localSource.setUser(
          name: r.user?.fullName ?? '',
          email: r.user?.email ?? '',
          accessToken: r.token ?? '',
          imageUrl: r.user?.profilePhoto ?? '',
        );
        emit(state.copyWith(
          status: ApiStatus.success,
        ));
      },
    );
  }

  Future<void> _onConfirmCodeSubmitPasswordAndCode(
    ConfirmCodeSubmitPasswordAndCodeEvent event,
    Emitter<ConfirmCodeState> emit,
  ) async {
    emit(state.copyWith(status: ApiStatus.loading));
    final result = await authRepository.forgotPassword(
      request: {
        'email': event.email,
        'password': event.password,
        're_password': event.password,
        'code': event.otp,
      },
    );
    await result.fold(
      (l) async {
        debugLog('message error: ${l.message}');
        emit(state.copyWith(
          errorMessage: l.message,
          status: ApiStatus.error,
        ));
        await Future<void>.delayed(const Duration(seconds: 1));
        emit(state.copyWith(status: ApiStatus.initial));
      },
      (r) async {
        emit(state.copyWith(status: ApiStatus.success));
      },
    );
  }

  Future<void> _onSendAgain(ConfirmCodeSendAgainEvent event, Emitter<ConfirmCodeState> emit) async {
    final result = await authRepository.reSendCode(
      request: {
        'email': event.email,
      },
    );
    result.fold(
      (l) {
        emit(state.copyWith(
          status: ApiStatus.error,
          errorMessage: l.message,
        ));
      },
      (r) {
        emit(
          state.copyWith(
            isReverseSendCode: true,
          ),
        );
      },
    );
  }
}
