part of 'main_repository.dart';

class MainRepositoryImpl implements MainRepository {
  MainRepositoryImpl({
    required this.dio,
    required this.networkInfo,
  });

  final Dio dio;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<CategoriesListResponse>>> getCategories({required Map<String, dynamic> request}) async {
    if (await networkInfo.isConnected) {
      try {
        final Response response = await dio.get(Urls.categories, queryParameters: request);
        final list = <CategoriesListResponse>[];
        final data = response.data as List<dynamic>;
        for (final e in data as Iterable) {
          list.add(CategoriesListResponse.fromJson(e));
        }
        return Right(list);
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
  Future<Either<Failure, List<ProductsListResponse>>> getProducts({required Map<String, dynamic> request}) async {
    if (await networkInfo.isConnected) {
      try {
        final Response response = await dio.get(Urls.products, queryParameters: request);
        final list = <ProductsListResponse>[];
        final data = response.data as List<dynamic>;
        for (final e in data as Iterable) {
          list.add(ProductsListResponse.fromJson(e));
        }
        return Right(list);
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
  Future<Either<Failure, CommentListResponse>> addComment({
    required AddCommentRequest request,
    required Map<String, dynamic> params,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final Response response = await dio.post<void>(
          Urls.comments,
          data: request.toJson(),
          queryParameters: params,
        );
        return Right(CommentListResponse.fromJson(response.data));
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
  Future<Either<Failure, bool>> addToFavorites({required num? productId}) async {
    if (await networkInfo.isConnected) {
      try {
        await dio.post<void>('${Urls.favorite}/$productId');
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
  Future<Either<Failure, List<FavoriteProductsListResponse>>> getFavorites({required Map<String, dynamic> request}) async {
    if (await networkInfo.isConnected) {
      try {
        final Response response = await dio.get(Urls.favorites, queryParameters: request);
        final list = <FavoriteProductsListResponse>[];
        final data = response.data as List<dynamic>;
        for (final e in data as Iterable) {
          list.add(FavoriteProductsListResponse.fromJson(e));
        }
        return Right(list);
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
  Future<Either<Failure, bool>> postLike({required num? productId}) async {
    if (await networkInfo.isConnected) {
      try {
        await dio.post<void>('${Urls.like}/$productId');
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
  Future<Either<Failure, List<CommentListResponse>>> getUserComments({required Map<String, dynamic> request}) async {
    if (await networkInfo.isConnected) {
      try {
        final Response response = await dio.get(Urls.userComments, queryParameters: request);
        final list = <CommentListResponse>[];
        final data = response.data as List<dynamic>;
        for (final e in data as Iterable) {
          list.add(CommentListResponse.fromJson(e));
        }
        return Right(list);
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
  Future<Either<Failure, List<CommentListResponse>>> getUserFeedbacks({required Map<String, dynamic> request}) async {
    if (await networkInfo.isConnected) {
      try {
        final Response response = await dio.get(Urls.userFeedbacks, queryParameters: request);
        final list = <CommentListResponse>[];
        final data = response.data as List<dynamic>;
        for (final e in data as Iterable) {
          list.add(CommentListResponse.fromJson(e));
        }
        return Right(list);
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
  Future<Either<Failure, bool>> addFeedback({
    required AddFeedbackRequest request,
    required Map<String, dynamic> params,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await dio.post<void>(
          Urls.feedbacks,
          data: FormData.fromMap(
            request.toJson(),
          ),
          queryParameters: params,
        );
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
  Future<Either<Failure, List<CommentListResponse>>> getComments({required Map<String, dynamic> request}) async {
    if (await networkInfo.isConnected) {
      try {
        final Response response = await dio.get(Urls.comments, queryParameters: request);
        final list = <CommentListResponse>[];
        final data = response.data as List<dynamic>;
        for (final e in data as Iterable) {
          list.add(CommentListResponse.fromJson(e));
        }
        return Right(list);

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
  Future<Either<Failure, List<CommentListResponse>>> getFeedbacks({required Map<String, dynamic> request}) async {
    if (await networkInfo.isConnected) {
      try {
        final Response response = await dio.get(Urls.feedbacks, queryParameters: request);
        final list = <CommentListResponse>[];
        final data = response.data as List<dynamic>;
        for (final e in data as Iterable) {
          list.add(CommentListResponse.fromJson(e));
        }
        return Right(list);
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
  Future<Either<Failure, bool>> deleteMyFeedbackOrComment(num? feedbackId) async {
    if (await networkInfo.isConnected) {
      try {
        await dio.delete<void>('${Urls.userComments}/$feedbackId');
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
  Future<Either<Failure, bool>> editMyFeedbackOrComment({
    required Map<String, dynamic> request,
    num? feedbackId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await dio.put<void>('${Urls.userComments}/$feedbackId', data: request);
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
  Future<Either<Failure, ProductsListResponse>> getProductById({required num? productId}) async {
    if (await networkInfo.isConnected) {
      try {
        final Response response = await dio.get('${Urls.product}/$productId');
        return Right(ProductsListResponse.fromJson(response.data));
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
  Future<Either<Failure, UserResponse>> getUserInfo() async {
    if (await networkInfo.isConnected) {
      try {
        final Response response = await dio.get(Urls.user);
        return Right(UserResponse.fromJson(response.data));
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
  Future<Either<Failure, List<GetNotificationsResponse>>> getNotifications() async {
    if (await networkInfo.isConnected) {
      try {
        final Response response = await dio.get(Urls.getNotification);
        final list = <GetNotificationsResponse>[];
        final data = response.data as List<dynamic>;
        for (final e in data as Iterable) {
          list.add(GetNotificationsResponse.fromJson(e));
        }
        return Right(list);
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
  Future<Either<Failure, bool>> readNotification({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dio.get('${Urls.getNotification}/$id');
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
