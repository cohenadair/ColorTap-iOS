import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/strings.dart';

const int snackBarDurationDefault = 5;

void showErrorSnackBar(BuildContext context, String errorMessage) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(errorMessage),
    duration: const Duration(seconds: snackBarDurationDefault),
    backgroundColor: Colors.red,
  ));
}

void showInfoDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        _buildOkButton(context),
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
    child: Text(Strings.of(context).ok),
    onPressed: () {
      Navigator.of(context).pop();
      onDismissed?.call();
    },
  );
}
