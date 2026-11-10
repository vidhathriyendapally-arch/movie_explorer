import 'package:flutter/material.dart';

// One place for the look of the whole app (colours, text, buttons, transitions).
class AppTheme {
  // Gradient used by the hero banner on the home screen.
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E1B4B), Color(0xFF3730A3)],
  );

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF3730A3),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFE0E7FF),
    onPrimaryContainer: Color(0xFF1E1B4B),
    secondary: Color(0xFFF59E0B),
    onSecondary: Colors.black,
    error: Color(0xFFB91C1C),
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Color(0xFF0F172A),
    onSurfaceVariant: Color(0xFF475569),
    outline: Color(0xFFB8C0CC),
    outlineVariant: Color(0xFFE2E8F0),
  );

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF818CF8),
    onPrimary: Color(0xFF0B1020),
    primaryContainer: Color(0xFF2A2F66),
    onPrimaryContainer: Color(0xFFE0E7FF),
    secondary: Color(0xFFFBBF24),
    onSecondary: Colors.black,
    error: Color(0xFFF87171),
    onError: Colors.black,
    surface: Color(0xFF151B2E),
    onSurface: Color(0xFFE8EAF2),
    onSurfaceVariant: Color(0xFF9AA3BC),
    outline: Color(0xFF343D5C),
    outlineVariant: Color(0xFF232B45),
  );

  // Fade page transition on every platform.
  static const _transitions = PageTransitionsTheme(builders: {
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
  });

  static final ThemeData light = _build(_lightScheme, const Color(0xFFF4F5FA));
  static final ThemeData dark = _build(_darkScheme, const Color(0xFF0B1020));

  // Both themes share the same structure; only the colours differ.
  static ThemeData _build(ColorScheme s, Color background) {
    final base = ThemeData(useMaterial3: true, colorScheme: s);
    final t = base.textTheme;
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    const padding = EdgeInsets.symmetric(horizontal: 20, vertical: 14);
    const label = TextStyle(fontWeight: FontWeight.w700);

    return base.copyWith(
      scaffoldBackgroundColor: background,
      textTheme: t.copyWith(
        headlineMedium: t.headlineMedium
            ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5),
        titleLarge: t.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        titleMedium: t.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: s.surface,
        foregroundColor: s.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w800, color: s.onSurface),
        shape: Border(bottom: BorderSide(color: s.outline)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
            padding: padding, shape: shape, textStyle: label),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            padding: padding, shape: shape, textStyle: label),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: padding,
          shape: shape,
          textStyle: label,
          foregroundColor: s.onSurface,
          side: BorderSide(color: s.outline, width: 1.5),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      pageTransitionsTheme: _transitions,
    );
  }
}
