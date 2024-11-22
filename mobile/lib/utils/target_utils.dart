import 'dart:ui';

import 'package:flame/components.dart';
import 'package:mobile/managers/preference_manager.dart';

/// This value is multiplied by the game's height to determine how far to
/// scroll back the game when a target is missed.
const targetMissedOffsetFactor = 0.5;

/// Setting the board size to something larger than the game prevents any
/// "disappearing" effects around the edges of the board caused by devices that
/// have safe areas.
///
/// The added [targetMissedOffsetFactor] is so when missed targets are scrolled
/// back, there are always targets visible on the screen.
const targetBoardHeightFactor = 1.25 + targetMissedOffsetFactor;

double targetScrollBackDistance(double gameHeight) =>
    gameHeight * targetMissedOffsetFactor;

double targetDiameterForRect(Rect rect) {
  return rect.width / PreferenceManager.get.difficulty.targetsPerRow.toDouble();
}

double targetRadiusForSize(Vector2 size) =>
    targetDiameterForRect(targetBoardSize(size).toRect()) / 2;

Vector2 targetBoardSize(Vector2 gameSize) {
  var targetSize = targetDiameterForRect(gameSize.toRect());
  // Rounding removes all fractional spacing between targets.
  var numOfRows = (gameSize.y * targetBoardHeightFactor / targetSize).round();
  return Vector2(gameSize.x, targetSize * numOfRows);
}
