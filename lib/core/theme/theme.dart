import 'package:flutter/material.dart';
import 'puzzle_theme.dart';
import 'typography.dart';
import 'button_styles.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.teal,
    scaffoldBackgroundColor: const Color(0xFFF8F9FA), // Soft white with a hint of gray-blue
    textTheme: AppTypography.lightTextTheme,
    elevatedButtonTheme: AppButtonStyles.lightElevatedButtonTheme,
    appBarTheme: _appBarTheme(const Color(0xFF00897B)), // Teal accent
    sliderTheme: _sliderTheme(const Color(0xFF00897B), Colors.grey, const Color(0xFF004D40)),
    cardColor: Colors.white,
    primaryColor: const Color(0xFF00897B),
    secondaryHeaderColor: const Color(0xFFD7FFF1), // Soft pastel green
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blueGrey,
    scaffoldBackgroundColor: const Color(0xFF0D1B2A), // Rich night blue
    textTheme: AppTypography.darkTextTheme,
    elevatedButtonTheme: AppButtonStyles.darkElevatedButtonTheme,
    appBarTheme: _appBarTheme(const Color(0xFF1B263B)), // Darkened ocean blue
    sliderTheme: _sliderTheme(const Color(0xFF415A77), Colors.grey, const Color(0xFF89CFF0)),
    cardColor: const Color(0xFF1B263B),
    primaryColor: const Color(0xFF415A77),
    secondaryHeaderColor: const Color(0xFF89CFF0), // Sky blue accent
  );

  static AppBarTheme _appBarTheme(Color color) => AppBarTheme(
    color: color,
    elevation: 4,
    titleTextStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );

  static SliderThemeData _sliderTheme(
      Color activeTrack, Color inactiveTrack, Color thumbColor) =>
      SliderThemeData(
        activeTrackColor: activeTrack,
        inactiveTrackColor: inactiveTrack,
        thumbColor: thumbColor,
      );

  static PuzzleTheme puzzleTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? PuzzleTheme.dark
        : PuzzleTheme.light;
  }
}
