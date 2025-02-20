import '../../models/puzzle_model.dart';

class StringUtils {
  /// Capitalizes the first letter of a string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// **Helper: Parse Enum from String**
  static PuzzleDifficulty parseDifficulty(String difficulty) {
    return PuzzleDifficulty.values.firstWhere(
          (e) => e.name == difficulty,
      orElse: () => PuzzleDifficulty.float,
    );
  }
}
