import 'package:flutter/material.dart';
import 'package:restaurant/core/theme/color_manager.dart';

abstract class AppTheme {
  static ThemeData ligtTheme = ThemeData(
    scaffoldBackgroundColor: ColorsManager.backgroundLight,
    fontFamily: "main",
    colorScheme: ColorScheme.light(
      primary: ColorsManager.primaryText,
      primaryContainer: ColorsManager.secondry,
      secondary: ColorsManager.backgroundLight,
      onPrimary: ColorsManager.selection,
      onPrimaryFixed: ColorsManager.secondryText,
      onPrimaryFixedVariant: ColorsManager.iconColor,
      onPrimaryContainer: Colors.white,
      onSecondary: ColorsManager.primary,
      onSecondaryContainer: Colors.black,
    ),
  );
  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: ColorsManager.backgroundDark,
    fontFamily: "main",
    colorScheme: ColorScheme.dark(
      primary: Colors.white,
      primaryContainer: ColorsManager.secondry,
      secondary: ColorsManager.backgroundDark,
      onPrimary: Colors.white,
      onPrimaryFixed: Colors.white,
      onPrimaryFixedVariant: ColorsManager.primary,
      onPrimaryContainer: Colors.black,
      onSecondary: ColorsManager.iconColor,
      onSecondaryContainer: Colors.white,
    ),
  );
}
