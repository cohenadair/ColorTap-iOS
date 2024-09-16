import 'package:flutter/material.dart';
import 'package:mobile/managers/preference_manager.dart';
import 'package:mobile/utils/colors.dart';

import '../managers/lives_manager.dart';
import '../utils/dimens.dart';

class RemainingLives extends StatelessWidget {
  static const _iconSize = 30.0;

  const RemainingLives();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.favorite),
          color: Colors.red,
          iconSize: _iconSize,
          onPressed: () {},
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        StreamBuilder(
          stream: PreferenceManager.get.stream,
          builder: (_, __) {
            return StreamBuilder(
              stream: LivesManager.get.stream,
              builder: (_, __) {
                if (PreferenceManager.get.difficulty.hasUnlimitedLives) {
                  return const Icon(Icons.all_inclusive, color: colorLightText);
                }

                return Text(
                  LivesManager.get.lives.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: fontWeightBold),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
