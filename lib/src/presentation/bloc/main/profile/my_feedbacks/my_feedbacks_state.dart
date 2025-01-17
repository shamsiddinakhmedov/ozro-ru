part of 'my_feedbacks_bloc.dart';

final class MyFeedbacksState extends Equatable {
  const MyFeedbacksState(
      {this.feedbacksStatus = ApiStatus.initial,
      this.paginationStatus = PaginationStatus.initial,
      this.errorMessage = '',
      this.feedbacks = const [],
      this.deleteStatus = ApiStatus.initial});

  final ApiStatus feedbacksStatus;
  final ApiStatus deleteStatus;
  final PaginationStatus paginationStatus;
  final String errorMessage;
  final List<CommentListResponse> feedbacks;

  MyFeedbacksState copyWith({
    ApiStatus? feedbacksStatus,
    PaginationStatus? paginationStatus,
    String? errorMessage,
    List<CommentListResponse>? feedbacks,
    ApiStatus? deleteStatus,
  }) =>
      MyFeedbacksState(
        feedbacksStatus: feedbacksStatus ?? this.feedbacksStatus,
        paginationStatus: paginationStatus ?? this.paginationStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        feedbacks: feedbacks ?? this.feedbacks,
        deleteStatus: deleteStatus ?? ApiStatus.initial,
      );

  @override
  List<Object?> get props => [
        feedbacksStatus,
        paginationStatus,
        errorMessage,
        feedbacks,
        deleteStatus,
      ];
}
