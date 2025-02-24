import 'package:flutter/material.dart';
import '../../core/theme/snackbar_styles.dart';

class SnackBarWidget {
  static void show(BuildContext context, String message, {bool isError = false}) {
    final brightness = Theme.of(context).brightness;
    final errorColor = AppSnackBarStyles.getErrorColor(brightness);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? errorColor : Theme.of(context).snackBarTheme.backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
