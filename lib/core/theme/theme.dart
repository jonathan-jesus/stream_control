import 'package:flutter/material.dart';
import 'package:stream_control/core/constants/app_colors.dart';

ColorScheme get colorSchemeLight {
  return const ColorScheme.light().copyWith(
    primary: AppColors.primary,
    onPrimary: AppColors.lightOnPrimary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.lightOnPrimary,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.lightOnPrimary,
    error: AppColors.error,
    onError: Colors.white,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightOnSurface,
    outline: AppColors.primary,
  );
}

ColorScheme get colorSchemeDark {
  return const ColorScheme.dark().copyWith(
    primary: AppColors.primary,
    onPrimary: AppColors.darkOnPrimary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.darkOnPrimary,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.darkOnPrimary,
    error: AppColors.error,
    onError: Colors.white,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkOnSurface,
    outline: AppColors.primary,
  );
}

ThemeData get lightTheme {
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorSchemeLight,
    scaffoldBackgroundColor: AppColors.lightBackground,
    disabledColor: colorSchemeLight.onSurface.withAlpha(95),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBackgroundAlternate,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 50,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        color: colorSchemeLight.onSurface,
      ),
    ),
    cardTheme: CardThemeData(
      color: colorSchemeLight.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        side: BorderSide(
          color: colorSchemeLight.outline.withAlpha(50),
          width: 1,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(colorSchemeLight.secondary),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.disabled;
            }
            return colorSchemeLight.onSurface;
          },
        ),
        overlayColor:
            WidgetStateProperty.all(colorSchemeLight.secondary.withAlpha(50)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        overlayColor:
            WidgetStateProperty.all(colorSchemeLight.secondary.withAlpha(50)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor:
            WidgetStateProperty.all(colorSchemeLight.secondary.withAlpha(50)),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.disabled;
          }
          return colorSchemeLight.onSurface;
        }),
        overlayColor:
            WidgetStateProperty.all(colorSchemeLight.secondary.withAlpha(50)),
      ),
    ),
  );
}

ThemeData get darkTheme {
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorSchemeDark,
    disabledColor: colorSchemeDark.onSurface.withAlpha(95),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackgroundAlternate,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 50,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: colorSchemeDark.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w300,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        side: BorderSide(
          color: colorSchemeDark.outline.withAlpha(50),
          width: 1,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.disabled;
            }
            return colorSchemeDark.onSurface;
          },
        ),
        overlayColor: WidgetStateProperty.all(colorSchemeDark.secondary),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.disabled;
            }
            return colorSchemeDark.onSurface;
          },
        ),
        overlayColor:
            WidgetStateProperty.all(colorSchemeDark.secondary.withAlpha(100)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        overlayColor:
            WidgetStateProperty.all(colorSchemeDark.secondary.withAlpha(100)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor:
            WidgetStateProperty.all(colorSchemeDark.secondary.withAlpha(100)),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.disabled;
          }
          return colorSchemeDark.onSurface;
        }),
        overlayColor:
            WidgetStateProperty.all(colorSchemeDark.secondary.withAlpha(100)),
      ),
    ),
  );
}
