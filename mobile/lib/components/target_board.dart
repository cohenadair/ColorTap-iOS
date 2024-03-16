import 'dart:async';

import 'package:flame/components.dart';
import 'package:mobile/color_tap_world.dart';
import 'package:mobile/utils/target_utils.dart';

import '../managers/preference_manager.dart';
import 'target.dart';

class TargetBoard extends PositionComponent
    with HasGameRef, HasWorldReference<ColorTapWorld> {
  late final StreamSubscription _preferenceManagerSub;
  final ComponentKey otherBoardKey;
  final double verticalStartFactor;

  final _targets = <Target>[];

  TargetBoard({
    required this.otherBoardKey,
    required this.verticalStartFactor,
    super.key,
  });

  @override
  FutureOr<void> onLoad() {
    _preferenceManagerSub =
        PreferenceManager.get.stream.listen((_) => _resetForNewDifficulty());

    size = targetBoardSize(game.size);
    _resetForNewDifficulty();
    return super.onLoad();
  }

  @override
  void onRemove() {
    super.onRemove();
    _preferenceManagerSub.cancel();
  }

  @override
  void update(double dt) {
    if (world.scrollingPaused) {
      return;
    }

    // Move the board down the screen; reset to the top if scrolled passed the
    // bottom.
    if (position.y >= size.y) {
      // Add _targetSpacing here to account for the spacing above the bottom
      // board and below the top board.
      var otherBoard = game.findByKey(otherBoardKey) as TargetBoard;
      position.y = otherBoard.position.y - size.y + targetSpacing;
      _resetTargets();
    } else {
      position.y += world.speed;
    }
  }

  void resetForNewGame() {
    _resetPos();
    _resetTargets();
  }

  void _resetForNewDifficulty() {
    _resetPos();
    _clearAndAddTargets();
  }

  void _resetPos() {
    position.y = -verticalStartFactor * size.y;
  }

  void _resetTargets() {
    for (var target in _targets) {
      target.reset();
    }
  }

  void _clearAndAddTargets() {
    removeAll(_targets);
    _targets.clear();

    var bounds = size.toRect();
    var diameter = targetDiameterForRect(bounds);

    var numColumns = (bounds.width / diameter).floorToDouble();
    var numRows = (bounds.height / diameter).floorToDouble();

    // Account for the spacing between targets.
    var ySpacing = (bounds.height - numRows * diameter) / (numRows + 1);
    var xSpacing = (bounds.width - numColumns * diameter) / (numColumns + 1);

    for (var r = 0; r < numRows; r++) {
      for (var c = 0; c < numColumns; c++) {
        _targets.add(Target(
          Vector2(
            c * diameter + (c + 1) * xSpacing + diameter / 2,
            r * diameter + (r + 1) * ySpacing + diameter / 2,
          ),
          diameter / 2,
          this,
        ));
      }
    }

    addAll(_targets);
  }
}
