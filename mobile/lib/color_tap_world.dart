import 'dart:async' as async;
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:mobile/difficulty.dart';
import 'package:mobile/managers/preference_manager.dart';

import 'components/target.dart';
import 'components/target_board.dart';
import 'effects/target_board_rewind_effect.dart';
import 'managers/lives_manager.dart';
import 'managers/time_manager.dart';
import 'target_color.dart';
import 'utils/dimens.dart';
import 'utils/overlay_utils.dart';

class ColorTapWorld extends World with HasGameRef, Notifier {
  final _board1Key = ComponentKey.unique();
  final _board2Key = ComponentKey.unique();

  late double _speed;
  late int _colorResetMod;
  late TargetColor _color;

  var _score = 0;
  var scrollingPaused = true;

  /// If set, a "grace period" is active, where users are allowed to miss
  /// targets. This is to prevent immediate loss after a color change due
  /// to the new colour already being at the bottom of the screen.
  int? _gracePeriod;
  async.Timer? _gracePeriodTimer;

  double get speed => _speed;

  TargetColor get color => _color;

  int get score => _score;

  int? get gracePeriod => _gracePeriod;

  Difficulty get _difficulty => PreferenceManager.get.difficulty;

  @override
  void onLoad() {
    scrollingPaused = true;
    _resetForNewGame();

    game.overlays.add(overlayIdScoreboard);
    game.overlays.add(overlayIdMainMenu);

    add(FpsTextComponent(
      priority: 1,
      position: Vector2(paddingDefault, 150),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.green,
          fontSize: 20,
        ),
      ),
    ));

    add(TargetBoard(
      verticalStartFactor: 2,
      otherBoardKey: _board2Key,
      key: _board1Key,
      isUpdater: true,
    ));
    add(TargetBoard(
      verticalStartFactor: 1,
      otherBoardKey: _board1Key,
      key: _board2Key,
      isUpdater: false,
    ));
  }

  void handleTargetHit({required bool isCorrect}) {
    if (isCorrect) {
      // The amount of speed added after each touch is dependent on the screen
      // size to narrow the difficulty gap between different devices.
      _speed += game.size.y * _difficulty.incSpeedBy;
      _score++;

      if (PreferenceManager.get.colorIndex == null &&
          _score % _colorResetMod == 0) {
        // Ensure color always changes.
        _color = TargetColor.random(exclude: _color);
        _startGracePeriod();
        _updateColorResetMod();
      }
    } else {
      // Kids mode has infinite lives.
      if (_difficulty != Difficulty.kids) {
        LivesManager.get.loseLife();
      }
      game.overlays.add(overlayIdGameOver);
      PreferenceManager.get.updateCurrentHighScore(score);
    }

    notifyListeners();
  }

  void handleTargetMissed(Target target, TargetBoard board) {
    scrollingPaused = true;

    board.add(TargetBoardRewindEffect(
      game: game,
      onComplete: () => target.pulse(),
    ));
    _targetBoard(board.otherBoardKey).add(TargetBoardRewindEffect(game: game));
  }

  void play() {
    _targetBoard(_board1Key).resetForNewGame();
    _targetBoard(_board2Key).resetForNewGame();

    scrollingPaused = false;
    _resetForNewGame();
    notifyListeners();

    game.overlays.removeAll([overlayIdMainMenu, overlayIdGameOver]);
  }

  TargetBoard _targetBoard(ComponentKey key) =>
      game.findByKey(key) as TargetBoard;

  void _startGracePeriod() {
    _gracePeriod =
        TimeManager.get.millisSinceEpoch + _difficulty.colorChangeGracePeriodMs;

    _gracePeriodTimer?.cancel();
    _gracePeriodTimer = async.Timer(
      Duration(milliseconds: _difficulty.colorChangeGracePeriodMs),
      () => _gracePeriod = null,
    );
  }

  void _updateColorResetMod() {
    var min = _difficulty.colorChangeFrequencyRange.$1;
    var max = _difficulty.colorChangeFrequencyRange.$2;
    _colorResetMod = min == max ? min : min + Random().nextInt(max - min);
  }

  void _resetForNewGame() {
    _speed = _difficulty.startSpeed;
    _color = TargetColor.fromPreferences();
    _score = 0;
    _gracePeriod = null;
    _updateColorResetMod();
  }
}
