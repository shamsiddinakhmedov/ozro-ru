part of 'my_feedbacks_bloc.dart';

abstract class MyFeedbacksEvent {
  const MyFeedbacksEvent();
}

class MyFeedbacksFetchEvent extends MyFeedbacksEvent {
  const MyFeedbacksFetchEvent({
    this.isRefresh = true,
  });

  final bool isRefresh;
}

class MyFeedbacksDeleteEvent extends MyFeedbacksEvent {
  const MyFeedbacksDeleteEvent({
    required this.feedback,
    required this.index,
  });

  final CommentListResponse feedback;
  final int index;
}
