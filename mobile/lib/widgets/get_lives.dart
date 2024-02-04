import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobile/managers/lives_manager.dart';
import 'package:mobile/managers/purchases_manager.dart';
import 'package:mobile/utils/context_utils.dart';
import 'package:mobile/utils/dimens.dart';
import 'package:mobile/utils/alert_utils.dart';
import 'package:mobile/utils/theme.dart';
import 'package:mobile/wrappers/internet_address_wrapper.dart';
import 'package:mobile/wrappers/purchases_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../log.dart';
import '../managers/properties_manager.dart';
import '../wrappers/platform_wrapper.dart';
import '../wrappers/rewarded_ad_wrapper.dart';
import 'animated_visibility.dart';
import 'loading.dart';

class GetLives extends StatefulWidget {
  final String title;

  const GetLives(this.title);

  @override
  State<GetLives> createState() => _GetLivesState();
}

class _GetLivesState extends State<GetLives> {
  static const _buyOptionCornerRadius = 15.0;
  static const _log = Log("GetLives");

  late Future<Offerings> _offeringsFuture;

  String? _inProgressTierId;

  @override
  void initState() {
    super.initState();
    _offeringsFuture = PurchasesWrapper.get.getOfferings();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSeparator(widget.title),
        _buildBuyOptions(),
        _buildSeparator("OR"),
        _AdOption(),
      ],
    );
  }

  Widget _buildSeparator(String text) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: insetsDefault,
          child: Text(text),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildBuyOptions() {
    return FutureBuilder<Offerings>(
      future: _offeringsFuture,
      builder: (context, snapshot) {
        return Stack(
          children: [
            _buildFillingLoading(isVisible: !snapshot.hasData),
            AnimatedVisibility(
              isVisible: snapshot.hasData,
              child: Column(
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: paddingDefault,
                    children: [
                      _buildBuyOption(snapshot.data, LivesTier.one),
                      _buildBuyOption(snapshot.data, LivesTier.two),
                      _buildBuyOption(snapshot.data, LivesTier.three),
                    ].whereNotNull().toList(),
                  ),
                  const Text(
                    "Life purchases are non-refundable and do not sync across devices. Purchased lives will be lost if the app is uninstalled.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget? _buildBuyOption(Offerings? offerings, LivesTier tier) {
    if (offerings == null) {
      // Offerings haven't loaded yet. Render a placeholder option so the
      // loading widget renders at the correct size.
      return _buildBuyOptionButton();
    }

    var package = offerings
        .getOffering("lives")
        ?.availablePackages
        .firstWhereOrNull((e) => e.identifier == tier.id);

    if (package == null) {
      _log.e(StackTrace.current, "Can't find package for lives ${tier.id}");
      return null;
    }

    return Padding(
      padding: insetsBottomDefault,
      child: _buildBuyOptionButton(tier, package),
    );
  }

  Widget _buildBuyOptionButton([LivesTier? tier, Package? package]) {
    var isLoading = _inProgressTierId != null && _inProgressTierId == tier?.id;

    return FilledButton(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_buyOptionCornerRadius),
        ),
      ),
      onPressed: () => _purchaseLives(tier, package),
      child: Padding(
        padding: insetsVerticalDefault,
        child: Stack(
          children: [
            _buildFillingLoading(isVisible: isLoading),
            AnimatedVisibility(
              isVisible: !isLoading,
              child: Column(
                children: [
                  Text(
                    (tier?.numberOfLives ?? 0).toString(),
                    style: Theme.of(context).textTheme.titleLarge?.makeBold(),
                  ),
                  const Text("lives for"),
                  Text(package?.storeProduct.priceString ?? ""),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _purchaseLives(LivesTier? tier, Package? package) async {
    if (_inProgressTierId != null || tier == null || package == null) {
      return;
    }

    setState(() => _inProgressTierId = package.identifier);

    if (await PurchasesManager.get.purchase(package) != null) {
      LivesManager.get.incLives(tier.numberOfLives);
    }

    setState(() => _inProgressTierId = null);
  }

  Widget _buildFillingLoading({bool isVisible = false}) {
    return Positioned.fill(
      child: Visibility(
        visible: isVisible,
        child: const Center(child: Loading()),
      ),
    );
  }
}

class _AdOption extends StatefulWidget {
  @override
  State<_AdOption> createState() => _AdOptionState();
}

class _AdOptionState extends State<_AdOption> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton.icon(
          icon: _isLoading ? const Loading() : const SizedBox(),
          label: const Text("Watch Short Ad"),
          onPressed: _loadAd,
        ),
        const Text(
            "Watching a short ad will earn you ${LivesManager.rewardedAdAmount} lives."),
      ],
    );
  }

  void _loadAd() async {
    if (_isLoading) {
      return;
    }

    if (!await InternetAddressWrapper.get.isConnected) {
      safeUseContext(
        this,
        () => showErrorSnackBar(context,
            "Network is disconnected. Please connect to the internet and try again."),
      );
      return;
    }

    setState(() => _isLoading = true);

    RewardedAdWrapper.get.load(
      adUnitId: _adUnitId(),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.show(
            onUserEarnedReward: (_, __) => LivesManager.get.rewardWatchedAd(),
          );
          setState(() => _isLoading = false);
        },
        onAdFailedToLoad: (error) {
          debugPrint("Error loading ad: $error");
          setState(() => _isLoading = false);
          showErrorDialog(
            context,
            "There was an error loading the ad. Here's ${LivesManager.adErrorReward} lives for the inconvenience.",
            onDismissed: () => LivesManager.get.rewardAdError(),
          );
        },
      ),
    );
  }

  String _adUnitId() {
    if (PlatformWrapper.get.isDebug) {
      return PlatformWrapper.get.isAndroid
          ? "ca-app-pub-3940256099942544/5224354917"
          : "ca-app-pub-3940256099942544/1712485313";
    } else {
      return PlatformWrapper.get.isAndroid
          ? PropertiesManager.get.adUnitIdAndroid
          : PropertiesManager.get.adUnitIdApple;
    }
  }
}

@immutable
class LivesTier {
  static const one = LivesTier._(15, "lives-1");
  static const two = LivesTier._(75, "lives-2");
  static const three = LivesTier._(500, "lives-3");

  final int numberOfLives;
  final String id;

  const LivesTier._(this.numberOfLives, this.id);
}
