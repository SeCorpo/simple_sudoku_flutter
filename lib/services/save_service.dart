import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
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
      print("Error loading puzzles: $e");
      return [];
    }
  }

  /// Save a new solved puzzle
  Future<void> savePuzzle(PuzzleModel puzzle) async {
    try {
      final file = await _getFile();
      List<PuzzleModel> puzzles = await loadPuzzles();

      if (puzzles.any((p) => p.puzzleId == puzzle.puzzleId)) {
        print("Puzzle with ID '${puzzle.puzzleId}' already exists. Skipping save.");
        return;
      }

      puzzles.add(puzzle);

      final String jsonString = jsonEncode(puzzles.map((p) => p.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      print("Error saving puzzle: $e");
    }
  }

  /// Mark a puzzle as completed
  Future<void> markPuzzleAsCompleted(String puzzleId) async {
    try {
      final file = await _getFile();
      List<PuzzleModel> puzzles = await loadPuzzles();

      bool updated = false;

      puzzles = puzzles.map((puzzle) {
        if (puzzle.puzzleId == puzzleId && !puzzle.completed) {
          updated = true;
          return puzzle.copyWith(completed: true);
        }
        return puzzle;
      }).toList();

      if (updated) {
        final String jsonString = jsonEncode(puzzles.map((p) => p.toJson()).toList());
        await file.writeAsString(jsonString);
      } else {
        print("Puzzle with ID '$puzzleId' not found or already completed.");
      }
    } catch (e) {
      print("Error marking puzzle as completed: $e");
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
      print("Error resetting progress: $e");
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
      print("Error clearing puzzles: $e");
    }
  }
}
