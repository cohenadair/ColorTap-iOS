import 'package:flutter/material.dart';
import 'package:mobile/utils/colors.dart';

class Loading extends StatelessWidget {
  static const _size = 20.0;
  static const _strokeWidth = 2.0;

  final bool isVisible;

  const Loading({this.isVisible = true});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: SizedBox.fromSize(
        size: const Size(_size, _size),
        child: const CircularProgressIndicator(
          strokeWidth: _strokeWidth,
          color: colorLightText,
        ),
      ),
    );
  }
}
