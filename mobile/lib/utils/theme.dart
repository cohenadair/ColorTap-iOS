import 'package:flutter/material.dart';
import 'package:mobile/utils/dimens.dart';

import 'colors.dart';

const themeTextDefault = TextStyle(color: colorLightText);
const themeTextLight = TextStyle(color: colorDarkText);

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    scaffoldBackgroundColor: colorGame,
    appBarTheme: const AppBarTheme(
      backgroundColor: colorGame,
      foregroundColor: colorLightText,
    ),
    textTheme: const TextTheme(
      bodyMedium: themeTextDefault,
      titleLarge: themeTextDefault,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Theme.of(context).primaryColor,
    ),
    dialogTheme: const DialogTheme(
      contentTextStyle: themeTextLight,
    ),
  );
}

extension TextStyles on TextStyle {
  TextStyle makeBold() => copyWith(fontWeight: fontWeightBold);
}
