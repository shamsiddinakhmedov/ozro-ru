enum ApiStatus {
  initial,
  loading,
  loadingMore,
  success,
  error,
}

extension ApiStatusX on ApiStatus {
  bool get isInitial => this == ApiStatus.initial;

  bool get isLoading => this == ApiStatus.loading;

  bool get isLoadingMore => this == ApiStatus.loadingMore;

  bool get isSuccess => this == ApiStatus.success;

  bool get isError => this == ApiStatus.error;
}

enum PaginationStatus {
  initial,
  loading,
  pagination,
  done;

  bool get isInitial => this == PaginationStatus.initial;

  bool get isLoading => this == PaginationStatus.loading;

  bool get isPagination => this == PaginationStatus.pagination;

  bool get isDone => this == PaginationStatus.done;

  bool get isNotDone => this != PaginationStatus.done;
}
