import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/constants/constants.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

class BannerAdsWidget extends StatefulWidget {
  const BannerAdsWidget({
    super.key,
    required this.child,
    required this.index,
    required this.isLoading,
    required this.isDismissed,
    required this.banner,
  });

  final Widget child;
  final ValueNotifier<bool> isLoading;
  final ValueNotifier<bool> isDismissed;
  final int index;
  final BannerAd banner;

  @override
  State<BannerAdsWidget> createState() => _BannerAdsWidgetState();
}

class _BannerAdsWidgetState extends State<BannerAdsWidget> {
  final ValueNotifier<bool> isDismissed = ValueNotifier(false);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<bool> isBannerAlreadyCreated = ValueNotifier(false);

  final AdRequest adRequest = const AdRequest();

  late BannerAd banner;

  Future<void> _loadBanner({required String bannerId}) async {
    debugLog('load banner');
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    isLoading.value = true;
    if (isBannerAlreadyCreated.value) {
      debugLog('isBannerAlreadyCreated');
      await banner.loadAd(adRequest: adRequest,);
    } else {
      debugLog('else isBannerAlreadyCreated');
      double itemWidth = (context.kSize.width - 48) / 2;

      final iPadOrTablet = context.kSize.width > 600 ;
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
      banner = _createBanner(adSize, bannerId: bannerId);

      isBannerAlreadyCreated.value = true;
    }
  }

  BannerAd _createBanner(BannerAdSize adSize, {required String bannerId}) => BannerAd(
        adUnitId: bannerId,
        adSize: adSize,
        adRequest: adRequest,
        onAdLoaded: () {
          setState(() {
            isLoading.value = false;
          });
          debugLog('callback: banner ad loaded with $bannerId');
        },
        onAdFailedToLoad: (error) {
          setState(() => isLoading.value = false);
          debugLog('callback: banner ad failed to load, '
              'code: ${error.code}, description: ${error.description}');
        },
        onAdClicked: () => debugLog('callback: banner ad clicked'),
        onLeftApplication: () => debugLog('callback: left app'),
        onReturnedToApplication: () => debugLog('callback: returned to app'),
        onImpression: (data) => debugLog('callback: impression: ${data.getRawData()}'),
      );

  @override
  void initState() {
    _loadBanner(
      bannerId: widget.index == 30
          ? Constants.banner31Id
          : widget.index == 20
              ?  Constants.banner21Id
              : widget.index == 10
                  ?  'R-M-11735697-6'//'R-M-11735697-3' //'R-M-11735697-2'
          : '',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        key: widget.key,
        valueListenable: widget.isLoading,
        builder: (_, value, __) => ClipRRect(
          borderRadius: AppUtils.kBorderRadius12,
          child:
              value
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeCap: StrokeCap.round,
                        color: context.colorScheme.primary,
                      ),
                    )
                  :
               ValueListenableBuilder(
                      valueListenable: isDismissed,
                      builder: (context, value, child) => value
                          ? widget.child
                          : AdWidget(
                              key: widget.key,
                              bannerAd: widget.banner,
                            ),
                    ),
        ),
      );
}
