import 'package:flutter/material.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xffba0011),
      surfaceTint: Color(0xffc00012),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffe8081a),
      onPrimaryContainer: Color(0xfffffbfa),
      secondary: Color(0xffb12c26),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xfffd6357),
      onSecondaryContainer: Color(0xff650005),
      tertiary: Color(0xff844f00),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffa66500),
      onTertiaryContainer: Color(0xfffffbfa),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff2a1614),
      onSurfaceVariant: Color(0xff5e3f3b),
      outline: Color(0xff936e6a),
      outlineVariant: Color(0xffe9bcb7),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff412b28),
      inversePrimary: Color(0xffffb4ab),
      primaryFixed: Color(0xffffdad6),
      onPrimaryFixed: Color(0xff410002),
      primaryFixedDim: Color(0xffffb4ab),
      onPrimaryFixedVariant: Color(0xff93000b),
      secondaryFixed: Color(0xffffdad6),
      onSecondaryFixed: Color(0xff410002),
      secondaryFixedDim: Color(0xffffb4ab),
      onSecondaryFixedVariant: Color(0xff8f1112),
      tertiaryFixed: Color(0xffffddbb),
      onTertiaryFixed: Color(0xff2b1700),
      tertiaryFixedDim: Color(0xffffb868),
      onTertiaryFixedVariant: Color(0xff673d00),
      surfaceDim: Color(0xfff6d2ce),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0ee),
      surfaceContainer: Color(0xffffe9e6),
      surfaceContainerHigh: Color(0xffffe2de),
      surfaceContainerHighest: Color(0xffffdad6),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 4,
          iconTheme: IconThemeData(color: colorScheme.onPrimary),
          titleTextStyle: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          toolbarTextStyle: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
}
