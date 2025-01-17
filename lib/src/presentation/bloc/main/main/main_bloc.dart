import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/either_dart/either.dart';
import 'package:ozro_mobile/src/core/either_dart/future_extension.dart';
import 'package:ozro_mobile/src/core/services/remote_config_service.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/enum_status.dart';
import 'package:ozro_mobile/src/data/models/main/favorites/favorite_products_list_response.dart';
import 'package:ozro_mobile/src/data/models/main/home/products_list_response.dart';
import 'package:ozro_mobile/src/data/models/pagination_request.dart';
import 'package:ozro_mobile/src/domain/network/failure.dart';
import 'package:ozro_mobile/src/domain/repositories/auth/auth_repository.dart';
import 'package:ozro_mobile/src/domain/repositories/main/main_repository.dart';

part 'main_event.dart';

part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc({
    required this.authRepository,
    required this.homeRepository,
  }) : super(const MainState()) {
    on<MainFetchFavoriteProducts>(_onFetchProducts);
    on<MainCheckAppVersionEvent>(_onCheckAppVersionEvent);
    on<MainEventChanged>(_onChangeMenu);
    on<MainListenAppVersionEvent>(_onListenAppVersionEvent);
    on<MainFetchMyCommentsEvent>(_getUserCommentsAndFeedbacks);
    on<MainDeleteProfileEvent>(_onDeleteProfile);
    on<MainScrollToTopHomeEvent>(_onScrollToTopHome);
  }

  final MainRepository homeRepository;
  final AuthRepository authRepository;
  int offsetP = 0;
  int limitP = 20;

  void _onChangeMenu(MainEventChanged event, Emitter<MainState> emit) {
    emit(state.copyWith(bottomMenu: event.menu));
  }

  Future<void> _onFetchProducts(
    MainFetchFavoriteProducts event,
    Emitter<MainState> emit,
  ) async {
    if (!localSource.hasProfile) return;
    beforeLog('paginationStatus : ${state.favoritePaginationStatus}');
    if (state.favoritePaginationStatus.isDone && !event.isRefresh) return;
    emit(
      state.copyWith(
        favoriteProductsStatus: event.isRefresh && event.updateStatus ? ApiStatus.loading : null,
        favoritePaginationStatus: event.isRefresh ? PaginationStatus.initial : PaginationStatus.loading,
      ),
    );

    final result = await homeRepository.getFavorites(
      request: {
        'limit': 20,
        'offset': event.isRefresh ? 0 : offsetP += 20,
      },
    );
    await result.fold(
      (l) {
        emit(
          state.copyWith(
            favoriteProductsStatus: ApiStatus.error,
            favoritePaginationStatus: PaginationStatus.initial,
            errorMessageFavorite: l.message,
          ),
        );
      },
      (r) async {
        final List<FavoriteProductsListResponse> products = event.isRefresh ? r : [...state.favoriteProducts, ...r];
        debugLog('favorite count ${r.length}');

        emit(
          state.copyWith(
            favoriteProducts: products,
            myFavoriteCount: r.length,
            favoriteProductsStatus: ApiStatus.success,
            favoritePaginationStatus: (r.length) <= products.length ? PaginationStatus.pagination : PaginationStatus.pagination,
          ),
        );
      },
    );
  }

  Future<void> _getUserCommentsAndFeedbacks(
    MainFetchMyCommentsEvent event,
    Emitter<MainState> emit,
  ) async {
    if (!localSource.hasProfile) return;
    emit(state.copyWith(myCommentsStatus: ApiStatus.loading));
    final result = await homeRepository.getUserInfo();
    await result.fold(
      (l) {
        emit(
          state.copyWith(
            myCommentsStatus: ApiStatus.error,
            errorMessageFavorite: l.message,
          ),
        );
      },
      (r) async {
        emit(
          state.copyWith(
            myCommentsCount: r.commentsCount,
            myFeedbackCount: r.feedbacksCount,
            myFavoriteCount: r.favoritesCount,
            myCommentsStatus: ApiStatus.success,
            hasUnreadNotifications: r.hasUnreadNotifications
          ),
        );
      },
    );
    // await Future.wait([
    //   _getUserComments(emit),
    //   _getUserFeedbacks(emit),
    // ]);
  }

  Future<void> _getUserComments(Emitter<MainState> emit) async {
    emit(state.copyWith(myCommentsStatus: ApiStatus.loading));
    final result = await homeRepository.getUserComments(request: {});
    await result.fold(
      (l) {
        emit(
          state.copyWith(
            myCommentsStatus: ApiStatus.error,
            errorMessageFavorite: l.message,
          ),
        );
      },
      (r) async {
        emit(
          state.copyWith(
            myCommentsCount: r.length,
            myCommentsStatus: ApiStatus.success,
          ),
        );
      },
    );
  }

  Future<void> _getUserFeedbacks(Emitter<MainState> emit) async {
    emit(state.copyWith(myCommentsStatus: ApiStatus.loading));

    final result = await homeRepository.getUserFeedbacks(request: {});
    await result.fold(
      (l) {
        emit(
          state.copyWith(
            myCommentsStatus: ApiStatus.error,
            errorMessageFavorite: l.message,
          ),
        );
      },
      (r) async {
        emit(
          state.copyWith(
            myFeedbackCount: r.length,
            myCommentsStatus: ApiStatus.success,
          ),
        );
      },
    );
  }

  Future<void> _onDeleteProfile(
    MainDeleteProfileEvent event,
    Emitter<MainState> emit,
  ) async {
    emit(state.copyWith(deleteAccountStatus: ApiStatus.loading));

    final Future<Either<Failure, bool>> result = event.isLogout ? authRepository.logout() : authRepository.deleteUser();
    await result.fold(
      (l) {
        emit(
          state.copyWith(
            deleteAccountStatus: ApiStatus.error,
            errorMessageDeleteAccount: l.message,
          ),
        );
      },
      (r) {
        emit(state.copyWith(deleteAccountStatus: ApiStatus.success));
      },
    );
  }

  Future<void> _onCheckAppVersionEvent(
    MainCheckAppVersionEvent event,
    Emitter<MainState> emit,
  ) async {
    await RemoteConfigService.isCallCheckAppVersion().then(
      (value) => emit(state.copyWith(appUpdateStatus: value)),
    );
  }

  Future<void> _onListenAppVersionEvent(
    MainListenAppVersionEvent event,
    Emitter<MainState> emit,
  ) async {
    emit(state.copyWith(appUpdateStatus: event.value));
  }

  void _onScrollToTopHome(
    MainScrollToTopHomeEvent event,
    Emitter<MainState> emit,
  ) {
    emit(state.copyWith(scrollToTopHome: false));
    emit(state.copyWith(scrollToTopHome: true));
  }
}

enum BottomMenu {
  home,
  addReview,
  favorites,
  profile,
}
