import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ozro_mobile/src/core/either_dart/future_extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/enum_status.dart';
import 'package:ozro_mobile/src/data/models/main/home/product_detail/comment_list_response.dart';
import 'package:ozro_mobile/src/data/models/pagination_request.dart';
import 'package:ozro_mobile/src/domain/repositories/main/main_repository.dart';

part 'my_comments_event.dart';

part 'my_comments_state.dart';

class MyCommentsBloc extends Bloc<MyCommentsEvent, MyCommentsState> {
  MyCommentsBloc(this.mainRepository) : super(const MyCommentsState()) {
    on<MyCommentsFetchEvent>(_onFetchComments);
    on<MyCommentsDeleteEvent>(_onDeleteComment);
  }

  final MainRepository mainRepository;

  Future<void> _onFetchComments(
    MyCommentsFetchEvent event,
    Emitter<MyCommentsState> emit,
  ) async {
    if (state.myCommentsStatus.isLoading) return;
    if (state.paginationStatus.isDone && !event.isRefresh) return;
    emit(
      state.copyWith(
        myCommentsStatus: event.isRefresh ? ApiStatus.loading : null,
        paginationStatus: event.isRefresh ? PaginationStatus.initial : PaginationStatus.loading,
      ),
    );

    final request = PaginationRequest(
      page: event.isRefresh ? 1 : state.comments.length ~/ 10 + 1,
      count: 10,
    );

    final result = await mainRepository.getUserComments(
      request: request.toJson(),
    );
    await result.fold(
      (l) {
        emit(
          state.copyWith(
            myCommentsStatus: ApiStatus.error,
            paginationStatus: PaginationStatus.initial,
            errorMessage: l.message,
          ),
        );
      },
      (r) async {
        final List<CommentListResponse> comments =
            event.isRefresh ? r : [...state.comments, ...r];
        debugLog('comments length ${comments.length}');
        emit(
          state.copyWith(
            comments: comments,
            myCommentsStatus: ApiStatus.success,
            paginationStatus: (r.length) <= comments.length ? PaginationStatus.done : PaginationStatus.pagination,
          ),
        );
      },
    );
  }

  Future<void> _onDeleteComment(
    MyCommentsDeleteEvent event,
    Emitter<MyCommentsState> emit,
  ) async {
    emit(state.copyWith(deleteStatus: ApiStatus.loading));
    final result = mainRepository.deleteMyFeedbackOrComment(event.comment.id);
    await result.fold(
      (left) {
        emit(
          state.copyWith(
            deleteStatus: ApiStatus.error,
            errorMessage: left.message,
          ),
        );
      },
      (right) {
        emit(
          state.copyWith(
            deleteStatus: ApiStatus.success,
            comments: List.of(state.comments)..removeAt(event.index),
          ),
        );
      },
    );
  }
}
