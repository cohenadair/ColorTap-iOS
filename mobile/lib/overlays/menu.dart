import 'package:flutter/material.dart';
import 'package:mobile/color_tap_game.dart';
import 'package:mobile/managers/lives_manager.dart';
import 'package:mobile/pages/settings_page.dart';
import 'package:mobile/utils/dimens.dart';
import 'package:mobile/utils/theme.dart';
import 'package:mobile/widgets/get_lives.dart';
import 'package:mobile/widgets/remaining_lives.dart';

import '../pages/store_page.dart';
import '../utils/colors.dart';
import '../utils/page_utils.dart';

class Menu extends StatelessWidget {
  static const _titleSize = 50.0;
  static const _scoreSize = 100.0;

  final ColorTapGame game;
  final String title;
  final String playText;
  final bool hideScore;

  const Menu.main({
    required this.game,
  })  : title = "Color Tap Coordination",
        playText = "Play",
        hideScore = true;

  const Menu.gameOver({
    required this.game,
  })  : title = "Game Over",
        playText = "Play Again",
        hideScore = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme(context),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: SafeArea(
                  child: Padding(
                    padding: insetsDefault,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        _buildTitle(),
                        _buildLives(),
                        _buildScore(),
                        _buildGetLives(context),
                        const Spacer(),
                        _buildPlayButton(),
                        _buildStoreButton(context),
                        _buildSettingsButton(context),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: _titleSize,
        color: colorLightText,
      ),
    );
  }

  Widget _buildLives() {
    return const RemainingLives();
  }

  Widget _buildScore() {
    if (hideScore) {
      return Container();
    }

    return Text(
      game.world.score.toString(),
      style: const TextStyle(
        fontSize: _scoreSize,
        color: colorLightText,
      ),
    );
  }

  Widget _buildGetLives(BuildContext context) {
    return StreamBuilder(
      stream: LivesManager.get.stream,
      builder: (context, _) {
        if (LivesManager.get.canPlay) {
          return Container();
        }

        return Padding(
          padding: insetsVerticalDefault,
          child: Column(
            children: [
              Text(
                "Uh oh! You are out of lives!",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const GetLives("BUY MORE"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlayButton() {
    return StreamBuilder(
      stream: LivesManager.get.stream,
      builder: (context, _) => LivesManager.get.canPlay
          ? FilledButton(
              onPressed: game.world.play,
              child: Text(playText),
            )
          : const SizedBox(),
    );
  }

  Widget _buildStoreButton(BuildContext context) {
    return FilledButton(
      onPressed: () => present(context, StorePage()),
      child: const Text("Store"),
    );
  }

  Widget _buildSettingsButton(BuildContext context) {
    return FilledButton(
      onPressed: () => present(context, SettingsPage()),
      child: const Text("Settings"),
    );
  }
}
