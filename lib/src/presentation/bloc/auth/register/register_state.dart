part of 'register_bloc.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.status = ApiStatus.initial,
    this.errorMessage = '',
    this.showNameError = false,
    this.showEmailError = false,
    this.showPasswordError = false,
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.fullName = '',
  });

  final ApiStatus status;
  final String errorMessage;
  final bool showNameError;
  final bool showEmailError;
  final bool showPasswordError;
  final String email;
  final String fullName;
  final String password;
  final String confirmPassword;

  RegisterState copyWith({
    ApiStatus? status,
    String? errorMessage,
    bool? showEmailError,
    bool? showPasswordError,
    String? email,
    String? password,
    String? confirmPassword,
    bool? showNameError,
    String? fullName,
  }) =>
      RegisterState(
        status: status ?? ApiStatus.initial,
        errorMessage: errorMessage ?? this.errorMessage,
        showEmailError: showEmailError ?? this.showEmailError,
        showPasswordError: showPasswordError ?? this.showPasswordError,
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        showNameError: showNameError ?? this.showNameError,
        fullName: fullName ?? this.fullName,
      );

  bool get validationSuccess =>
      !showNameError &&
      !showEmailError &&
      !showPasswordError &&
      fullName.trim().isNotEmpty &&
      email.trim().isNotEmpty &&
      password.trim().isNotEmpty &&
      confirmPassword.trim().isNotEmpty;

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        showEmailError,
        showPasswordError,
        email,
        password,
        confirmPassword,
        showNameError,
        fullName,
      ];
}
