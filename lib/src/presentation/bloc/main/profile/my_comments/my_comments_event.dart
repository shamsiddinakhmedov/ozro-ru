part of 'my_comments_bloc.dart';

abstract class MyCommentsEvent {
  const MyCommentsEvent();
}

class MyCommentsFetchEvent extends MyCommentsEvent {
  const MyCommentsFetchEvent({
    this.isRefresh = true,
});
  final bool isRefresh;

}

class MyCommentsDeleteEvent extends MyCommentsEvent {
  const MyCommentsDeleteEvent({
    required this.comment,
    required this.index,
  });

  final CommentListResponse comment;
  final int index;
}
