import 'package:flutter/material.dart';
import 'package:mobile/color_tap_game.dart';
import 'package:mobile/overlays/menu.dart';
import 'package:mobile/overlays/scoreboard.dart';

const overlayIdMainMenu = "main_menu";
const overlayIdGameOver = "game_over";
const overlayIdScoreboard = "scoreboard";

Widget buildMainMenu(BuildContext context, ColorTapGame game) =>
    Menu.main(game: game);

Widget buildGameOver(BuildContext context, ColorTapGame game) =>
    Menu.gameOver(game: game);

Widget buildScoreboard(BuildContext context, ColorTapGame game) =>
    Scoreboard(game: game);
