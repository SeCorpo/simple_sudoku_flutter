import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import '../models/puzzle_model.dart';
import '../models/cell_model.dart';

class PuzzleService {
  final Random _random = Random();

  /// **Generate a random puzzle**
  PuzzleModel generateRandomPuzzle({int size = 5, PuzzleDifficulty difficulty = PuzzleDifficulty.float, int starRating = 0}) {
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

    List<List<int>> rowClues = generateGroupedClues(grid, isRow: true);
    List<List<int>> colClues = generateGroupedClues(grid, isRow: false);

    String puzzleId = _generatePuzzleId(grid);

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

  /// **Generate grouped clues based on the correct solution**
  static List<List<int>> generateGroupedClues(List<List<CellModel>> grid, {required bool isRow}) {
    int size = grid.length;
    return List.generate(size, (i) {
      List<bool> filledCells = List.generate(size, (j) => (isRow ? grid[i][j] : grid[j][i]).isCorrect);
      return _groupClueNumbers(filledCells);
    });
  }

  /// **Helper: Convert consecutive filled cells into grouped clue numbers**
  static List<int> _groupClueNumbers(List<bool> cells) {
    List<int> grouped = [];
    int count = 0;

    for (bool cell in cells) {
      if (cell) {
        count++;
      } else if (count > 0) {
        grouped.add(count);
        count = 0;
      }
    }
    if (count > 0) grouped.add(count);

    return grouped.isEmpty ? [0] : grouped;
  }

  /// **Generate a SHA-256 hash from the grid to use as puzzle ID**
  String _generatePuzzleId(List<List<CellModel>> grid) {
    String gridString = grid.map((row) => row.map((cell) => cell.isCorrect ? "1" : "0").join()).join("|");

    var bytes = utf8.encode(gridString);
    var digest = sha256.convert(bytes);

    return digest.toString();
  }
}
