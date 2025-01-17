part of 'home_bloc.dart';

sealed class HomeEvent {
  const HomeEvent();
}

class HomeFetchCategoriesEvent extends HomeEvent {
  const HomeFetchCategoriesEvent();
}

class HomeFetchProductsEvent extends HomeEvent {
  const HomeFetchProductsEvent({
    this.isRefresh = true,
    this.categoryId,
    this.search = '',
    this.forSearch = false,
  });

  final bool isRefresh;
  final num? categoryId;
  final String search;
  final bool forSearch;
}

class HomeAddToFavoritesEvent extends HomeEvent {
  const HomeAddToFavoritesEvent({
    required this.product,
    required this.index,
  });

  final ProductsListResponse? product;
  final int index;
}

class HomeLikeProductEvent extends HomeEvent {
  const HomeLikeProductEvent({
    required this.product,
    required this.index,
  });

  final ProductsListResponse product;
  final int index;
}
