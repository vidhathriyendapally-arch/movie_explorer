import 'package:flutter/material.dart';

// One place for the look of the whole app.
class AppTheme {
  // Fade page transition on every platform.
  static const _transitions = PageTransitionsTheme(builders: {
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
  });

  // Light theme: white background + black text = clear in B&W print.
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo).copyWith(
      surface: Colors.white,
      onSurface: Colors.black,
      outline: Colors.black,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black, foregroundColor: Colors.white),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black, foregroundColor: Colors.white),
    ),
    pageTransitionsTheme: _transitions,
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo, brightness: Brightness.dark),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1F1F1F), foregroundColor: Colors.white),
    pageTransitionsTheme: _transitions,
  );
}
