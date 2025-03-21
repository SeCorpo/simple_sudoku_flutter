class PuzzleAlreadyExistsException implements Exception {
  @override
  String toString() => "This puzzle was already saved. Skipping save.";
}

class PuzzleNotFoundException implements Exception {
  @override
  String toString() => "The requested puzzle could not be found.";
}

class PuzzleLoadException implements Exception {
  @override
  String toString() => "Failed to load saved puzzles.";
}

class PuzzleSaveException implements Exception {
  @override
  String toString() => "Failed to save puzzle.";
}

class PuzzleResetException implements Exception {
  @override
  String toString() => "Failed to reset puzzle progress.";
}

class PuzzleRemoveException implements Exception {
  @override
  String toString() => "Failed to remove the puzzle.";
}

class PuzzleClearException implements Exception {
  @override
  String toString() => "Failed to clear saved puzzles.";
}
