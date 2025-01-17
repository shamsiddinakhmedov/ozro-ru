enum TaxiType { initial, standard, comfort, business }

/// Animated Icon status
enum SearchFieldIconStatus {
  search,
  start,
  end,
}

extension SearchFieldIconStatusX on SearchFieldIconStatus {
  bool get isSearch => this == SearchFieldIconStatus.search;

  bool get isStart => this == SearchFieldIconStatus.start;

  bool get isEnd => this == SearchFieldIconStatus.end;
}


enum AppUpdate { forceUpdate, softUpdate, none }
