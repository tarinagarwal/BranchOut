import 'package:flutter/material.dart';

class AppTheme {
  // Light Mode Colors
  static const Color lightPrimary = Color(0xFF6B7F39);
  static const Color lightBackground = Color(0xFFF5F5F0);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF2C2C2C);
  static const Color lightAccent = Color(0xFF7A9B3C);

  // Dark Mode Colors
  static const Color darkPrimary = Color(0xFF8FA653);
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF121212);
  static const Color darkText = Color(0xFFE8E8E8);
  static const Color darkAccent = Color(0xFF9DB668);

  // Action Colors
  static const Color matchColor = Color(0xFF6B7F39);
  static const Color passColor = Color(0xFF8B4513);
  static const Color superLikeColor = Color(0xFFD4AF37);
  static const Color successColor = Color(0xFF228B22);
  static const Color errorColor = Color(0xFFE2725B);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: lightPrimary,
      secondary: lightAccent,
      surface: lightSurface,
      error: errorColor,
    ),
    scaffoldBackgroundColor: lightBackground,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: lightText),
      bodyMedium: TextStyle(color: lightText),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: lightSurface,
      foregroundColor: lightText,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: lightSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: darkPrimary,
      secondary: darkAccent,
      surface: darkSurface,
      error: errorColor,
    ),
    scaffoldBackgroundColor: darkBackground,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: darkText),
      bodyMedium: TextStyle(color: darkText),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurface,
      foregroundColor: darkText,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: darkSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimary,
        foregroundColor: darkBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
  );
}
