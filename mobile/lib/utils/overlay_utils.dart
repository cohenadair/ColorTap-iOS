import 'package:flutter/material.dart';
import 'package:mobile/color_tap_game.dart';
import 'package:mobile/overlays/instructions.dart';
import 'package:mobile/overlays/menu.dart';
import 'package:mobile/overlays/scoreboard.dart';

const overlayIdMainMenu = "main_menu";
const overlayIdGameOver = "game_over";
const overlayIdScoreboard = "scoreboard";
const overlayIdInstructions = "instructions";

Widget buildMainMenu(BuildContext context, ColorTapGame game) =>
    Menu.main(game);

Widget buildGameOver(BuildContext context, ColorTapGame game) =>
    Menu.gameOver(game);

Widget buildScoreboard(BuildContext context, ColorTapGame game) =>
    Scoreboard(game);

Widget buildInstructions(BuildContext context, ColorTapGame game) =>
    Instructions(game);
