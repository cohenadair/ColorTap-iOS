import 'package:flutter/material.dart';

import '../utils/dimens.dart';

class AnimatedVisibility extends StatelessWidget {
  final bool isVisible;
  final Widget child;

  const AnimatedVisibility({
    required this.isVisible,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: animDurationDefault,
      opacity: isVisible ? 1.0 : 0.0,
      child: child,
    );
  }
}
