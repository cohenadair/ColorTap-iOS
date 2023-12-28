import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mobile/colour_tap_world.dart';

void main() {
  final myGame = FlameGame(world: ColourTapWorld());
  runApp(GameWidget(game: myGame));
}
