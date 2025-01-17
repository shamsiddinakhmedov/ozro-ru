part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState({
    this.email = '',
    this.password = '',
    this.isUserFound = false,
    this.status = ApiStatus.initial,
    this.errorMessage = '',
    this.showEmailError = false,
    this.showPasswordError = false,
  });

  final String email;
  final String password;
  final bool isUserFound;
  final ApiStatus status;
  final String errorMessage;
  final bool showEmailError;
  final bool showPasswordError;

  AuthState copyWith({
    String? email,
    String? password,
    bool? isUserFound,
    ApiStatus? status,
    String? errorMessage,
    bool? showEmailError,
    bool? showPasswordError,
  }) =>
      AuthState(
        email: email ?? this.email,
        password: password ?? this.password,
        isUserFound: isUserFound ?? this.isUserFound,
        status: status ?? ApiStatus.initial,
        errorMessage: errorMessage ?? this.errorMessage,
        showEmailError: showEmailError ?? this.showEmailError,
        showPasswordError: showPasswordError ?? this.showPasswordError,
      );

  bool get validationSuccess => !showEmailError && !showPasswordError && email.isNotEmpty && password.isNotEmpty;

  @override
  List<Object?> get props => [
        email,
        isUserFound,
        status,
        errorMessage,
        showEmailError,
        showPasswordError,
        password,
      ];
}
