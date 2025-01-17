part of 'auth_repository.dart';

final class AuthRepositoryImpl extends AuthRepository {
  const AuthRepositoryImpl({
    required this.networkInfo,
    required this.dio,
  }) : super();

  final Dio dio;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, SignInResponse>> confirmCode({
    required Map<String, dynamic> request,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final Response response = await dio.post(Urls.confirmation, data: request);
        return Right(SignInResponse.fromJson(response.data));
      } on DioException catch (error, stacktrace) {
        log('Exception occurred: $error stacktrace: $stacktrace');
        return Left(ServerError.withDioError(error: error).failure);
      } on Exception catch (error, stacktrace) {
        log('Exception occurred: $error stacktrace: $stacktrace');
        return Left(ServerError.withError(message: error.toString()).failure);
      }
    } else {
      return const Left(ServerFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> register({
    required RegisterUserRequest request,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await dio.post<void>(Urls.register, data: request.toJson());
        return const Right(true);
      } on DioException catch (error, stacktrace) {
        log('Exception occurred: $error stacktrace: $stacktrace');
        return Left(ServerError.withDioError(error: error).failure);
      } on Exception catch (error, stacktrace) {
        log('Exception occurred: $error stacktrace: $stacktrace');
        return Left(ServerError.withError(message: error.toString()).failure);
      }
    } else {
      return const Left(ServerFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await dio.delete<void>(Urls.logout);
      return const Right(true);
    } on DioException catch (error) {
      return Left(ServerError.withDioError(error: error).failure);
    } on Exception catch (error) {
      return Left(ServerError.withError(message: error.toString()).failure);
    }
  }

  @override
  Future<Either<Failure, bool>> deleteUser() async {
    try {
      await dio.delete<void>(Urls.user);
      return const Right(true);
    } on DioException catch (error) {
      return Left(ServerError.withDioError(error: error).failure);
    } on Exception catch (error) {
      return Left(ServerError.withError(message: error.toString()).failure);
    }
  }

  @override
  Future<Either<Failure, SignInResponse>> login({required Map<String, dynamic> request}) async {
    try {
      final Response response = await dio.post(Urls.login, data: request);

      return Right(SignInResponse.fromJson(response.data));
    } on DioException catch (error) {
      return Left(ServerError.withDioError(error: error).failure);
    } on Exception catch (error) {
      return Left(ServerError.withError(message: error.toString()).failure);
    }
  }

  @override
  Future<Either<Failure, SignInResponse>> reSendCode({required Map<String, dynamic> request}) async {
    try {
      final Response response = await dio.post(Urls.resendCode, data: request);

      return Right(SignInResponse.fromJson(response.data));
    } on DioException catch (error) {
      return Left(ServerError.withDioError(error: error).failure);
    } on Exception catch (error) {
      return Left(ServerError.withError(message: error.toString()).failure);
    }
  }

  @override
  Future<Either<Failure, UserResponse>> editProfile({required Map<String, dynamic> request}) async {
    try {
      final Response response = await dio.put(Urls.user, data: FormData.fromMap(request));

      return Right(UserResponse.fromJson(response.data));
    } on DioException catch (error) {
      return Left(ServerError.withDioError(error: error).failure);
    } on Exception catch (error) {
      return Left(ServerError.withError(message: error.toString()).failure);
    }
  }

  @override
  Future<Either<Failure, bool>> forgotPassword({required Map<String, dynamic> request}) async {
    if (await networkInfo.isConnected) {
      try {
        await dio.post<void>(Urls.forgotPassword, data: request);
        return const Right(true);
      } on DioException catch (error, stacktrace) {
        log('Exception occurred: $error stacktrace: $stacktrace');
        return Left(ServerError.withDioError(error: error).failure);
      } on Exception catch (error, stacktrace) {
        log('Exception occurred: $error stacktrace: $stacktrace');
        return Left(ServerError.withError(message: error.toString()).failure);
      }
    } else {
      return const Left(ServerFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> forgotPasswordCode({required Map<String, dynamic> request}) async {
    if (await networkInfo.isConnected) {
      try {
        await dio.post<void>(Urls.forgotPasswordCode, data: request);
        return const Right(true);
      } on DioException catch (error, stacktrace) {
        log('Exception occurred: $error stacktrace: $stacktrace');
        return Left(ServerError.withDioError(error: error).failure);
      } on Exception catch (error, stacktrace) {
        log('Exception occurred: $error stacktrace: $stacktrace');
        return Left(ServerError.withError(message: error.toString()).failure);
      }
    } else {
      return const Left(ServerFailure(message: 'No Internet Connection'));
    }
  }
}
