import 'package:flutter/material.dart';

/// App theme configurations and shared design constants for the Smart Home Controller.
class AppTheme {
  // ── Core palette (deep slate-blue) ───────────────────────────────────────
  static const Color primary = Color(0xFF1E3A5F);       // Dark navy
  static const Color primaryMid = Color(0xFF2D5986);    // Mid navy
  static const Color primaryLight = Color(0xFF3B82F6);  // Sky blue accent
  static const Color backgroundGrey = Color(0xFFF0F4F8);
  static const Color cardBackground = Colors.white;
  static const Color surfaceGrey = Color(0xFFF8FAFC);

  // Status
  static const Color statusActiveGreen = Color(0xFF10B981);
  static const Color statusInactiveGrey = Color(0xFFCBD5E1);
  static const Color statusCooling = Color(0xFF3B82F6);

  // Device accent colors — all desaturated, harmonious
  static const Color lightAccent    = Color(0xFFF59E0B); // amber
  static const Color thermoAccent   = Color(0xFFEF4444); // coral-red
  static const Color speakerAccent  = Color(0xFF8B5CF6); // violet

  // Gradient for header
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E3A5F), Color(0xFF2D5986), Color(0xFF1E4D8C)],
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundGrey,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        surface: cardBackground,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFFE8EDF2), width: 1),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(Colors.white),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return const Color(0xFFCBD5E1);
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      sliderTheme: const SliderThemeData(
        trackHeight: 4,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
      ),
    );
  }
}
