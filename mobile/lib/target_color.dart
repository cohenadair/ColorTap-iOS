import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';

import 'managers/preference_manager.dart';

class TargetColor {
  static const _shadowDarkenFactor = 0.40;
  static const _shadowSpreadRadius = -15.0;
  static const _shadowBlurRadius = 20.0;

  /// Supported colors by the game. The indexes of these colors should never
  /// change, as they may be persisted in the database.
  static const _palettes = [
    BasicPalette.red,
    BasicPalette.orange,
    BasicPalette.yellow,
    BasicPalette.green,
    BasicPalette.blue,
    BasicPalette.purple,
    BasicPalette.magenta,
    BasicPalette.cyan,
  ];

  static PaletteEntry _randomPaletteEntry({
    TargetColor? exclude,
  }) {
    var palettes = PreferenceManager.get.difficulty
        .colors()
        .map((e) => e._paletteEntry)
        .toList();

    if (exclude != null) {
      palettes.remove(exclude._paletteEntry);
    }

    return palettes[Random().nextInt(palettes.length)];
  }

  static PaletteEntry? _preferencePaletteEntry() {
    var index = PreferenceManager.get.colorIndex;
    return index == null ? null : _palettes[index];
  }

  static List<TargetColor> all() => _palettes
      .mapIndexed((index, _) => TargetColor.from(index: index))
      .toList();

  static List<TargetColor> kids() => [
        TargetColor.from(index: 0),
        TargetColor.from(index: 2),
        TargetColor.from(index: 3),
        TargetColor.from(index: 4),
      ];

  final PaletteEntry _paletteEntry;

  /// Returns a [TargetColor] instance of the user-selected color, or a random
  /// [TargetColor] if there isn't one selected.
  TargetColor.fromPreferences({TargetColor? exclude})
      : _paletteEntry =
            _preferencePaletteEntry() ?? _randomPaletteEntry(exclude: exclude);

  TargetColor.random({TargetColor? exclude})
      : _paletteEntry = _randomPaletteEntry(exclude: exclude);

  TargetColor.from({
    required int index,
  }) : _paletteEntry = _palettes[index];

  Paint get paint => _paletteEntry.paint();

  Color get color => _paletteEntry.color;

  int get index => _palettes.indexOf(_paletteEntry);

  /// Need to be able to set a few properties here so it can be used in the
  /// [Scoreboard], which renders shadows slightly differently because it's a
  /// [Widget] rather than a [Component].
  List<BoxShadow> innerShadow({
    BlurStyle blurStyle = BlurStyle.inner,
    double spreadRadius = _shadowSpreadRadius,
  }) {
    return [
      // Shadow
      BoxShadow(
        color: color.darken(_shadowDarkenFactor),
        blurStyle: blurStyle,
      ),
      // Background color.
      BoxShadow(
        color: color,
        spreadRadius: spreadRadius,
        blurRadius: _shadowBlurRadius,
        blurStyle: blurStyle,
      ),
    ];
  }

  @override
  bool operator ==(Object other) =>
      other is TargetColor && other._paletteEntry.color == _paletteEntry.color;

  @override
  int get hashCode => _paletteEntry.color.hashCode;
}
