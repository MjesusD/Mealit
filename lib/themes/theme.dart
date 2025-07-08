import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff150060),
      surfaceTint: Color(0xff5b50b3),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff2a1980),
      onPrimaryContainer: Color(0xff9489ef),
      secondary: Color(0xff5e5a82),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd5cffe),
      onSecondaryContainer: Color(0xff5b577e),
      tertiary: Color(0xff330037),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff540659),
      onTertiaryContainer: Color(0xffcb77c9),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffcf8ff),
      onSurface: Color(0xff1c1b21),
      onSurfaceVariant: Color(0xff474552),
      outline: Color(0xff787583),
      outlineVariant: Color(0xffc9c4d4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff312f36),
      inversePrimary: Color(0xffc7bfff),
      primaryFixed: Color(0xffe4dfff),
      onPrimaryFixed: Color(0xff170065),
      primaryFixedDim: Color(0xffc7bfff),
      onPrimaryFixedVariant: Color(0xff433799),
      secondaryFixed: Color(0xffe4dfff),
      onSecondaryFixed: Color(0xff1a163a),
      secondaryFixedDim: Color(0xffc7c1ef),
      onSecondaryFixedVariant: Color(0xff464268),
      tertiaryFixed: Color(0xffffd6f9),
      onTertiaryFixed: Color(0xff37003b),
      tertiaryFixedDim: Color(0xffffa9fb),
      onTertiaryFixedVariant: Color(0xff712774),
      surfaceDim: Color(0xffddd8e1),
      surfaceBright: Color(0xfffcf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f2fb),
      surfaceContainer: Color(0xfff1ecf5),
      surfaceContainerHigh: Color(0xffebe6f0),
      surfaceContainerHighest: Color(0xffe5e1ea),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff150060),
      surfaceTint: Color(0xff5b50b3),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff2a1980),
      onPrimaryContainer: Color(0xffbbb3ff),
      secondary: Color(0xff353257),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff6d6891),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff330037),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff540659),
      onTertiaryContainer: Color(0xfff59df2),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffcf8ff),
      onSurface: Color(0xff111017),
      onSurfaceVariant: Color(0xff363541),
      outline: Color(0xff53515e),
      outlineVariant: Color(0xff6e6b79),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff312f36),
      inversePrimary: Color(0xffc7bfff),
      primaryFixed: Color(0xff6a5fc3),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff5246a8),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff6d6891),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff545077),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff9d4f9e),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff823683),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc9c5ce),
      surfaceBright: Color(0xfffcf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f2fb),
      surfaceContainer: Color(0xffebe6f0),
      surfaceContainerHigh: Color(0xffdfdbe4),
      surfaceContainerHighest: Color(0xffd4d0d9),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff150060),
      surfaceTint: Color(0xff5b50b3),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff2a1980),
      onPrimaryContainer: Color(0xffebe5ff),
      secondary: Color(0xff2b274c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff49456b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff330037),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff540659),
      onTertiaryContainer: Color(0xffffdff9),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffcf8ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff2c2b36),
      outlineVariant: Color(0xff4a4854),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff312f36),
      inversePrimary: Color(0xffc7bfff),
      primaryFixed: Color(0xff463a9c),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff2f1f84),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff49456b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff322e53),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff742a77),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff590e5e),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffbbb7c0),
      surfaceBright: Color(0xfffcf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4eff8),
      surfaceContainer: Color(0xffe5e1ea),
      surfaceContainerHigh: Color(0xffd7d3dc),
      surfaceContainerHighest: Color(0xffc9c5ce),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffc7bfff),
      surfaceTint: Color(0xffc7bfff),
      onPrimary: Color(0xff2c1c82),
      primaryContainer: Color(0xff2a1980),
      onPrimaryContainer: Color(0xff9489ef),
      secondary: Color(0xffc7c1ef),
      onSecondary: Color(0xff302c50),
      secondaryContainer: Color(0xff49446b),
      onSecondaryContainer: Color(0xffb9b3e0),
      tertiary: Color(0xffffa9fb),
      onTertiary: Color(0xff570a5b),
      tertiaryContainer: Color(0xff540659),
      onTertiaryContainer: Color(0xffcb77c9),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff131319),
      onSurface: Color(0xffe5e1ea),
      onSurfaceVariant: Color(0xffc9c4d4),
      outline: Color(0xff928f9d),
      outlineVariant: Color(0xff474552),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e1ea),
      inversePrimary: Color(0xff5b50b3),
      primaryFixed: Color(0xffe4dfff),
      onPrimaryFixed: Color(0xff170065),
      primaryFixedDim: Color(0xffc7bfff),
      onPrimaryFixedVariant: Color(0xff433799),
      secondaryFixed: Color(0xffe4dfff),
      onSecondaryFixed: Color(0xff1a163a),
      secondaryFixedDim: Color(0xffc7c1ef),
      onSecondaryFixedVariant: Color(0xff464268),
      tertiaryFixed: Color(0xffffd6f9),
      onTertiaryFixed: Color(0xff37003b),
      tertiaryFixedDim: Color(0xffffa9fb),
      onTertiaryFixedVariant: Color(0xff712774),
      surfaceDim: Color(0xff131319),
      surfaceBright: Color(0xff3a383f),
      surfaceContainerLowest: Color(0xff0e0d13),
      surfaceContainerLow: Color(0xff1c1b21),
      surfaceContainer: Color(0xff201f25),
      surfaceContainerHigh: Color(0xff2a2930),
      surfaceContainerHighest: Color(0xff35343b),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffded8ff),
      surfaceTint: Color(0xffc7bfff),
      onPrimary: Color(0xff210a78),
      primaryContainer: Color(0xff8e84ea),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffded8ff),
      onSecondary: Color(0xff252145),
      secondaryContainer: Color(0xff918cb7),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffcdf9),
      onTertiary: Color(0xff48004d),
      tertiaryContainer: Color(0xffc673c4),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff131319),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffdfdaea),
      outline: Color(0xffb4b0bf),
      outlineVariant: Color(0xff928e9d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e1ea),
      inversePrimary: Color(0xff45389b),
      primaryFixed: Color(0xffe4dfff),
      onPrimaryFixed: Color(0xff0e0048),
      primaryFixedDim: Color(0xffc7bfff),
      onPrimaryFixedVariant: Color(0xff322488),
      secondaryFixed: Color(0xffe4dfff),
      onSecondaryFixed: Color(0xff100b2f),
      secondaryFixedDim: Color(0xffc7c1ef),
      onSecondaryFixedVariant: Color(0xff353257),
      tertiaryFixed: Color(0xffffd6f9),
      onTertiaryFixed: Color(0xff260029),
      tertiaryFixedDim: Color(0xffffa9fb),
      onTertiaryFixedVariant: Color(0xff5e1362),
      surfaceDim: Color(0xff131319),
      surfaceBright: Color(0xff45434b),
      surfaceContainerLowest: Color(0xff07070c),
      surfaceContainerLow: Color(0xff1e1d23),
      surfaceContainer: Color(0xff28272e),
      surfaceContainerHigh: Color(0xff333239),
      surfaceContainerHighest: Color(0xff3e3d44),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff2edff),
      surfaceTint: Color(0xffc7bfff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffc3bbff),
      onPrimaryContainer: Color(0xff080038),
      secondary: Color(0xfff2edff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffc3bdeb),
      onSecondaryContainer: Color(0xff0a052a),
      tertiary: Color(0xffffeaf9),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xfffda4f9),
      onTertiaryContainer: Color(0xff1c001e),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff131319),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfff3eefe),
      outlineVariant: Color(0xffc5c0d0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e1ea),
      inversePrimary: Color(0xff45389b),
      primaryFixed: Color(0xffe4dfff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffc7bfff),
      onPrimaryFixedVariant: Color(0xff0e0048),
      secondaryFixed: Color(0xffe4dfff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffc7c1ef),
      onSecondaryFixedVariant: Color(0xff100b2f),
      tertiaryFixed: Color(0xffffd6f9),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffffa9fb),
      onTertiaryFixedVariant: Color(0xff260029),
      surfaceDim: Color(0xff131319),
      surfaceBright: Color(0xff514f56),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff201f25),
      surfaceContainer: Color(0xff312f36),
      surfaceContainerHigh: Color(0xff3c3a42),
      surfaceContainerHighest: Color(0xff47464d),
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
     scaffoldBackgroundColor: colorScheme.background,
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
