import 'package:flutter/material.dart';
import 'package:mobile/managers/preference_manager.dart';

import 'color_tap_game.dart';
import 'color_tap_game_widget.dart';
import 'color_tap_world.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceManager.get.init();
  final myGame = ColorTapGame(world: ColorTapWorld());
  runApp(ColorTapGameWidget(myGame));
}
