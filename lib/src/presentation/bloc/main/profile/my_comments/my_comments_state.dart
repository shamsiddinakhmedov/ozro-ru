part of 'my_comments_bloc.dart';

final class MyCommentsState extends Equatable {
  const MyCommentsState({
    this.myCommentsStatus = ApiStatus.initial,
    this.paginationStatus = PaginationStatus.initial,
    this.deleteStatus = ApiStatus.initial,
    this.errorMessage = '',
    this.comments = const [],
  });

  final ApiStatus myCommentsStatus;
  final ApiStatus deleteStatus;
  final PaginationStatus paginationStatus;
  final String errorMessage;
  final List<CommentListResponse> comments;

  MyCommentsState copyWith({
    ApiStatus? myCommentsStatus,
    PaginationStatus? paginationStatus,
    String? errorMessage,
    List<CommentListResponse>? comments,
    ApiStatus? deleteStatus,
  }) =>
      MyCommentsState(
        myCommentsStatus: myCommentsStatus ?? this.myCommentsStatus,
        paginationStatus: paginationStatus ?? this.paginationStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        comments: comments ?? this.comments,
        deleteStatus: deleteStatus ?? this.deleteStatus,
      );

  @override
  List<Object?> get props => [
        myCommentsStatus,
        paginationStatus,
        errorMessage,
        comments,
        deleteStatus,
      ];
}
