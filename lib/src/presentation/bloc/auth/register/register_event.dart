part of 'register_bloc.dart';

abstract class RegisterEvent {
  const RegisterEvent();
}

class RegisterNameChangedEvent extends RegisterEvent {
  const RegisterNameChangedEvent(this.value);

  final String value;
}

class RegisterEmailChangedEvent extends RegisterEvent {
  const RegisterEmailChangedEvent(this.value);

  final String value;
}

class RegisterPasswordChangeEvent extends RegisterEvent {
  const RegisterPasswordChangeEvent(this.value);

  final String value;
}

class RegisterConfirmPasswordChangeEvent extends RegisterEvent {
  const RegisterConfirmPasswordChangeEvent(this.value);

  final String value;
}

class RegisterSubmitEvent extends RegisterEvent {
  const RegisterSubmitEvent({
    required this.request,
  });

  final RegisterUserRequest request;
}
