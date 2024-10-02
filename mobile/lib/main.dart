import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobile/managers/audio_manager.dart';
import 'package:mobile/managers/preference_manager.dart';
import 'package:mobile/managers/properties_manager.dart';
import 'package:mobile/managers/stats_manager.dart';

import 'tapd_game.dart';
import 'tapd_game_widget.dart';
import 'tapd_world.dart';
import 'managers/purchases_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  // Init game settings.
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  // Init singletons.
  await MobileAds.instance.initialize();
  await PreferenceManager.get.init();
  await PropertiesManager.get.init();
  await PurchasesManager.get.init();
  await AudioManager.get.init();
  await StatsManager.get.init();

  final myGame = TapdGame(world: TapdWorld());
  runApp(TapdGameWidget(myGame));
}
