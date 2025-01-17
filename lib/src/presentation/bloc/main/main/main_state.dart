part of 'main_bloc.dart';

class MainState extends Equatable {
  const MainState({
    this.bottomMenu = BottomMenu.home,
    this.appUpdateStatus = AppUpdateStatus.none,
    this.favoriteProductsStatus = ApiStatus.initial,
    this.favoriteProducts = const [],
    this.errorMessageFavorite = '',
    this.favoritePaginationStatus = PaginationStatus.initial,
    this.myCommentsCount = 0,
    this.myFeedbackCount = 0,
    this.myFavoriteCount = 0,
    this.myCommentsStatus = ApiStatus.initial,
    this.deleteAccountStatus = ApiStatus.initial,
    this.errorMessageDeleteAccount = '',
    this.scrollToTopHome = false,
    this.hasUnreadNotifications = false
  });

  final BottomMenu bottomMenu;
  final AppUpdateStatus appUpdateStatus;

  /// for homePage
  final bool scrollToTopHome;

  /// for myFavoritesPage
  final ApiStatus favoriteProductsStatus;
  final String errorMessageFavorite;
  final List<FavoriteProductsListResponse> favoriteProducts;
  final PaginationStatus favoritePaginationStatus;

  /// for profilePage
  final ApiStatus myCommentsStatus;
  final ApiStatus deleteAccountStatus;
  final String errorMessageDeleteAccount;
  final num myCommentsCount;
  final num myFeedbackCount;
  final num myFavoriteCount;
  final bool hasUnreadNotifications;

  MainState copyWith({
    BottomMenu? bottomMenu,
    AppUpdateStatus? appUpdateStatus,
    ApiStatus? favoriteProductsStatus,
    List<FavoriteProductsListResponse>? favoriteProducts,
    String? errorMessageFavorite,
    PaginationStatus? favoritePaginationStatus,
    num? myCommentsCount,
    num? myFeedbackCount,
    num? myFavoriteCount,
    ApiStatus? myCommentsStatus,
    ApiStatus? deleteAccountStatus,
    String? errorMessageDeleteAccount,
    bool? scrollToTopHome,
    bool? hasUnreadNotifications
  }) =>
      MainState(
        bottomMenu: bottomMenu ?? this.bottomMenu,
        appUpdateStatus: appUpdateStatus ?? this.appUpdateStatus,
        favoriteProductsStatus: favoriteProductsStatus ?? this.favoriteProductsStatus,
        favoriteProducts: favoriteProducts ?? this.favoriteProducts,
        errorMessageFavorite: errorMessageFavorite ?? this.errorMessageFavorite,
        favoritePaginationStatus: favoritePaginationStatus ?? this.favoritePaginationStatus,
        myCommentsCount: myCommentsCount ?? this.myCommentsCount,
        myFeedbackCount: myFeedbackCount ?? this.myFeedbackCount,
        myFavoriteCount: myFavoriteCount ?? this.myFavoriteCount,
        myCommentsStatus: myCommentsStatus ?? this.myCommentsStatus,
        deleteAccountStatus: deleteAccountStatus ?? this.deleteAccountStatus,
        errorMessageDeleteAccount: errorMessageDeleteAccount ?? this.errorMessageDeleteAccount,
        scrollToTopHome: scrollToTopHome ?? this.scrollToTopHome,
        hasUnreadNotifications: hasUnreadNotifications ?? this.hasUnreadNotifications
      );

  @override
  List<Object?> get props => [
        bottomMenu,
        appUpdateStatus,
        favoriteProductsStatus,
        favoriteProducts,
        errorMessageFavorite,
        favoritePaginationStatus,
        myCommentsCount,
        myFeedbackCount,
        myFavoriteCount,
        myCommentsStatus,
        deleteAccountStatus,
        errorMessageDeleteAccount,
        scrollToTopHome,
        hasUnreadNotifications
      ];
}
