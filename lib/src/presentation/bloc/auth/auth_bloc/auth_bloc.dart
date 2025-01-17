import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/enum_status.dart';
import 'package:ozro_mobile/src/domain/repositories/auth/auth_repository.dart';

part 'auth_state.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    AuthRepository authRepository,
  )   : _authRepository = authRepository,
        super(const AuthState()) {
    on<AuthEmailChangeEvent>(_onEmailChange);
    on<AuthPasswordChangeEvent>(_onPasswordChange);
    on<AuthLoginEvent>(_onLogin);
  }

  final AuthRepository _authRepository;


  void _onEmailChange(
    AuthEmailChangeEvent event,
    Emitter<AuthState> emit,
  ) {
    debugLog('email change: ${event.value}');
    debugLog('email validator: ${emailValidator(event.value)}');
    emit(
      state.copyWith(
        email: event.value,
        showEmailError: emailValidator(event.value),
      ),
    );
  }

  void _onPasswordChange(
    AuthPasswordChangeEvent event,
    Emitter<AuthState> emit,
  ) =>
      emit(
        state.copyWith(
          password: event.value,
          showPasswordError: event.value.isEmpty,
        ),
      );

  Future<void> _onLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: ApiStatus.loading));

    final result = await _authRepository.login(request: {
      'email': state.email,
      'password': state.password,
      'fcm_token': localSource.getFCMToken(),
      'device_id': localSource.getDeviceId(),
      'device_type': null
    });
    result.fold(
      (left) {
        emit(
          state.copyWith(
            status: ApiStatus.error,
            errorMessage: left.message,
            isUserFound: false,
          ),
        );
      },
      (right) {
        final user = right.user;
        localSource.setUser(
          imageUrl: user?.profilePhoto,
          accessToken: right.token,
          name: user?.fullName,
          email: user?.email,
        );
        emit(
          state.copyWith(
            status: ApiStatus.success,
            isUserFound: true,
          ),
        );
      },
    );
  }
}
