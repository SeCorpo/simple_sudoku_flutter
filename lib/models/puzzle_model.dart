import 'cell_model.dart';

/// **Puzzle Difficulty Enum**
enum PuzzleDifficulty { float, easy, medium, hard, expert, impossible }

/// **Puzzle Model**
class PuzzleModel {
  final String puzzleId;
  final int rows;
  final int cols;
  final PuzzleDifficulty difficulty;
  final List<List<CellModel>> grid;
  final List<List<int>> rowClues;
  final List<List<int>> colClues;

  PuzzleModel({
    required this.puzzleId,
    required this.rows,
    required this.cols,
    required this.difficulty,
    required this.grid,
    required this.rowClues,
    required this.colClues,
  });

  /// **Check if puzzle is solved**
  bool isSolved() => grid.every((row) => row.every((cell) => cell.isFilled == cell.isCorrect));

  /// **Convert to JSON (Excludes user selections)**
  Map<String, dynamic> toJson() => {
    'puzzleId': puzzleId,
    'rows': rows,
    'cols': cols,
    'difficulty': difficulty.name,
    'grid': grid.map((row) => row.map((cell) => cell.toJson()).toList()).toList(),
    'rowClues': rowClues,
    'colClues': colClues,
  };

  /// **Load puzzle from JSON (Clears user selections)**
  factory PuzzleModel.fromJson(Map<String, dynamic> json) => PuzzleModel(
    puzzleId: json['puzzleId'],
    rows: json['rows'],
    cols: json['cols'],
    difficulty: _parseDifficulty(json['difficulty']),
    grid: (json['grid'] as List)
        .map((row) => (row as List).map((cell) => CellModel.fromJson(cell)).toList())
        .toList(),
    rowClues: (json['rowClues'] as List).map((row) => List<int>.from(row)).toList(),
    colClues: (json['colClues'] as List).map((col) => List<int>.from(col)).toList(),
  );

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

  /// **Helper: Parse Enum from String**
  static PuzzleDifficulty _parseDifficulty(String difficulty) {
    return PuzzleDifficulty.values.firstWhere(
          (e) => e.name == difficulty,
      orElse: () => PuzzleDifficulty.float,
    );
  }
}
