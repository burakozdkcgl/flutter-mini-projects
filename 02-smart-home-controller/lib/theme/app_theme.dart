import 'package:flutter/material.dart';

/// App theme configurations and shared design constants for the Smart Home Controller.
class AppTheme {
  // Brand colors matching the assignment specification
  static const Color primaryBlue = Color(0xFF2563EB); // Vibrant Royal Blue
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color darkBlue = Color(0xFF1D4ED8);
  static const Color backgroundGrey = Color(0xFFF8FAFC);
  static const Color cardBackground = Colors.white;

  // Status colors
  static const Color statusActiveGreen = Color(0xFF16A34A);
  static const Color statusInactiveGrey = Color(0xFF94A3B8);
  static const Color statusHeatingOrange = Color(0xFFEA580C);

  // Device accent colors
  static const Color lightAccent = Color(0xFFF59E0B);
  static const Color thermostatAccent = Color(0xFFEF4444);
  static const Color speakerAccent = Color(0xFF2563EB);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundGrey,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        surface: cardBackground,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryBlue;
          }
          return const Color(0xFFCBD5E1);
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }
}
