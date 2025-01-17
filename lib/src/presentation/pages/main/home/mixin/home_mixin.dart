part of '../home_page.dart';

mixin HomeMixin on State<HomePage> {
  late TabController tabController;
  late final ValueNotifier<int> selectedTab = ValueNotifier<int>(0);
  late final ScrollController scrollController;
  final ValueNotifier<bool> isEndList = ValueNotifier<bool>(false);

  // /// banner 31
  // late BannerAd banner31;
  // final AdRequest adRequest31 = const AdRequest();
  // final ValueNotifier<bool> isLoading31 = ValueNotifier(false);
  // final ValueNotifier<bool> isBannerAlreadyCreated31 = ValueNotifier(false);
  //
  // /// banner 21
  // late BannerAd banner21;
  // final AdRequest adRequest21 = const AdRequest();
  // final ValueNotifier<bool> isLoading21 = ValueNotifier(false);
  // final ValueNotifier<bool> isBannerAlreadyCreated21 = ValueNotifier(false);

  /// banner 11
  late BannerAd banner11;
  final AdRequest adRequest11 = const AdRequest();
  final ValueNotifier<bool> isLoading11 = ValueNotifier(false);
  final ValueNotifier<bool> isBannerAlreadyCreated11 = ValueNotifier(false);
  final _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    scrollController = ScrollController()..addListener(_onScroll);
    MobileAds.initialize();
    MobileAds.setUserConsent(true);
    // MobileAds.setLogging(true);
    // MobileAds.setDebugErrorIndicator(true);
    _loadBanner11();
    // _loadBanner21();
    // _loadBanner31();
    super.initState();
    // handleDynamicLinks();
    initDeepLinks();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();
    // Handle links
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      debugPrint('onAppLink: $uri');
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    context.pushNamed(Routes.notification);
    debugPrint('onAppLink::: $uri');
  }

  // Future<void> handleDynamicLinks() async {
  //   // App ilk ochilganda Dynamic Linkni tekshirish
  //   final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
  //
  //   _handleDeepLink(initialLink?.link);
  //   // App ishlayotganida Dynamic Linkni eshitish
  //   FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
  //     _handleDeepLink(dynamicLinkData.link);
  //   }).onError((error) => print('Dynamic Link Error: $error'));
  // }
  // void _handleDeepLink(Uri? deepLink) {
  //   if (deepLink != null) {
  //
  //     final String? id = deepLink.queryParameters['id'];
  //     print('Dynamic Link deepLink: $deepLink');
  //     if (id != null) {
  //
  //       // Navigator.push(
  //       //   context,
  //       //   // MaterialPageRoute(builder: (context) => DetailPage(id: id)),
  //       // );
  //     }
  //   }
  // }


  void _onScroll() {
    if (scrollController.offset > 50) {
      isEndList.value = true;
    } else if (isEndList.value) {
      isEndList.value = false;
    }
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (maxScroll == currentScroll && context.read<HomeBloc>().state.paginationStatus.isNotDone) {
      context.read<HomeBloc>().add(
        HomeFetchProductsEvent(
          isRefresh: false,
          categoryId: context.read<HomeBloc>().state.categories[selectedTab.value].id,
        ),
      );
    }
  }

  // Future<void> _loadBanner31() async {
  //   debugLog('load banner31');
  //   await Future<void>.delayed(const Duration(seconds: 1));
  //   if (!mounted) return;
  //
  //   isLoading31.value = true;
  //   if (isBannerAlreadyCreated31.value) {
  //     debugLog('isBannerAlreadyCreated31');
  //     await banner31.loadAd(adRequest: adRequest31);
  //     isLoading31.value = false;
  //   } else {
  //     debugLog('else isBannerAlreadyCreated31');
  //     double itemWidth = (context.kSize.width - 48) / 2;
  //
  //     final iPadOrTablet = context.kSize.width > 600;
  //     if (iPadOrTablet) {
  //       itemWidth = (context.kSize.width - 100) / 4;
  //     }
  //     final double itemHeight = itemWidth * 1.5 + 100;
  //
  //     final adSize = BannerAdSize.inline(
  //       width: itemWidth.toInt(),
  //       maxHeight: itemHeight.toInt(),
  //     );
  //     final calculatedBannerSize = await adSize.getCalculatedBannerAdSize();
  //     debugLog('calculatedBannerSize: ${calculatedBannerSize.toString()}');
  //     banner31 = _createBanner31(adSize);
  //
  //     isBannerAlreadyCreated31.value = true;
  //     isLoading31.value = false;
  //   }
  // }
  //
  // BannerAd _createBanner31(BannerAdSize adSize) => BannerAd(
  //       adUnitId: Constants.banner31Id,
  //       adSize: adSize,
  //       adRequest: adRequest31,
  //       onAdLoaded: () {
  //         isLoading31.value = false;
  //         debugLog('callback: banner31 ad loaded');
  //       },
  //       onAdFailedToLoad: (error) {
  //         isLoading31.value = false;
  //         debugLog('callback: banner31 ad failed to load, '
  //             'code: ${error.code}, description: ${error.description}');
  //       },
  //       onAdClicked: () => debugLog('callback: banner31 ad clicked'),
  //       onLeftApplication: () => debugLog('callback: left app'),
  //       onReturnedToApplication: () => debugLog('callback: returned to app'),
  //       onImpression: (data) => debugLog('callback: impression: ${data.getRawData()}'),
  //     );
  //
  // Future<void> _loadBanner21() async {
  //   debugLog('load banner21');
  //   await Future<void>.delayed(const Duration(seconds: 1));
  //   if (!mounted) return;
  //
  //   isLoading21.value = true;
  //   if (isBannerAlreadyCreated21.value) {
  //     debugLog('isBannerAlreadyCreated21');
  //     await banner21.loadAd(adRequest: adRequest21);
  //     isLoading21.value = false;
  //   } else {
  //     debugLog('else isBannerAlreadyCreated21');
  //     double itemWidth = (context.kSize.width - 48) / 2;
  //
  //     final iPadOrTablet = context.kSize.width > 600;
  //     if (iPadOrTablet) {
  //       itemWidth = (context.kSize.width - 100) / 4;
  //     }
  //     final double itemHeight = itemWidth * 1.5 + 100;
  //
  //     final adSize = BannerAdSize.inline(
  //       width: itemWidth.toInt(),
  //       maxHeight: itemHeight.toInt(),
  //     );
  //     final calculatedBannerSize = await adSize.getCalculatedBannerAdSize();
  //     debugLog('calculatedBannerSize: ${calculatedBannerSize.toString()}');
  //     banner21 = _createBanner21(adSize);
  //
  //     isBannerAlreadyCreated21.value = true;
  //     isLoading21.value = false;
  //   }
  // }
  //
  // BannerAd _createBanner21(BannerAdSize adSize) => BannerAd(
  //       adUnitId: Constants.banner21Id,
  //       adSize: adSize,
  //       adRequest: adRequest21,
  //       onAdLoaded: () {
  //         isLoading21.value = false;
  //         debugLog('callback: banner21 ad loaded');
  //       },
  //       onAdFailedToLoad: (error) {
  //         isLoading21.value = false;
  //         debugLog('callback: banner21 ad failed to load, '
  //             'code: ${error.code}, description: ${error.description}');
  //       },
  //       onAdClicked: () => debugLog('callback: banner21 ad clicked'),
  //       onLeftApplication: () => debugLog('callback: left app'),
  //       onReturnedToApplication: () => debugLog('callback: returned to app'),
  //       onImpression: (data) => debugLog('callback: impression: ${data.getRawData()}'),
  //     );

  Future<void> _loadBanner11() async {
    debugLog('load banner11');
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    isLoading11.value = true;
    if (isBannerAlreadyCreated11.value) {
      debugLog('isBannerAlreadyCreated11');
      await banner11.loadAd(adRequest: adRequest11);
      isLoading11.value = false;
    } else {
      debugLog('else isBannerAlreadyCreated11');
      double itemWidth = (context.kSize.width - 48) / 2;

      final iPadOrTablet = context.kSize.width > 600;
      if (iPadOrTablet) {
        itemWidth = (context.kSize.width - 100) / 4;
      }
      final double itemHeight = itemWidth * 1.5 + 100;

      final adSize = BannerAdSize.inline(
        width: itemWidth.toInt(),
        maxHeight: itemHeight.toInt(),
      );
      final calculatedBannerSize = await adSize.getCalculatedBannerAdSize();
      debugLog('calculatedBannerSize: ${calculatedBannerSize.toString()}');
      banner11 = _createBanner11(adSize);

      isBannerAlreadyCreated11.value = true;
      isLoading11.value = false;
    }
  }

  BannerAd _createBanner11(BannerAdSize adSize) => BannerAd(
        adUnitId: Constants.banner11Id,
        adSize: adSize,
        adRequest: adRequest11,
        onAdLoaded: () {
          isLoading11.value = false;
          debugLog('callback: banner11 ad loaded');
        },
        onAdFailedToLoad: (error) {
          isLoading11.value = false;
          debugLog('callback: banner11 ad failed to load, '
              'code: ${error.code}, description: ${error.description}');
        },
        onAdClicked: () => debugLog('callback: banner11 ad clicked'),
        onLeftApplication: () => debugLog('callback: left app'),
        onReturnedToApplication: () => debugLog('callback: returned to app'),
        onImpression: (data) => debugLog('callback: impression: ${data.getRawData()}'),
      );

  Widget _productShimmerWidget({
    required BuildContext context,
    required double itemWidth,
    required double itemHeight,
    required double textHeight,
  }) =>
      SizedBox(
        // height: itemHeight,
        width: itemWidth,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.color.lightGrey2,
            borderRadius: AppUtils.kBorderRadius12,
            // border: Border.all(
            // color: context.color.lightGrey2,
            // ),
          ),
          child: Shimmer.fromColors(
            baseColor: context.color.white,
            highlightColor: context.color.lightGrey2,
            period: const Duration(seconds: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// for image
                DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: AppUtils.kBorderRadiusOnlyTop12,
                  ),
                  child: SizedBox(
                    height: itemHeight - textHeight,
                    width: itemWidth * 1.1,
                  ),
                ),
                AppUtils.kGap4,

                /// for text
                Padding(
                  padding: AppUtils.kPaddingHorizontal4,
                  child: Column(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: context.color.white,
                          borderRadius: AppUtils.kBorderRadius12,
                        ),
                        child: SizedBox(
                          height: textHeight / 5,
                          width: itemWidth,
                        ),
                      ),
                      AppUtils.kGap4,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: context.color.white,
                            borderRadius: AppUtils.kBorderRadius12,
                          ),
                          child: SizedBox(
                            height: textHeight / 5,
                            width: itemWidth / 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AppUtils.kGap4,

                /// for like and count
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 12,
                    ),
                    AppUtils.kGap6,

                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 12,
                    ),
                    AppUtils.kGap6,
                    // DecoratedBox(
                    //   decoration: BoxDecoration(
                    //     color: context.color.white,
                    //     // borderRadius: AppUtils.kBorderRadius12,
                    //     shape: BoxShape.circle,
                    //   ),
                    //   child: SizedBox(
                    //     height: textHeight * .02,
                    //     width: textHeight * .02,
                    //   ),
                    // ),
                    // AppUtils.kGap6,
                    // DecoratedBox(
                    //   decoration: BoxDecoration(
                    //     color: context.color.white,
                    //     // borderRadius: AppUtils.kBorderRadius12,
                    //     shape: BoxShape.circle,
                    //   ),
                    //   child: SizedBox(
                    //     height: textHeight * .02,
                    //     width: textHeight * .02,
                    //   ),
                    // ),
                  ],
                ),
                AppUtils.kGap6,
              ],
            ),
          ),
        ),
      );
  Widget _categoryShimmerWidget() => SizedBox(
        height: 56,
        width: context.kSize.width / 4,
        child: Shimmer.fromColors(
          highlightColor: context.color.white,
          baseColor: context.color.lightGrey2,
          period: const Duration(seconds: 2),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.color.white,
              borderRadius: AppUtils.kBorderRadius12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// for text
                Padding(
                  padding: AppUtils.kPaddingHorizontal4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.color.white,
                      borderRadius: AppUtils.kBorderRadius4,
                    ),
                    child: SizedBox(
                      height: 20,
                      width: context.kSize.width / 4.4,
                    ),
                  ),
                ),
                AppUtils.kGap4,
              ],
            ),
          ),
        ),
      );

  @override
  void dispose() {
    tabController.dispose();
    scrollController.dispose();
    selectedTab.dispose();
    super.dispose();
  }
}
