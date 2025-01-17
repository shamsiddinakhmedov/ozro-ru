part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AuthEmailChangeEvent extends AuthEvent {
  const AuthEmailChangeEvent(this.value);

  final String value;
}

class AuthPasswordChangeEvent extends AuthEvent {
  const AuthPasswordChangeEvent(this.value);

  final String value;
}

class AuthLoginEvent extends AuthEvent {
  const AuthLoginEvent();
}
