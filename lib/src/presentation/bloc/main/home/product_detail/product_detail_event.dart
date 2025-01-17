part of 'product_detail_bloc.dart';

abstract class ProductDetailEvent {
  const ProductDetailEvent();
}

class ProductDetailInitialEvent extends ProductDetailEvent {
  const ProductDetailInitialEvent({
    required this.product,
    this.productId,
    this.withProductId = false,
    required this.onFeedbacksLoaded,
  });

  final ProductsListResponse? product;
  final num? productId;
  final bool withProductId;
  final VoidCallback onFeedbacksLoaded;
}

class ProductDetailFetchCommentsEvent extends ProductDetailEvent {
  const ProductDetailFetchCommentsEvent({this.isRefresh = true});

  final bool isRefresh;
}

class ProductDetailFetchFeedbacksEvent extends ProductDetailEvent {
  const ProductDetailFetchFeedbacksEvent( {this.isRefresh = true,required this.onFeedbacksLoaded,});

  final bool isRefresh;
  final VoidCallback onFeedbacksLoaded;
}

class ProductDetailAddToFavoritesEvent extends ProductDetailEvent {
  const ProductDetailAddToFavoritesEvent();
}

class ProductDetailReplyPressedEvent extends ProductDetailEvent {
  const ProductDetailReplyPressedEvent({this.comment});

  final CommentListResponse? comment;
}

class ProductDetailAddCommentEvent extends ProductDetailEvent {
  const ProductDetailAddCommentEvent(this.comment);

  final String comment;
}

class ProductDetailChangeCurrentFeedbackEvent extends ProductDetailEvent {
  const ProductDetailChangeCurrentFeedbackEvent(this.feedback);

  final CommentListResponse? feedback;
}
