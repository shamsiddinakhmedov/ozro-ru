import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ozro_mobile/src/core/constants/constants.dart';
import 'package:ozro_mobile/src/core/either_dart/either.dart';
import 'package:ozro_mobile/src/core/platform/network_info.dart';
import 'package:ozro_mobile/src/data/models/auth/register_user_request.dart';
import 'package:ozro_mobile/src/data/models/auth/sign_in_response.dart';
import 'package:ozro_mobile/src/domain/network/failure.dart';
import 'package:ozro_mobile/src/domain/network/server_error.dart';

part 'auth_repository_impl.dart';

abstract class AuthRepository {
  const AuthRepository();

  Future<Either<Failure, SignInResponse>> confirmCode({
    required Map<String, dynamic> request,
  });

  Future<Either<Failure, bool>> forgotPassword({
    required Map<String, dynamic> request,
  });

  Future<Either<Failure, bool>> forgotPasswordCode({
    required Map<String, dynamic> request,
  });

  Future<Either<Failure, SignInResponse>> reSendCode({
    required Map<String, dynamic> request,
  });

  Future<Either<Failure, bool>> register({
    required RegisterUserRequest request,
  });

  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, bool>> deleteUser();

  Future<Either<Failure, SignInResponse>> login({
    required Map<String, dynamic> request,
  });

  Future<Either<Failure, UserResponse>> editProfile({required Map<String, dynamic> request});
}
