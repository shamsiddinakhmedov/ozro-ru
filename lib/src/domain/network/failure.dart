import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({required this.message, this.statusCode});

  final String message;
  final int? statusCode;
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

class NoInternetFailure extends Failure {
  const NoInternetFailure({required super.message, super.statusCode});

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.statusCode});

  @override
  List<Object?> get props => [message];
}
