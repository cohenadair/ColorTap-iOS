import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobile/wrappers/banner_ad_wrapper.dart';

import '../log.dart';
import '../managers/properties_manager.dart';
import '../utils/ad_utils.dart';

class AdBanner extends StatefulWidget {
  const AdBanner();

  @override
  State<AdBanner> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBanner> {
  static const _log = Log("_AdBannerWidgetState");

  BannerAd? _bannerAd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AdSize.banner.width.toDouble(),
      height: AdSize.banner.height.toDouble(),
      child: _bannerAd == null
          ? Container()
          : BannerAdWrapper.get.newWidget(ad: _bannerAd!),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  /// Loads a banner ad.
  void _loadAd() {
    final bannerAd = BannerAdWrapper.get.newAd(
      size: AdSize.banner,
      adUnitId: _adUnitId(),
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() => _bannerAd = ad as BannerAd);
        },
        onAdFailedToLoad: (ad, error) {
          _log.e(StackTrace.current, "Error loading ad: $error");
          ad.dispose();
        },
      ),
    );

    bannerAd.load();
  }

  String _adUnitId() {
    return adUnitId(
      androidTestId: "ca-app-pub-3940256099942544/6300978111",
      iosTestId: "ca-app-pub-3940256099942544/2934735716",
      androidRealId: PropertiesManager.get.adBannerUnitIdAndroid,
      iosRealId: PropertiesManager.get.adBannerUnitIdIos,
    );
  }
}
