import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobile/managers/preference_manager.dart';
import 'package:mobile/managers/properties_manager.dart';

import 'color_tap_game.dart';
import 'color_tap_game_widget.dart';
import 'color_tap_world.dart';
import 'managers/purchases_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await PreferenceManager.get.init();
  await PropertiesManager.get.init();
  await PurchasesManager.get.init();

  final myGame = ColorTapGame(world: ColorTapWorld());
  runApp(ColorTapGameWidget(myGame));
}
