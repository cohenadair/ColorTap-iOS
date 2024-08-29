import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/utils/dimens.dart';

import 'colors.dart';

const _fontSizePrimary = 16.0;
const _fontSizeTitle = 22.0;

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    scaffoldBackgroundColor: colorGame,
    canvasColor: colorGame,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(
        color: Theme.of(context).primaryColor,
      ),
      backgroundColor: colorGame,
      foregroundColor: colorLightText,
    ),
    textTheme: themeTextGlobal(),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Theme.of(context).primaryColor,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: colorGame,
      titleTextStyle:
          themeTextGlobal().titleLarge?.copyWith(color: colorLightText),
    ),
    listTileTheme: ListTileThemeData(
      titleTextStyle: styleTextPrimary(),
      iconColor: Theme.of(context).primaryColor,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        textStyle: styleTextPrimary(),
        padding: const EdgeInsets.symmetric(
          vertical: paddingDefault,
          horizontal: paddingXLarge,
        ),
      ),
    ),
    iconTheme: IconThemeData(
      color: Theme.of(context).primaryColor,
    ),
  );
}

TextTheme themeTextGlobal() {
  return GoogleFonts.quicksandTextTheme(
    TextTheme(
      bodyMedium: styleTextPrimary(),
      titleLarge: styleTextDefault().copyWith(
        fontSize: _fontSizeTitle,
      ),
    ),
  );
}

TextStyle styleTextDefault() {
  return GoogleFonts.quicksand().copyWith(
    color: colorLightText,
  );
}

TextStyle styleTextLight() {
  return GoogleFonts.quicksand().copyWith(
    color: colorDarkText,
  );
}

TextStyle styleTextPrimary() {
  return GoogleFonts.quicksand().copyWith(
    color: colorLightText,
    fontSize: _fontSizePrimary,
  );
}

TextStyle styleTextPrimaryLight() {
  return GoogleFonts.quicksand().copyWith(
    color: colorDarkText,
    fontSize: _fontSizePrimary,
  );
}
