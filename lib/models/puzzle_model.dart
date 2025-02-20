import 'package:simple_sudoku_flutter/core/utils/string_utils.dart';
import 'cell_model.dart';

/// **Puzzle Difficulty Enum**
enum PuzzleDifficulty { float, easy, medium, hard, expert, impossible }

/// **Puzzle Model**
class PuzzleModel {
  final String puzzleId;
  final int rows;
  final int cols;
  final PuzzleDifficulty difficulty;
  final int starRating;
  final List<List<CellModel>> grid;
  final List<List<int>> rowClues;
  final List<List<int>> colClues;
  final bool completed;

  PuzzleModel({
    required this.puzzleId,
    required this.rows,
    required this.cols,
    required this.difficulty,
    required this.starRating,
    required this.grid,
    required this.rowClues,
    required this.colClues,
    this.completed = false,
  });

  /// **Check if puzzle is solved**
  bool isSolved() => grid.every((row) => row.every((cell) => cell.isFilled == cell.isCorrect));

  PuzzleModel copyWith({
    String? puzzleId,
    int? rows,
    int? cols,
    PuzzleDifficulty? difficulty,
    int? starRating,
    List<List<CellModel>>? grid,
    List<List<int>>? rowClues,
    List<List<int>>? colClues,
    bool? completed,
  }) {
    return PuzzleModel(
      puzzleId: puzzleId ?? this.puzzleId,
      rows: rows ?? this.rows,
      cols: cols ?? this.cols,
      difficulty: difficulty ?? this.difficulty,
      starRating: starRating ?? this.starRating,
      grid: grid ?? this.grid,
      rowClues: rowClues ?? this.rowClues,
      colClues: colClues ?? this.colClues,
      completed: completed ?? this.completed,
    );
  }

  /// **Convert to JSON (Excludes user selections)**
  Map<String, dynamic> toJson() => {
    'puzzleId': puzzleId,
    'rows': rows,
    'cols': cols,
    'difficulty': difficulty.name,
    'starRating': starRating,
    'grid': grid.map((row) => row.map((cell) => cell.toJson()).toList()).toList(),
    'rowClues': rowClues,
    'colClues': colClues,
    'completed': completed,
  };

  /// **Load puzzle from JSON (Clears user selections)**
  factory PuzzleModel.fromJson(Map<String, dynamic> json) => PuzzleModel(
    puzzleId: json['puzzleId'],
    rows: json['rows'],
    cols: json['cols'],
    difficulty: StringUtils.parseDifficulty(json['difficulty']),
    starRating: json['starRating'],
    grid: (json['grid'] as List)
        .map((row) => (row as List).map((cell) => CellModel.fromJson(cell)).toList())
        .toList(),
    rowClues: (json['rowClues'] as List).map((row) => List<int>.from(row)).toList(),
    colClues: (json['colClues'] as List).map((col) => List<int>.from(col)).toList(),
    completed: json['completed'] ?? false,
  );




}
