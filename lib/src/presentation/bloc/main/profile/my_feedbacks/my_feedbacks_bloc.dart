import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ozro_mobile/src/core/either_dart/future_extension.dart';
import 'package:ozro_mobile/src/data/models/enum_status.dart';
import 'package:ozro_mobile/src/data/models/main/home/product_detail/comment_list_response.dart';
import 'package:ozro_mobile/src/data/models/pagination_request.dart';
import 'package:ozro_mobile/src/domain/repositories/main/main_repository.dart';

part 'my_feedbacks_event.dart';

part 'my_feedbacks_state.dart';

class MyFeedbacksBloc extends Bloc<MyFeedbacksEvent, MyFeedbacksState> {
  MyFeedbacksBloc(this.mainRepository) : super(const MyFeedbacksState()) {
    on<MyFeedbacksFetchEvent>(_onFetchFeedbacks);
    on<MyFeedbacksDeleteEvent>(_onDeleteFeedback);
  }

  final MainRepository mainRepository;

  Future<void> _onFetchFeedbacks(
    MyFeedbacksFetchEvent event,
    Emitter<MyFeedbacksState> emit,
  ) async {
    if (state.paginationStatus.isDone && !event.isRefresh) return;
    emit(
      state.copyWith(
        feedbacksStatus: event.isRefresh ? ApiStatus.loading : null,
        paginationStatus: event.isRefresh ? PaginationStatus.initial : PaginationStatus.loading,
      ),
    );

    final request = PaginationRequest(
      page: event.isRefresh ? 1 : state.feedbacks.length ~/ 10 + 1,
      count: 10,
    );

    final result = await mainRepository.getUserFeedbacks(
      request: request.toJson(),
    );
    await result.fold(
      (l) {
        emit(
          state.copyWith(
            feedbacksStatus: ApiStatus.error,
            paginationStatus: PaginationStatus.initial,
            errorMessage: l.message,
          ),
        );
      },
      (r) async {
        final List<CommentListResponse> products =
            event.isRefresh ? r : [...state.feedbacks, ...r];

        emit(
          state.copyWith(
            feedbacks: products,
            feedbacksStatus: ApiStatus.success,
            paginationStatus: (r.length) <= products.length ? PaginationStatus.done : PaginationStatus.pagination,
          ),
        );
      },
    );
  }

  Future<void> _onDeleteFeedback(
    MyFeedbacksDeleteEvent event,
    Emitter<MyFeedbacksState> emit,
  ) async {
    emit(state.copyWith(deleteStatus: ApiStatus.loading));
    final result = mainRepository.deleteMyFeedbackOrComment(event.feedback.id);
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
            feedbacks: List.of(state.feedbacks)..removeAt(event.index),
          ),
        );
      },
    );
  }
}
