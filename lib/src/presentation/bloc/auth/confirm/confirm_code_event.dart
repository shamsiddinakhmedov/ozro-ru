part of 'confirm_code_bloc.dart';

abstract class ConfirmCodeEvent extends Equatable {
  const ConfirmCodeEvent();
}

class ConfirmCodeEventInitial extends ConfirmCodeEvent {
  const ConfirmCodeEventInitial();

  @override
  List<Object?> get props => [];
}

class ConfirmCodePhoneChangeEvent extends ConfirmCodeEvent {
  const ConfirmCodePhoneChangeEvent(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class ConfirmCodeCheckMessageEvent extends ConfirmCodeEvent {
  const ConfirmCodeCheckMessageEvent({
    required this.otp,
    required this.email,
  });

  final String otp;
  final String email;

  @override
  List<Object?> get props => [
        otp,
        email,
      ];
}

class ConfirmCodeSubmitPasswordAndCodeEvent extends ConfirmCodeEvent {
  const ConfirmCodeSubmitPasswordAndCodeEvent({
    required this.otp,
    required this.email,
    required this.password,
  });

  final String otp;
  final String password;
  final String email;

  @override
  List<Object?> get props => [
        otp,
        email,
      ];
}

class ConfirmCodeSendAgainEvent extends ConfirmCodeEvent {
  const ConfirmCodeSendAgainEvent(this.email);

  final String email;

  @override
  List<Object?> get props => [];
}
