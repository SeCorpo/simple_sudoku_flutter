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


// SHOP EXCEPTIONS

class ShopReadException implements Exception {
  @override
  String toString() => "Failed to read shop data.";
}

class ShopWriteException implements Exception {
  @override
  String toString() => "Failed to write shop data.";
}

class NotEnoughPointsException implements Exception {
  @override
  String toString() => "Not enough points to buy this item.";
}

class ShopPurchaseException implements Exception {
  @override
  String toString() => "Failed to complete the purchase.";
}

class ShopResetException implements Exception {
  @override
  String toString() => "Failed to reset shop progress.";
}
