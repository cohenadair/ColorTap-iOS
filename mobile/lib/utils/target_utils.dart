import 'dart:ui';

import 'package:flame/components.dart';

/// Horizontal spacing between targets.
const targetSpacing = 4.0;
const targetsPerRow = 4;

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

double targetDiameterForRect(Rect rect) =>
    ((rect.width - targetsPerRow * targetSpacing) / targetsPerRow)
        .floorToDouble();

double targetRadiusForSize(Vector2 size) =>
    targetDiameterForRect(targetBoardSize(size).toRect()) / 2;

Vector2 targetBoardSize(Vector2 gameSize) =>
    Vector2(gameSize.x, gameSize.y * targetBoardHeightFactor);
