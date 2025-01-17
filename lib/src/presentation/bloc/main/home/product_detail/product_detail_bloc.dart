import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ozro_mobile/src/core/either_dart/future_extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/enum_status.dart';
import 'package:ozro_mobile/src/data/models/main/home/product_detail/add_comment_request.dart';
import 'package:ozro_mobile/src/data/models/main/home/product_detail/comment_list_response.dart';
import 'package:ozro_mobile/src/data/models/main/home/products_list_response.dart';
import 'package:ozro_mobile/src/data/models/pagination_request.dart';
import 'package:ozro_mobile/src/domain/repositories/main/main_repository.dart';
part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc(this.homeRepository) : super(const ProductDetailState()) {
    on<ProductDetailInitialEvent>(_initialHandler);
    on<ProductDetailAddToFavoritesEvent>(_onFavorite);
    on<ProductDetailFetchCommentsEvent>(_fetchComments);
    on<ProductDetailFetchFeedbacksEvent>(_fetchFeedbacks);
    on<ProductDetailReplyPressedEvent>(_onReplyPressed);
    on<ProductDetailAddCommentEvent>(_onReplySubmit);
    on<ProductDetailChangeCurrentFeedbackEvent>(_onCurrentFeedbackChange);
  }

  final MainRepository homeRepository;

  Future<void> _initialHandler(
    ProductDetailInitialEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    if (event.withProductId) {
      emit(state.copyWith(productStatus: ApiStatus.loading));
      final result = await homeRepository.getProductById(productId: event.productId);
      result.fold(
        (left) {
          emit(state.copyWith(
            productStatus: ApiStatus.error,
            errorMessage: left.message,
          ));
        },
        (right) {
          emit(
            state.copyWith(
              productStatus: ApiStatus.success,
              product: right,
            ),
          );
        },
      );
    } else {
      emit(
        state.copyWith(
          product: event.product,
          productStatus: ApiStatus.success,
        ),
      );
    }

    add(ProductDetailFetchFeedbacksEvent(onFeedbacksLoaded: event.onFeedbacksLoaded));
  }

  void _onFavorite(
    ProductDetailAddToFavoritesEvent event,
    Emitter<ProductDetailState> emit,
  ) {
    final product = state.product;
    emit(
      state.copyWith(
          product: product
        // product: product?.copyWith(
        //   favorite: !(state.product?.favorite ?? false),
        // ),
      ),
    );

    // add(const ProductDetailFetchCommentsEvent());
  }

  void _onCurrentFeedbackChange(
    ProductDetailChangeCurrentFeedbackEvent event,
    Emitter<ProductDetailState> emit,
  ) {
    if (state.selectedFeedback != null && event.feedback != null && state.selectedFeedback?.id != event.feedback?.id) {
      emit(state.copyWith(selectedFeedback: event.feedback));
      debugLog('onCurrentFeedbackChange');
      add(const ProductDetailFetchCommentsEvent());
    }
  }

  Future<void> _fetchComments(
    ProductDetailFetchCommentsEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    if (state.commentsPaginationStatus.isDone && !event.isRefresh) return;
    emit(
      state.copyWith(
        commentsStatus: event.isRefresh ? ApiStatus.loading : null,
        commentsPaginationStatus: event.isRefresh ? PaginationStatus.initial : PaginationStatus.loading,
      ),
    );
    final request = PaginationRequest(
      page: event.isRefresh ? 1 : state.comments.length ~/ 10 + 1,
      count: 10,
      feedbackId: state.selectedFeedback?.id.toString() ?? '',
    );
    final result = await homeRepository.getComments(
      request: {
        'product_id': state.product?.id,
        ...request.toJson(),

        // 'source_id': state.product?.variants.firstOrNull?.sourceId,
      },
    );
    result.fold(
      (l) {
        emit(
          state.copyWith(
              commentsStatus: ApiStatus.error,
              errorMessage: l.message,
              commentsPaginationStatus: PaginationStatus.initial),
        );
      },
      (r) {
        final List<CommentListResponse> comments =
            event.isRefresh ? r : [...state.comments, ...r];
        emit(
          state.copyWith(
            comments: comments,
            commentsStatus: ApiStatus.success,
            commentsPaginationStatus:
                (r.length) <= comments.length ? PaginationStatus.done : PaginationStatus.pagination,
          ),
        );
      },
    );
  }

  Future<void> _fetchFeedbacks(
    ProductDetailFetchFeedbacksEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    if (state.feedbacksPaginationStatus.isDone && !event.isRefresh) return;
    emit(
      state.copyWith(
        feedbacksStatus: event.isRefresh ? ApiStatus.loading : null,
        feedbacksPaginationStatus: event.isRefresh ? PaginationStatus.initial : PaginationStatus.loading,
      ),
    );
    final request = PaginationRequest(
      page: event.isRefresh ? 1 : state.feedbacks.length ~/ 10 + 1,
      count: 10,
    );
    final result = await homeRepository.getFeedbacks(
      request: {
        'product_id': state.product?.id,
        ...request.toJson(),

        // 'source_id': state.product?.variants.firstOrNull?.sourceId,
      },
    );
    result.fold(
      (l) {
        emit(
          state.copyWith(
              feedbacksStatus: ApiStatus.error,
              errorMessage: l.message,
              feedbacksPaginationStatus: PaginationStatus.initial),
        );
      },
      (r) {
        final List<CommentListResponse> feedbacks = event.isRefresh ? r : [...state.feedbacks, ...r];
        emit(
          state.copyWith(
            feedbacks: feedbacks,
            selectedFeedback: event.isRefresh ? feedbacks.firstOrNull : null,
            feedbacksStatus: ApiStatus.success,
            feedbacksPaginationStatus: (r.length) <= feedbacks.length ? PaginationStatus.done : PaginationStatus.pagination,
          ),
        );
        event.onFeedbacksLoaded();
        if (event.isRefresh) {
          add(const ProductDetailFetchCommentsEvent());
        }
      },
    );
  }

  void _onReplyPressed(
    ProductDetailReplyPressedEvent event,
    Emitter<ProductDetailState> emit,
  ) =>
      emit(
        state.copyWith(
          replyIsActive: true,
          reply: event.comment,
        ),
      );

  Future<void> _onReplySubmit(
    ProductDetailAddCommentEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(state.copyWith(addCommentStatus: ApiStatus.loading));

    final result = homeRepository.addComment(
      params: {'direct': true},
      request: AddCommentRequest(
        content: event.comment,
        product: state.product?.id,

        /// todo
        //state.product?.variants.firstOrNull?.sourceId,
        replyTo: state.reply != null ? state.reply?.id : state.selectedFeedback?.id,
        // rating: state.reply? ?? 0,
      ),
    );

    await result.fold(
      (l) {
        emit(
          state.copyWith(
            addCommentStatus: ApiStatus.error,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            replyIsActive: false,
            clearReply: true,
            addCommentStatus: ApiStatus.success,
          ),
        );
        add(const ProductDetailFetchCommentsEvent());
      },
    );
  }
}
