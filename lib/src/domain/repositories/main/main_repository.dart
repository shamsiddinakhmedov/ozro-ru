import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ozro_mobile/src/core/constants/constants.dart';
import 'package:ozro_mobile/src/core/either_dart/either.dart';
import 'package:ozro_mobile/src/core/platform/network_info.dart';
import 'package:ozro_mobile/src/data/models/auth/sign_in_response.dart';
import 'package:ozro_mobile/src/data/models/main/add_review/add_feedback_request.dart';
import 'package:ozro_mobile/src/data/models/main/favorites/favorite_products_list_response.dart';
import 'package:ozro_mobile/src/data/models/main/home/categories_list_response.dart';
import 'package:ozro_mobile/src/data/models/main/home/product_detail/add_comment_request.dart';
import 'package:ozro_mobile/src/data/models/main/home/product_detail/comment_list_response.dart';
import 'package:ozro_mobile/src/data/models/main/home/products_list_response.dart';
import 'package:ozro_mobile/src/data/models/main/notifications/notifications_response.dart';
import 'package:ozro_mobile/src/domain/network/failure.dart';
import 'package:ozro_mobile/src/domain/network/server_error.dart';

part 'main_repository_impl.dart';

abstract class MainRepository {
  const MainRepository();

  Future<Either<Failure, List<CategoriesListResponse>>> getCategories({required Map<String, dynamic> request});

  Future<Either<Failure, List<ProductsListResponse>>> getProducts({required Map<String, dynamic> request});

  Future<Either<Failure, ProductsListResponse>> getProductById({required num? productId});

  Future<Either<Failure, bool>> addToFavorites({required num? productId});

  Future<Either<Failure, CommentListResponse>> addComment({
    required AddCommentRequest request,
    required Map<String, dynamic> params,
  });

  Future<Either<Failure, bool>> addFeedback(
      {required AddFeedbackRequest request, required Map<String, dynamic> params});

  Future<Either<Failure, List<FavoriteProductsListResponse>>> getFavorites({required Map<String, dynamic> request});

  Future<Either<Failure, List<CommentListResponse>>> getComments({required Map<String, dynamic> request});

  Future<Either<Failure, List<CommentListResponse>>> getFeedbacks({required Map<String, dynamic> request});

  Future<Either<Failure, List<CommentListResponse>>> getUserComments({required Map<String, dynamic> request});

  Future<Either<Failure, UserResponse>> getUserInfo();

  Future<Either<Failure, List<CommentListResponse>>> getUserFeedbacks({required Map<String, dynamic> request});

  Future<Either<Failure, bool>> postLike({required num? productId});

  Future<Either<Failure, bool>> deleteMyFeedbackOrComment(num? feedbackId);

  Future<Either<Failure, bool>> editMyFeedbackOrComment({required Map<String, dynamic> request,num? feedbackId});
  // Future<Either<Failure, bool>> deleteMyFeedback();
  Future<Either<Failure, List<GetNotificationsResponse>>> getNotifications();

  Future<Either<Failure, bool>> readNotification({required int id});

}
