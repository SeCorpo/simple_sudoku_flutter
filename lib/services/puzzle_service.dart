import 'dart:math';
import '../models/puzzle_model.dart';
import '../models/cell_model.dart';
import '../ui/widgets/clue_numbers.dart'; // Import ClueNumbers to use grouping function

class PuzzleService {
  final Random _random = Random();

  /// Generate a random puzzle with a mix of filled and empty cells
  PuzzleModel generateRandomPuzzle({int size = 5}) {
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

    // Generate row and column clues dynamically
    List<List<int>> rowClues = _generateGroupedClues(grid, isRow: true);
    List<List<int>> colClues = _generateGroupedClues(grid, isRow: false);

    return PuzzleModel(
      rows: size,
      cols: size,
      grid: grid,
      rowClues: rowClues,
      colClues: colClues,
    );
  }

  /// **Generate grouped clues based on consecutive filled cells**
  List<List<int>> _generateGroupedClues(List<List<CellModel>> grid, {required bool isRow}) {
    int size = grid.length;
    List<List<int>> clues = List.generate(size, (_) => []);

    for (int i = 0; i < size; i++) {
      List<bool> filledCells = [];

      for (int j = 0; j < size; j++) {
        CellModel cell = isRow ? grid[i][j] : grid[j][i];
        filledCells.add(cell.isCorrect);
      }

      clues[i] = ClueNumbers.groupClueNumbers(filledCells);
    }

    return clues;
  }
}
