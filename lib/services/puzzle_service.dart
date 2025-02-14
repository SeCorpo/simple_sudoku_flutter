import 'dart:math';
import '../models/puzzle_model.dart';
import '../models/cell_model.dart';

class PuzzleService {
  final Random _random = Random();

  /// **Generate a random puzzle**
  PuzzleModel generateRandomPuzzle({int size = 5, PuzzleDifficulty difficulty = PuzzleDifficulty.float, int starRating = 0}) {
    // Generate unique puzzle ID
    String puzzleId = DateTime.now().millisecondsSinceEpoch.toString();

    // Generate a grid with random true/false values (50% filled probability)
    List<List<CellModel>> grid = List.generate(
      size,
          (row) => List.generate(
        size,
            (col) => CellModel(
          row: row,
          col: col,
          isCorrect: _random.nextBool(), // 50% chance of being filled
        ),
      ),
    );

    // Generate row and column clues using PuzzleModel's method
    List<List<int>> rowClues = PuzzleModel.generateGroupedClues(grid, isRow: true);
    List<List<int>> colClues = PuzzleModel.generateGroupedClues(grid, isRow: false);

    return PuzzleModel(
      puzzleId: puzzleId,
      rows: size,
      cols: size,
      difficulty: difficulty,
      starRating: starRating,
      grid: grid,
      rowClues: rowClues,
      colClues: colClues,
    );
  }
}
