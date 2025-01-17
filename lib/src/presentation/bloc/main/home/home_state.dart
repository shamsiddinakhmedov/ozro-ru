part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.message = '',
    this.categories = const [],
    this.products = const [],
    this.productsStatus = ApiStatus.initial,
    this.categoriesStatus = ApiStatus.initial,
    this.paginationStatus = PaginationStatus.initial,
  });

  final String message;
  final ApiStatus productsStatus;
  final ApiStatus categoriesStatus;
  final PaginationStatus paginationStatus;
  final List<CategoriesListResponse> categories;
  final List<ProductsListResponse> products;


  HomeState copyWith({
    String? message,
    List<CategoriesListResponse>? categories,
    List<ProductsListResponse>? products,
    ApiStatus? productsStatus,
    ApiStatus? categoriesStatus,
    PaginationStatus? paginationStatus,
  }) =>
      HomeState(
        products: products ?? this.products,
        categories: categories ?? this.categories,
        message: message ?? this.message,
        productsStatus: productsStatus ?? this.productsStatus,
        categoriesStatus: categoriesStatus ?? this.categoriesStatus,
        paginationStatus: paginationStatus ?? this.paginationStatus,
      );

  @override
  List<Object?> get props => <Object?>[
        products,
        message,
        categories,
        productsStatus,
        categoriesStatus,
        paginationStatus,
      ];

  bool get isLoading => categoriesStatus.isLoading || productsStatus.isLoading;
}
