import 'package:flutter/material.dart';

class AppTypography {
  static const TextTheme lightTextTheme = TextTheme(
    bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF333333), fontWeight: FontWeight.w500), // Dark gray
    bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF555555)), // Slightly lighter gray
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF00897B)), // Teal accent
  );

  static const TextTheme darkTextTheme = TextTheme(
    bodyLarge: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF89CFF0)), // Brighter sky blue
  );
}
