part of 'confirm_code_bloc.dart';

class ConfirmCodeState extends Equatable {
  const ConfirmCodeState({
    this.isReverseSendCode = false,
    this.status = ApiStatus.initial,
    this.errorMessage = '',
  });

  final bool isReverseSendCode;
  final ApiStatus status;
  final String errorMessage;


  ConfirmCodeState copyWith({
    bool? isReverseSendCode,
    ApiStatus? status,
    String? errorMessage,
  }) =>
      ConfirmCodeState(
        isReverseSendCode: isReverseSendCode ?? this.isReverseSendCode,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        isReverseSendCode,
      ];
}
