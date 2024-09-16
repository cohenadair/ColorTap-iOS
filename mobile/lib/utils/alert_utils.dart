import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/strings.dart';
import 'package:mobile/utils/colors.dart';

import '../managers/audio_manager.dart';

const int snackBarDurationDefault = 5;

void showErrorSnackBar(BuildContext context, String errorMessage) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(errorMessage, style: const TextStyle(color: colorLightText)),
    duration: const Duration(seconds: snackBarDurationDefault),
    backgroundColor: Colors.red,
  ));
}

void showNetworkErrorSnackBar(BuildContext context) =>
    showErrorSnackBar(context, Strings.of(context).errorNetwork);

void showInfoDialog(
  BuildContext context,
  String title,
  String message, {
  VoidCallback? onDismissed,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        _buildOkButton(context, onDismissed: onDismissed),
      ],
    ),
  );
}

void showErrorDialog(
  BuildContext context,
  String errorMessage, {
  VoidCallback? onDismissed,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(Strings.of(context).error),
      content: Text(errorMessage),
      actions: <Widget>[
        _buildOkButton(context, onDismissed: onDismissed),
      ],
    ),
  );
}

Widget _buildOkButton(
  BuildContext context, {
  VoidCallback? onDismissed,
}) {
  return TextButton(
    onPressed: AudioManager.get.onButtonPressed(() {
      Navigator.of(context).pop();
      onDismissed?.call();
    }),
    child: Text(Strings.of(context).ok),
  );
}
