import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/puzzle_model.dart';
import '../models/cell_model.dart';
import '../ui/widgets/clue_numbers.dart'; // Import ClueNumbers to use grouping function

class PuzzleService {
  /// Load a puzzle from a JSON file
  static Future<PuzzleModel> loadPuzzleFromJson(String filePath) async {
    try {
      String jsonString = await rootBundle.loadString(filePath);
      Map<String, dynamic> jsonData = jsonDecode(jsonString);
      return PuzzleModel.fromJson(jsonData);
    } catch (e) {
      throw Exception('Failed to load puzzle: $e');
    }
  }

  /// Generate a random puzzle
  static PuzzleModel generateRandomPuzzle({int size = 5}) {
    List<List<CellModel>> grid = List.generate(
      size,
          (row) => List.generate(
        size,
            (col) => CellModel(
          row: row,
          col: col,
          isCorrect: (row + col) % 2 == 0, // Example: Checkerboard pattern
        ),
      ),
    );

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
  static List<List<int>> _generateGroupedClues(List<List<CellModel>> grid, {required bool isRow}) {
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
