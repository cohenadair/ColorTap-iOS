import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/strings.dart';

/// The various difficulties of the game.
///
/// Note that the difficulty indexes are stored in preferences and should not
/// be changed.
enum Difficulty {
  kids(
    minTargetsPerRow: 2,
    canChooseColor: true,
    hasUnlimitedLives: true,
    startSpeed: 3.0,
    incSpeedBy: 0,
    colorChangeGracePeriodMs: 2500,
    colorChangeFrequencyRange: (1000000, 1000000), // Never change.
  ),
  easy(
    minTargetsPerRow: 3,
    canChooseColor: false,
    hasUnlimitedLives: false,
    startSpeed: 3.75,
    incSpeedBy: 0,
    colorChangeGracePeriodMs: 2000,
    colorChangeFrequencyRange: (10, 10),
  ),
  normal(
    minTargetsPerRow: 4,
    canChooseColor: false,
    hasUnlimitedLives: false,
    startSpeed: 4.0,
    incSpeedBy: 0.00005,
    colorChangeGracePeriodMs: 1500,
    colorChangeFrequencyRange: (10, 10),
  ),
  hard(
    minTargetsPerRow: 5,
    canChooseColor: false,
    hasUnlimitedLives: false,
    startSpeed: 4.25,
    incSpeedBy: 0.0001,
    colorChangeGracePeriodMs: 1000,
    colorChangeFrequencyRange: (10, 10),
  ),
  expert(
    minTargetsPerRow: 5,
    canChooseColor: false,
    hasUnlimitedLives: false,
    startSpeed: 6.0,
    incSpeedBy: 0.00015,
    colorChangeGracePeriodMs: 1000,
    colorChangeFrequencyRange: (7, 15), // Arbitrary numbers.
  );

  /// If the screen's width is >= this value, the number of targets per row is
  /// increased by [_incTargetsPerRowBy].
  final int _incTargetsPerRowThreshold = 600;
  final int _incTargetsPerRowBy = 1;

  /// The minimum targets per row. This value may be added to depending on the
  /// type of device (tablet/iPad/phone) being used.
  final int minTargetsPerRow;

  /// True if the user can choose a constant color for the targets. When true,
  /// targets never change color.
  final bool canChooseColor;

  /// When true, lives are not lost after each game.
  final bool hasUnlimitedLives;

  /// The speed at which the game starts.
  final double startSpeed;

  /// The factor at which the speed is increased after each successful target
  /// tap.
  final double incSpeedBy;

  /// How long, in milliseconds, to allow for the current target to scroll off
  /// the screen after a color switch.
  final int colorChangeGracePeriodMs;

  /// The range in which the target's color will change. Defaults to every 10
  /// successful taps.
  final (int, int) colorChangeFrequencyRange;

  const Difficulty({
    required this.minTargetsPerRow,
    required this.canChooseColor,
    required this.hasUnlimitedLives,
    required this.startSpeed,
    required this.incSpeedBy,
    required this.colorChangeGracePeriodMs,
    required this.colorChangeFrequencyRange,
  });

  /// Returns the number of targets per row for this difficulty. For larger
  /// screens, a larger value is returned.
  int get targetsPerRow {
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    Size size = view.physicalSize / view.devicePixelRatio; // Size in dp.
    return size.width >= _incTargetsPerRowThreshold
        ? minTargetsPerRow + _incTargetsPerRowBy
        : minTargetsPerRow;
  }

  String displayName(BuildContext context) {
    switch (this) {
      case Difficulty.kids:
        return Strings.of(context).difficultyKids;
      case Difficulty.easy:
        return Strings.of(context).difficultyEasy;
      case Difficulty.normal:
        return Strings.of(context).difficultyNormal;
      case Difficulty.hard:
        return Strings.of(context).difficultyHard;
      case Difficulty.expert:
        return Strings.of(context).difficultyExpert;
    }
  }
}
