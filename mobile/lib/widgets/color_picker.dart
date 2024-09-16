import 'package:flutter/material.dart';
import 'package:mobile/difficulty.dart';
import 'package:mobile/managers/preference_manager.dart';
import 'package:mobile/target_color.dart';
import 'package:mobile/utils/dimens.dart';
import 'package:mobile/widgets/animated_visibility.dart';

import '../managers/audio_manager.dart';

class ColorPicker extends StatelessWidget {
  static const _colorSize = 25.0;
  static const _colorSpacing = 5.0;
  static const _selectedIconSize = 18.0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: PreferenceManager.get.stream,
      builder: (context, _) {
        var isEnabled = PreferenceManager.get.difficulty.canChooseColor;
        var index = PreferenceManager.get.colorIndex;
        var selectedColor =
            index == null ? null : TargetColor.from(index: index);

        return AnimatedOpacity(
          opacity: isEnabled ? 1.0 : opacityDisabled,
          duration: animDurationDefault,
          child: Wrap(
            runSpacing: _colorSpacing,
            spacing: _colorSpacing,
            children: Difficulty.kids.colors().map((e) {
              return _buildColor(
                e,
                isSelected: e == selectedColor,
                isEnabled: isEnabled,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildColor(
    TargetColor color, {
    required bool isSelected,
    required bool isEnabled,
  }) {
    return Container(
      width: _colorSize,
      height: _colorSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.color,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_colorSize / 2),
          ),
          onTap: isEnabled
              ? AudioManager.get.onButtonPressed(() => PreferenceManager
                  .get.colorIndex = isSelected ? null : color.index)
              : null,
          child: AnimatedVisibility(
            isVisible: isSelected,
            child: const Center(
              child: Icon(
                Icons.check,
                color: Colors.black,
                size: _selectedIconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
