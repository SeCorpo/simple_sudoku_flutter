import 'cell_model.dart';

class PuzzleModel {
  final int rows;
  final int cols;
  final List<List<CellModel>> grid;
  final List<List<int>> rowClues;
  final List<List<int>> colClues;

  PuzzleModel({
    required this.rows,
    required this.cols,
    required this.grid,
    required this.rowClues,
    required this.colClues,
  });

  /// **Win Validation: Check if user's solution matches the correct grid**
  bool isSolved() {
    for (var row in grid) {
      for (var cell in row) {
        if (cell.isFilled != cell.isCorrect) {
          return false;
        }
      }
    }
    return true;
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'rows': rows,
      'cols': cols,
      'grid': grid.map((row) => row.map((cell) => cell.toJson()).toList()).toList(),
      'rowClues': rowClues,
      'colClues': colClues,
    };
  }

  // Create from JSON
  factory PuzzleModel.fromJson(Map<String, dynamic> json) {
    List<List<CellModel>> grid = (json['grid'] as List)
        .map((row) => (row as List).map((cell) => CellModel.fromJson(cell)).toList())
        .toList();

    return PuzzleModel(
      rows: json['rows'],
      cols: json['cols'],
      grid: grid,
      rowClues: List<List<int>>.from(json['rowClues'].map((row) => List<int>.from(row))),
      colClues: List<List<int>>.from(json['colClues'].map((col) => List<int>.from(col))),
    );
  }
}
