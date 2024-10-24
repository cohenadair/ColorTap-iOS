import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/strings.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobile/managers/lives_manager.dart';
import 'package:mobile/managers/purchases_manager.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/context_utils.dart';
import 'package:mobile/utils/dimens.dart';
import 'package:mobile/utils/alert_utils.dart';
import 'package:mobile/wrappers/connection_wrapper.dart';
import 'package:mobile/wrappers/purchases_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../log.dart';
import '../managers/audio_manager.dart';
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
  static const _maxWidth = 500.0; // Arbitrary value that looks fine on tablets.
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
    return Container(
      constraints: const BoxConstraints(maxWidth: _maxWidth),
      child: Column(
        children: [
          _buildSeparator(widget.title),
          _buildBuyOptions(),
          _buildSeparator(Strings.of(context).or),
          _AdOption(),
        ],
      ),
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
                  Text(
                    Strings.of(context).getLivesRefundableMessage,
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
        padding: insetsDefault,
      ),
      onPressed:
          AudioManager.get.onButtonPressed(() => _purchaseLives(tier, package)),
      child: Stack(
        children: [
          _buildFillingLoading(isVisible: isLoading),
          AnimatedVisibility(
            isVisible: !isLoading,
            child: Column(
              children: [
                Text(
                  (tier?.numberOfLives ?? 0).toString(),
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                  ),
                ),
                Text(Strings.of(context).getLivesQuantityMessage),
                Text(package?.storeProduct.priceString ?? ""),
              ],
            ),
          ),
        ],
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
      child: Center(child: Loading(isVisible: isVisible)),
    );
  }
}

class _AdOption extends StatefulWidget {
  @override
  State<_AdOption> createState() => _AdOptionState();
}

class _AdOptionState extends State<_AdOption> {
  static const _log = Log("_AdOptionState");

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton.icon(
          icon: _isLoading
              ? const Padding(
                  padding: insetsRightSmall,
                  child: Loading(color: colorDarkText),
                )
              : const SizedBox(),
          label: Text(Strings.of(context).getLivesWatchAd),
          onPressed: _loadAd,
        ),
        const SizedBox(height: paddingSmall),
        Text(
          Strings.of(context)
              .getLivesAdRewardMessage(LivesManager.rewardedAdAmount),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _loadAd() async {
    if (_isLoading) {
      return;
    }

    if (!await ConnectionWrapper.get.hasInternetAddress) {
      safeUseContext(this, () => showNetworkErrorSnackBar(context));
      return;
    }

    setState(() => _isLoading = true);

    RewardedAdWrapper.get.load(
      adUnitId: _adUnitId(),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          AudioManager.get.pauseMusic();

          // Resume music when ad is closed by the user.
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (_) =>
                AudioManager.get.resumeMusic(),
          );

          ad.show(
            onUserEarnedReward: (_, __) => LivesManager.get.rewardWatchedAd(),
          );

          setState(() => _isLoading = false);
        },
        onAdFailedToLoad: (error) {
          _log.e(StackTrace.current, "Error loading ad: $error");
          setState(() => _isLoading = false);
          showErrorDialog(
            context,
            Strings.of(context)
                .getLivesAdErrorMessage(LivesManager.adErrorReward),
            onDismissed: () => LivesManager.get.rewardAdError(),
          );
          AudioManager.get.resumeMusic();
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
