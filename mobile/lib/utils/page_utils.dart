import 'package:flutter/material.dart';

void push(
  BuildContext context,
  Widget page, {
  bool fullscreenDialog = false,
  VoidCallback? onFinish,
}) {
  Navigator.of(context, rootNavigator: fullscreenDialog)
      .push(
        MaterialPageRoute(
          builder: (context) => page,
          fullscreenDialog: fullscreenDialog,
        ),
      )
      .then((_) => onFinish?.call());
}

void present(
  BuildContext context,
  Widget page, {
  VoidCallback? onFinish,
}) {
  push(context, page, fullscreenDialog: true, onFinish: onFinish);
}
