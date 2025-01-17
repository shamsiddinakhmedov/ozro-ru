import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ozro_mobile/src/core/mixin/cache_mixin.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/auth/register_user_request.dart';
import 'package:ozro_mobile/src/data/models/enum_status.dart';
import 'package:ozro_mobile/src/domain/repositories/auth/auth_repository.dart';

part 'register_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> with CacheMixin {
  RegisterBloc({
    required this.authRepository,
  }) : super(const RegisterState()) {
    on<RegisterSubmitEvent>(_onUserRegister);
    on<RegisterNameChangedEvent>(_onNameChanged);
    on<RegisterEmailChangedEvent>(_onEmailChanged);
    on<RegisterPasswordChangeEvent>(_onPasswordChanged);
    on<RegisterConfirmPasswordChangeEvent>(_onConfirmPasswordChanged);
  }

  final AuthRepository authRepository;

  void _onNameChanged(
    RegisterNameChangedEvent event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(showNameError: false, fullName: event.value));
  }

  void _onEmailChanged(
    RegisterEmailChangedEvent event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(
        email: event.value,
        showEmailError: event.value.isNotEmpty ? emailValidator(event.value) : false,
      ),
    );
  }

  void _onPasswordChanged(
    RegisterPasswordChangeEvent event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(
        password: event.value,
        showPasswordError: event.value.isEmpty,
      ),
    );
  }

  void _onConfirmPasswordChanged(
    RegisterConfirmPasswordChangeEvent event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(
        confirmPassword: event.value,
        showPasswordError: event.value.isEmpty || event.value != state.password,
      ),
    );
  }

  /// user [_onUserRegister]
  Future<void> _onUserRegister(
    RegisterSubmitEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: ApiStatus.loading));
    final result = await authRepository.register(
      request: event.request,
    );
    await result.fold(
      (left) {
        emit(
          state.copyWith(
            status: ApiStatus.error,
            errorMessage: left.message,
          ),
        );
      },
      (right) async {
        emit(state.copyWith(status: ApiStatus.success));
      },
    );
  }
}
