import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../utils/properties_file.dart';

/// A class for accessing data in configuration files.
class PropertiesManager {
  static var _instance = PropertiesManager._();

  static PropertiesManager get get => _instance;

  @visibleForTesting
  static void set(PropertiesManager manager) => _instance = manager;

  @visibleForTesting
  static void suicide() => _instance = PropertiesManager._();

  PropertiesManager._();

  final String _keyAdRewardedUnitIdIos = "adRewardedUnitId.ios";
  final String _keyAdRewardedUnitIdAndroid = "adRewardedUnitId.android";
  final String _keyAdBannerUnitIdIos = "adBannerUnitId.ios";
  final String _keyAdBannerUnitIdAndroid = "adBannerUnitId.android";
  final String _keyRevenueCatApple = "revenueCat.apple";
  final String _keyRevenueCatAndroid = "revenueCat.android";
  final String _keySupportEmail = "support.email";
  final String _keySendGridApiKey = "sendGrid.apikey";
  final String _keyClientSenderEmail = "clientSender.email";

  final String _path = "assets/sensitive.properties";
  final String _feedbackTemplatePath = "assets/feedback_template";

  late PropertiesFile _properties;
  late String _feedbackTemplate;

  Future<void> init() async {
    _properties = PropertiesFile(await rootBundle.loadString(_path));
    _feedbackTemplate = await rootBundle.loadString(_feedbackTemplatePath);
  }

  String get adRewardedUnitIdIos =>
      _properties.stringForKey(_keyAdRewardedUnitIdIos);

  String get adRewardedUnitIdAndroid =>
      _properties.stringForKey(_keyAdRewardedUnitIdAndroid);

  String get adBannerUnitIdIos =>
      _properties.stringForKey(_keyAdBannerUnitIdIos);

  String get adBannerUnitIdAndroid =>
      _properties.stringForKey(_keyAdBannerUnitIdAndroid);

  String get revenueCatKeyApple =>
      _properties.stringForKey(_keyRevenueCatApple);

  String get revenueCatKeyAndroid =>
      _properties.stringForKey(_keyRevenueCatAndroid);

  String get supportEmail => _properties.stringForKey(_keySupportEmail);

  String get sendGridApiKey => _properties.stringForKey(_keySendGridApiKey);

  String get clientSenderEmail =>
      _properties.stringForKey(_keyClientSenderEmail);

  String get feedbackTemplate => _feedbackTemplate;
}
