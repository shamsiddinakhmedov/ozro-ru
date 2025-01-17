/*
late final Future<RewardedAdLoader> _adLoader = _createRewardedAdLoader();
  late RewardedAd? _ad;


  bool isLoading = false;

  @override
  void initState() {
    MobileAds.initialize();

    // _adLoader = _createRewardedAdLoader();
    // _loadRewardedAd();
    scrollController = ScrollController()..addListener(_onScroll);
    super.initState();
  }

  Future<RewardedAdLoader> _createRewardedAdLoader() => RewardedAdLoader.create(
        onAdLoaded: (rewardedAd) {
          debugLog('onAdLoaded');
          debugLog(rewardedAd);
          // The ad was loaded successfully. Now you can show loaded ad
          _ad = rewardedAd;
          _showAd();
        },
        onAdFailedToLoad: (error) {
          debugLog('onAdFailedToLoad');
          debugLog(error);
          // Ad failed to load with AdRequestError.
          // Attempting to load a new ad from the onAdFailedToLoad() method is strongly discouraged.
        },
      );

  Future<void> _loadRewardedAd() async {
    final adLoader = await _adLoader;
    await adLoader.loadAd(
        adRequestConfiguration: const AdRequestConfiguration(
            adUnitId: 'demo-rewarded-yandex')); // For debugging, you can use 'demo-rewarded-yandex'
  }

  Future<void> _showAd() async {
    await _ad?.setAdEventListener(
        eventListener: RewardedAdEventListener(onAdShown: () {
      // Called when an ad is shown.
    }, onAdFailedToShow: (error) {
      // Called when an ad failed to show.
      // Destroy the ad so you don't show the ad a second time.
      _ad?.destroy();
      _ad = null;

      // Now you can preload the next ad.
      _loadRewardedAd();
    }, onAdClicked: () {
      // Called when a click is recorded for an ad.
    }, onAdDismissed: () {
      // Called when ad is dismissed.
      // Destroy the ad so you don't show the ad a second time.
      _ad?.destroy();
      _ad = null;

      // Now you can preload the next ad.
      // _loadRewardedAd();
    }, onAdImpression: (impressionData) {
      // Called when an impression is recorded for an ad.
    }, onRewarded: (reward) {
      // Called when the user can be rewarded.
    }));

    await _ad?.show();
    final reward = await _ad?.waitForDismiss();
    if (reward != null) {
      debugLog('got ${reward.amount} of ${reward.type}');
    }
  }


 */