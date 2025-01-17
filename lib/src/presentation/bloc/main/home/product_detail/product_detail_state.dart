part of 'product_detail_bloc.dart';

final class ProductDetailState extends Equatable {
  const ProductDetailState({
    this.product,
    this.commentsStatus = ApiStatus.initial,
    this.addCommentStatus = ApiStatus.initial,
    this.commentsPaginationStatus = PaginationStatus.initial,
    this.comments = const [],
    this.errorMessage = '',
    this.replyIsActive = false,
    this.reply,
    this.feedbacksStatus = ApiStatus.initial,
    this.feedbacksPaginationStatus = PaginationStatus.initial,
    this.feedbacks = const [],
    this.selectedFeedback,
    this.productStatus = ApiStatus.initial,
  });

  final ProductsListResponse? product;
  final ApiStatus productStatus;

  final ApiStatus commentsStatus;
  final ApiStatus addCommentStatus;
  final String errorMessage;
  final PaginationStatus commentsPaginationStatus;
  final List<CommentListResponse> comments;

  final ApiStatus feedbacksStatus;
  final PaginationStatus feedbacksPaginationStatus;

  final List<CommentListResponse> feedbacks;
  final CommentListResponse? selectedFeedback;

  final bool replyIsActive;
  final CommentListResponse? reply;

  ProductDetailState copyWith({
    ProductsListResponse? product,
    ApiStatus? commentsStatus,
    ApiStatus? addCommentStatus,
    PaginationStatus? commentsPaginationStatus,
    List<CommentListResponse>? comments,
    String? errorMessage,
    bool? replyIsActive,
    CommentListResponse? reply,
    bool clearReply = false,
    ApiStatus? feedbacksStatus,
    PaginationStatus? feedbacksPaginationStatus,
    List<CommentListResponse>? feedbacks,
    CommentListResponse? selectedFeedback,
    ApiStatus? productStatus,
  }) =>
      ProductDetailState(
        product: product ?? this.product,
        commentsStatus: commentsStatus ?? this.commentsStatus,
        addCommentStatus: addCommentStatus ?? ApiStatus.initial,
        commentsPaginationStatus: commentsPaginationStatus ?? this.commentsPaginationStatus,
        comments: comments ?? this.comments,
        errorMessage: errorMessage ?? this.errorMessage,
        replyIsActive: replyIsActive ?? this.replyIsActive,
        reply: clearReply ? null : reply ?? this.reply,
        feedbacksStatus: feedbacksStatus ?? this.feedbacksStatus,
        feedbacksPaginationStatus: feedbacksPaginationStatus ?? this.feedbacksPaginationStatus,
        feedbacks: feedbacks ?? this.feedbacks,
        selectedFeedback: selectedFeedback ?? this.selectedFeedback,
        productStatus: productStatus ?? ApiStatus.initial,
      );

  @override
  List<Object?> get props => [
        product,
        commentsStatus,
        addCommentStatus,
        commentsPaginationStatus,
        comments,
        errorMessage,
        replyIsActive,
        reply,
        feedbacksStatus,
        feedbacksPaginationStatus,
        feedbacks,
        selectedFeedback,
        productStatus,
      ];
}
