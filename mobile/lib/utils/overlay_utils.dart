import 'package:flutter/material.dart';
import 'package:mobile/color_tap_game.dart';
import 'package:mobile/overlays/menu.dart';

const overlayMainMenuId = "main_menu";
const overlayGameOverId = "game_over";

Widget buildMainMenu(BuildContext context, ColorTapGame game) =>
    Menu.main(game: game);

Widget buildGameOver(BuildContext context, ColorTapGame game) =>
    Menu.gameOver(game: game);
