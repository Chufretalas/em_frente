import 'package:flutter/material.dart';
import 'package:pra_frente_app/themes/theme_colors.dart';

const Color u = Color(0xffcf6679);

ThemeData MyTheme = ThemeData(
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      color: ThemeColors.white
    )
  ),
  colorScheme: const ColorScheme.dark(
    brightness: Brightness.dark,
    primary: ThemeColors.primary,
    onPrimary: ThemeColors.white,
    secondary: ThemeColors.secondary,
    tertiary: ThemeColors.tertiary,
    error: ThemeColors.error,
    secondaryContainer: ThemeColors.secondaryDarker,
    onSecondaryContainer: ThemeColors.white,
  ),
);
