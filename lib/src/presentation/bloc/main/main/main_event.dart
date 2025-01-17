part of 'main_bloc.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();
}

class MainCheckAppVersionEvent extends MainEvent {
  const MainCheckAppVersionEvent();

  @override
  List<Object?> get props => [];
}

class MainListenAppVersionEvent extends MainEvent {
  const MainListenAppVersionEvent(this.value);

  final AppUpdateStatus value;

  @override
  List<Object?> get props => [value];
}

class MainEventChanged extends MainEvent {
  const MainEventChanged(this.menu);

  final BottomMenu menu;

  @override
  List<Object?> get props => [menu];
}

class MainGetUserInfoEvent extends MainEvent {
  const MainGetUserInfoEvent();

  @override
  List<Object?> get props => [];
}

class MainFetchFavoriteProducts extends MainEvent {
  const MainFetchFavoriteProducts({
    this.isRefresh = true,
    this.updateStatus = true,
  });

  final bool isRefresh;
  final bool updateStatus;

  @override
  List<Object?> get props => [isRefresh, updateStatus];
}

class MainFetchMyCommentsEvent extends MainEvent {
  const MainFetchMyCommentsEvent();

  @override
  List<Object?> get props => [];
}

class MainDeleteProfileEvent extends MainEvent {
  const MainDeleteProfileEvent({this.isLogout = false});

  final bool isLogout;

  @override
  List<Object?> get props => [isLogout];
}

class MainScrollToTopHomeEvent extends MainEvent {
  const MainScrollToTopHomeEvent();

  @override
  List<Object?> get props => [];
}

class MainAddToFavoritesEvent extends MainEvent {
  const MainAddToFavoritesEvent({
    required this.product,
    required this.index,
  });

  final ProductsListResponse? product;
  final int index;

  @override
  List<Object?> get props => [product, index];
}
