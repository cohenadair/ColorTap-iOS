import 'dart:math';
import 'dart:ui';

import 'package:flame/palette.dart';

class TargetColor {
  static PaletteEntry _randomPaletteEntry({
    TargetColor? exclude,
  }) {
    var palettes = [
      BasicPalette.red,
      BasicPalette.orange,
      BasicPalette.yellow,
      BasicPalette.green,
      BasicPalette.blue,
      BasicPalette.purple,
      BasicPalette.magenta,
      BasicPalette.cyan,
    ];
    if (exclude != null) {
      palettes.remove(exclude._paletteEntry);
    }
    return palettes[Random().nextInt(palettes.length)];
  }

  final PaletteEntry _paletteEntry;

  TargetColor.random({
    TargetColor? exclude,
  }) : _paletteEntry = _randomPaletteEntry(exclude: exclude);

  Paint get paint => _paletteEntry.paint();

  Color get color => _paletteEntry.color;

  @override
  bool operator ==(Object other) =>
      other is TargetColor && other._paletteEntry.color == _paletteEntry.color;

  @override
  int get hashCode => _paletteEntry.color.hashCode;
}
