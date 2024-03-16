import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flame/palette.dart';

import 'managers/preference_manager.dart';

class TargetColor {
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
    var palettes = List.of(_palettes);
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

  final PaletteEntry _paletteEntry;

  /// Returns a [TargetColor] instance of the user-selected color, or a random
  /// [TargetColor] if there isn't one selected.
  TargetColor.fromPreferences()
      : _paletteEntry = _preferencePaletteEntry() ?? _randomPaletteEntry();

  TargetColor.random({TargetColor? exclude})
      : _paletteEntry = _randomPaletteEntry(exclude: exclude);

  TargetColor.from({
    required int index,
  }) : _paletteEntry = _palettes[index];

  Paint get paint => _paletteEntry.paint();

  Color get color => _paletteEntry.color;

  int get index => _palettes.indexOf(_paletteEntry);

  @override
  bool operator ==(Object other) =>
      other is TargetColor && other._paletteEntry.color == _paletteEntry.color;

  @override
  int get hashCode => _paletteEntry.color.hashCode;
}
