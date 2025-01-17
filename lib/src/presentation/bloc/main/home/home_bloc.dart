// ignore_for_file: always_specify_types

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/enum_status.dart';
import 'package:ozro_mobile/src/data/models/main/home/categories_list_response.dart';
import 'package:ozro_mobile/src/data/models/main/home/products_list_response.dart';
import 'package:ozro_mobile/src/data/models/pagination_request.dart';
import 'package:ozro_mobile/src/domain/repositories/main/main_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required this.repository,
  }) : super(const HomeState()) {
    on<HomeFetchCategoriesEvent>(_onFetchCategories);
    on<HomeFetchProductsEvent>(_onFetchProducts);
    on<HomeAddToFavoritesEvent>(_addToFavorite);
    on<HomeLikeProductEvent>(_likeProduct);
  }

  int offsetP = 0;
  int limitP = 20;

  final MainRepository repository;

  Future<void> _onFetchCategories(
    HomeFetchCategoriesEvent event,
    Emitter<HomeState> emit,
  ) async {
    debugLog('onFetchCategories');
    emit(state.copyWith(categoriesStatus: ApiStatus.loading));
    const request = PaginationRequest();
    final result = await repository.getCategories(
      request: request.toJson(),
    );
    await result.fold(
      (l) {
        emit(
          state.copyWith(
            categoriesStatus: ApiStatus.error,
            message: l.message,
          ),
        );
      },
      (r) async {
        debugLog('right categories length ${r.length}');
        emit(
          state.copyWith(
            categories: r
              ..insert(
                0,
                CategoriesListResponse(
                  title: 'Все',
                ),
              ),
            categoriesStatus: ApiStatus.success,
          ),
        );
        debugLog('state categories length on bloc  ${state.categories.length}');
        add(HomeFetchProductsEvent(categoryId: state.categories.firstOrNull?.id));
      },
    );
  }

  void _addToFavorite(
    HomeAddToFavoritesEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        products: List.of(state.products)
          ..[event.index] = (state.products[event.index].favorite ?? false) as ProductsListResponse,
      ),
    );
  }

  void _likeProduct(
    HomeLikeProductEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        products: List.of(state.products)
          ..[event.index] = state.products[event.index]
            //   .copyWith(
            // liked: !event.product.liked,
            // likes: event.product.liked ? event.product.likes - 1 : event.product.likes + 1,
          // ),
      ),
    );
  }

  Future<void> _onFetchProducts(
    HomeFetchProductsEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (event.forSearch) {
      if (event.search.isEmpty) {
        emit(state.copyWith(
          products: [],
        ));
        return;
      }
    }
    if(state.productsStatus.isLoading) return;
    beforeLog('paginationStatus : ${state.paginationStatus}');
    if (state.paginationStatus.isDone && !event.isRefresh) return;
    emit(
      state.copyWith(
        productsStatus: event.isRefresh ? ApiStatus.loading : null,
        paginationStatus: event.isRefresh ? PaginationStatus.initial : PaginationStatus.loading,
      ),
    );
    final result = await repository.getProducts(
      request: {
        if (event.categoryId != null)
          'category_id': event.categoryId.toString(),
          'search': event.search,
          'limit': 20,
          'offset': event.isRefresh ? 0 : offsetP += 20,
      },
    );
    emit(state.copyWith(paginationStatus: PaginationStatus.initial));
    await result.fold(
      (l) {
        emit(
          state.copyWith(
            productsStatus: ApiStatus.error,
            paginationStatus: PaginationStatus.initial,
            message: l.message,
          ),
        );
      },
      (r) async {
        final List<ProductsListResponse> products = event.isRefresh ? r : [...state.products, ...r];
        emit(
          state.copyWith(
            products: products,
            productsStatus: ApiStatus.success,
            paginationStatus: (r.length) <= state.products.length ? PaginationStatus.pagination : PaginationStatus.pagination,
          ),
        );
      },
    );
  }
}
