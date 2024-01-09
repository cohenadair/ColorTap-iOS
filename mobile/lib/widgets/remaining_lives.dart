import 'package:flutter/material.dart';
import 'package:mobile/utils/colors.dart';

import '../managers/lives_manager.dart';
import '../utils/dimens.dart';

class RemainingLives extends StatelessWidget {
  static const _defaultIconSize = 30.0;
  static const _livesFontSize = 20.0;

  final double iconSize;

  const RemainingLives({
    this.iconSize = _defaultIconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.favorite),
          color: Colors.red,
          iconSize: iconSize,
          onPressed: () {},
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        StreamBuilder(
          stream: LivesManager.get.stream,
          builder: (_, __) {
            return Text(
              LivesManager.get.lives.toString(),
              style: const TextStyle(
                fontSize: _livesFontSize,
                fontWeight: fontWeightBold,
                color: colorLightText,
              ),
            );
          },
        ),
      ],
    );
  }
}
