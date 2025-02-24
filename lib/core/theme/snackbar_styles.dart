import 'package:flutter/material.dart';

class AppSnackBarStyles {
  static const Color lightErrorColor = Color(0xFFD32F2F);
  static const Color darkErrorColor = Color(0xFFB71C1C);

  static SnackBarThemeData lightSnackBarTheme = SnackBarThemeData(
    backgroundColor: const Color(0xFF00897B),
    contentTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    actionTextColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    behavior: SnackBarBehavior.floating,
    elevation: 6,
  );

  static SnackBarThemeData darkSnackBarTheme = SnackBarThemeData(
    backgroundColor: const Color(0xFF162447),
    contentTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    actionTextColor: Colors.lightBlueAccent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    behavior: SnackBarBehavior.floating,
    elevation: 6,
  );

  /// Returns the appropriate error color based on the theme.
  static Color getErrorColor(Brightness brightness) {
    return brightness == Brightness.dark ? darkErrorColor : lightErrorColor;
  }
}
