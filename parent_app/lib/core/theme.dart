import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors - Premium Purple & Blue Gradient
  static const Color primaryPurple = Color(0xFF6C5CE7);
  static const Color accentBlue = Color(0xFF00CEC9);
  static const Color deepBackground = Color(0xFF0F0C20);
  static const Color cardDarkBackground = Color(0xFF1B1736);
  static const Color textPrimary = Color(0xFFF1F2F6);
  static const Color textSecondary = Color(0xFFA4B0BE);
  static const Color alertRed = Color(0xFFFF4757);
  static const Color successGreen = Color(0xFF2ED573);
  static const Color warningOrange = Color(0xFFFFA502);

  // Gradient Decorations
  static const BoxDecoration primaryGradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF6C5CE7), Color(0xFF8E44AD), Color(0xFF00CEC9)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const BoxDecoration glassmorphicCardDecoration = BoxDecoration(
    color: Color(0x2B1B1736),
    borderRadius: BorderRadius.all(Radius.circular(20)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0x336C5CE7), width: 1.5),
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x1A000000),
        blurRadius: 16,
        spreadRadius: 2,
      )
    ],
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: deepBackground,
      colorScheme: const ColorScheme.dark(
        primary: primaryPurple,
        secondary: accentBlue,
        surface: cardDarkBackground,
        error: alertRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: cardDarkBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
      ),
    );
  }
}
