import 'dart:ui';

import 'package:flame/components.dart';

/// Spacing between targets.
const targetSpacing = 4.0;
const targetsPerRow = 4;

/// Setting the board size to slightly larger than the game prevents any
/// "disappearing" effects around the edges of the board caused by devices that
/// have safe areas.
const targetBoardHeightFactor = 1.25;

double targetDiameterForRect(Rect rect) =>
    ((rect.width - targetsPerRow * targetSpacing) / targetsPerRow)
        .floorToDouble();

double targetRadiusForSize(Vector2 size) =>
    targetDiameterForRect(targetBoardSize(size).toRect()) / 2;

Vector2 targetBoardSize(Vector2 gameSize) =>
    Vector2(gameSize.x, gameSize.y * targetBoardHeightFactor);
