import "package:flutter/material.dart";

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

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff740006),
      surfaceTint: Color(0xffc00012),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffdc0016),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff740006),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffc53b33),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff502e00),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff9c5f00),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff1e0c0a),
      onSurfaceVariant: Color(0xff4c2f2b),
      outline: Color(0xff6b4a46),
      outlineVariant: Color(0xff886460),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff412b28),
      inversePrimary: Color(0xffffb4ab),
      primaryFixed: Color(0xffdc0016),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xffae000f),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xffc53b33),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xffa3221e),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff9c5f00),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff7b4900),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe1bfba),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0ee),
      surfaceContainer: Color(0xffffe2de),
      surfaceContainerHigh: Color(0xfff9d5d0),
      surfaceContainerHighest: Color(0xffedcac5),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff600004),
      surfaceTint: Color(0xffc00012),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff98000b),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff600004),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff921414),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff422500),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff6b3f00),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff402522),
      outlineVariant: Color(0xff61413d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff412b28),
      inversePrimary: Color(0xffffb4ab),
      primaryFixed: Color(0xff98000b),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff6d0005),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff921414),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff6d0005),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff6b3f00),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff4b2b00),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd3b1ad),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffffedea),
      surfaceContainer: Color(0xffffdad6),
      surfaceContainerHigh: Color(0xfff0ccc8),
      surfaceContainerHighest: Color(0xffe1bfba),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb4ab),
      surfaceTint: Color(0xffffb4ab),
      onPrimary: Color(0xff690005),
      primaryContainer: Color(0xffe8081a),
      onPrimaryContainer: Color(0xfffffbfa),
      secondary: Color(0xffffb4ab),
      onSecondary: Color(0xff690005),
      secondaryContainer: Color(0xff921414),
      onSecondaryContainer: Color(0xffff9f94),
      tertiary: Color(0xffffb868),
      onTertiary: Color(0xff482900),
      tertiaryContainer: Color(0xffa66500),
      onTertiaryContainer: Color(0xfffffbfa),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff200e0c),
      onSurface: Color(0xffffdad6),
      onSurfaceVariant: Color(0xffe9bcb7),
      outline: Color(0xffaf8782),
      outlineVariant: Color(0xff5e3f3b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffffdad6),
      inversePrimary: Color(0xffc00012),
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
      surfaceDim: Color(0xff200e0c),
      surfaceBright: Color(0xff4a3331),
      surfaceContainerLowest: Color(0xff1a0908),
      surfaceContainerLow: Color(0xff2a1614),
      surfaceContainer: Color(0xff2e1a18),
      surfaceContainerHigh: Color(0xff3a2522),
      surfaceContainerHighest: Color(0xff462f2c),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffd2cc),
      surfaceTint: Color(0xffffb4ab),
      onPrimary: Color(0xff540003),
      primaryContainer: Color(0xffff544a),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffffd2cc),
      onSecondary: Color(0xff540003),
      secondaryContainer: Color(0xfff65e52),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffd5aa),
      onTertiary: Color(0xff392000),
      tertiaryContainer: Color(0xffc88124),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff200e0c),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffd2cc),
      outline: Color(0xffd3a8a3),
      outlineVariant: Color(0xffaf8782),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffffdad6),
      inversePrimary: Color(0xff95000b),
      primaryFixed: Color(0xffffdad6),
      onPrimaryFixed: Color(0xff2d0001),
      primaryFixedDim: Color(0xffffb4ab),
      onPrimaryFixedVariant: Color(0xff740006),
      secondaryFixed: Color(0xffffdad6),
      onSecondaryFixed: Color(0xff2d0001),
      secondaryFixedDim: Color(0xffffb4ab),
      onSecondaryFixedVariant: Color(0xff740006),
      tertiaryFixed: Color(0xffffddbb),
      onTertiaryFixed: Color(0xff1d0e00),
      tertiaryFixedDim: Color(0xffffb868),
      onTertiaryFixedVariant: Color(0xff502e00),
      surfaceDim: Color(0xff200e0c),
      surfaceBright: Color(0xff573e3c),
      surfaceContainerLowest: Color(0xff120403),
      surfaceContainerLow: Color(0xff2c1816),
      surfaceContainer: Color(0xff372220),
      surfaceContainerHigh: Color(0xff432d2a),
      surfaceContainerHighest: Color(0xff4f3835),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffece9),
      surfaceTint: Color(0xffffb4ab),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffaea5),
      onPrimaryContainer: Color(0xff220001),
      secondary: Color(0xffffece9),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffffaea5),
      onSecondaryContainer: Color(0xff220001),
      tertiary: Color(0xffffedde),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffffb35a),
      onTertiaryContainer: Color(0xff150800),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff200e0c),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffffece9),
      outlineVariant: Color(0xffe5b8b3),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffffdad6),
      inversePrimary: Color(0xff95000b),
      primaryFixed: Color(0xffffdad6),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffb4ab),
      onPrimaryFixedVariant: Color(0xff2d0001),
      secondaryFixed: Color(0xffffdad6),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffffb4ab),
      onSecondaryFixedVariant: Color(0xff2d0001),
      tertiaryFixed: Color(0xffffddbb),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffffb868),
      onTertiaryFixedVariant: Color(0xff1d0e00),
      surfaceDim: Color(0xff200e0c),
      surfaceBright: Color(0xff634a47),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff2e1a18),
      surfaceContainer: Color(0xff412b28),
      surfaceContainerHigh: Color(0xff4d3633),
      surfaceContainerHighest: Color(0xff59413e),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
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
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
