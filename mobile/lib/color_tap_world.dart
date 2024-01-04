import 'dart:async' as async;

import 'package:flame/components.dart';
import 'package:mobile/components/scoreboard.dart';
import 'package:mobile/components/target_board.dart';
import 'package:mobile/effects/target_board_rewind_effect.dart';
import 'package:mobile/utils/overlay_utils.dart';

import 'components/target.dart';
import 'managers/time_manager.dart';
import 'target_color.dart';

class ColorTapWorld extends World with HasGameRef, Notifier {
  static const _startSpeed = 3.5;
  static const _incSpeedFactor = 0.00005;
  static const _colorResetMod = 10;
  static const _gracePeriodMs = 2000;

  final _board1Key = ComponentKey.unique();
  final _board2Key = ComponentKey.unique();

  var _speed = _startSpeed;

  double get speed => _speed;

  var _color = TargetColor.random();

  TargetColor get color => _color;

  var _score = 0;

  int get score => _score;

  var scrollingPaused = true;

  /// If set, a "grace period" is active, where users are allowed to miss
  /// targets. This is to prevent immediate loss after a color change due
  /// to the new colour already being at the bottom of the screen.
  int? _gracePeriod;

  int? get gracePeriod => _gracePeriod;

  async.Timer? _gracePeriodTimer;

  @override
  void onLoad() {
    game.overlays.add(overlayMainMenuId);

    add(FpsTextComponent(
      priority: 1,
      position: Vector2(20, 80),
    ));

    add(Scoreboard());

    add(TargetBoard(
      verticalStartFactor: 2,
      otherBoardKey: _board2Key,
      key: _board1Key,
    ));
    add(TargetBoard(
      verticalStartFactor: 1,
      otherBoardKey: _board1Key,
      key: _board2Key,
    ));
  }

  void handleTargetHit({required bool isCorrect}) {
    if (isCorrect) {
      // The amount of speed added after each touch is dependent on the screen
      // size to narrow the difficulty gap between different devices.
      _speed += game.size.y * _incSpeedFactor;
      _score++;

      if (_score % _colorResetMod == 0) {
        // Ensure color always changes.
        _color = TargetColor.random(exclude: _color);
        _startGracePeriod();
      }
    } else {
      game.overlays.add(overlayGameOverId);
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
    _targetBoard(_board1Key).reset();
    _targetBoard(_board2Key).reset();

    _speed = _startSpeed;
    _color = TargetColor.random(exclude: _color);
    _score = 0;
    _gracePeriod = null;
    scrollingPaused = false;
    notifyListeners();

    game.overlays.removeAll([overlayMainMenuId, overlayGameOverId]);
  }

  TargetBoard _targetBoard(ComponentKey key) =>
      game.findByKey(key) as TargetBoard;

  void _startGracePeriod() {
    _gracePeriod = TimeManager.get.millisSinceEpoch + _gracePeriodMs;

    _gracePeriodTimer?.cancel();
    _gracePeriodTimer = async.Timer(
      const Duration(milliseconds: _gracePeriodMs),
      () => _gracePeriod = null,
    );
  }
}
