import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../core/utils/logger.dart';
import '../models/puzzle_model.dart';

class SaveService {
  static const String _fileName = "puzzles.json";

  /// Get the file object pointing to the saved puzzles file.
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/simple_sudoku";
    final folder = Directory(path);

    if (!folder.existsSync()) {
      folder.createSync(recursive: true);
    }

    return File("$path/$_fileName");
  }

  /// Load all saved puzzles
  Future<List<PuzzleModel>> loadPuzzles() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) {
        return [];
      }

      final content = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(content);
      return jsonList.map((json) => PuzzleModel.fromJson(json)).toList();
    } catch (e) {
      Logger.e("Error loading puzzles: $e");
      return [];
    }
  }

  /// Save a new solved puzzle
  Future<void> savePuzzle(PuzzleModel puzzle) async {
    try {
      final file = await _getFile();
      List<PuzzleModel> puzzles = await loadPuzzles();

      if (puzzles.any((p) => p.puzzleId == puzzle.puzzleId)) {
        Logger.w("Puzzle with ID '${puzzle.puzzleId}' already exists. Skipping save.");
        return;
      }

      puzzles.add(puzzle);

      final String jsonString = jsonEncode(puzzles.map((p) => p.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      Logger.e("Error saving puzzle: $e");
    }
  }

  /// Mark a puzzle as completed
  Future<void> markPuzzleAsCompleted(String puzzleId) async {
    try {
      final file = await _getFile();
      List<PuzzleModel> puzzles = await loadPuzzles();

      // Find the index of the puzzle
      int index = puzzles.indexWhere((p) => p.puzzleId == puzzleId);
      if (index == -1) {
        Logger.w("Puzzle '$puzzleId' not found.");
        return;
      }

      puzzles[index] = puzzles[index].copyWith(completed: true);

      // Save updated puzzles
      await file.writeAsString(jsonEncode(puzzles.map((p) => p.toJson()).toList()));
      Logger.i("Puzzle '$puzzleId' marked as completed.");
    } catch (e) {
      Logger.w("Error marking puzzle as completed: $e");
    }
  }

  /// Reset all puzzles' completion status to false
  Future<void> resetProgress() async {
    try {
      final file = await _getFile();
      List<PuzzleModel> puzzles = await loadPuzzles();

      puzzles = puzzles.map((puzzle) => puzzle.copyWith(completed: false)).toList();

      final String jsonString = jsonEncode(puzzles.map((p) => p.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      Logger.e("Error resetting progress: $e");
    }
  }

  /// Remove a single puzzle by ID
  Future<void> removePuzzle(String puzzleId) async {
    try {
      final file = await _getFile();
      List<PuzzleModel> puzzles = await loadPuzzles();

      puzzles.removeWhere((p) => p.puzzleId == puzzleId);

      final String jsonString = jsonEncode(puzzles.map((p) => p.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      Logger.e("Error removing puzzle: $e");
    }
  }

  /// Clear saved puzzles (for debugging)
  Future<void> clearSavedPuzzles() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        await file.writeAsString(jsonEncode([]));
      }
    } catch (e) {
      Logger.e("Error clearing puzzles: $e");
    }
  }
}
