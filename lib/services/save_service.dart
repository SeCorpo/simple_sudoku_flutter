import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../core/custom_exceptions.dart';
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
      throw PuzzleLoadException();
    }
  }

  /// Save a new solved puzzle
  Future<void> savePuzzle(PuzzleModel puzzle) async {
    try {
      final file = await _getFile();
      List<PuzzleModel> puzzles = await loadPuzzles();

      if (puzzles.any((p) => p.puzzleId == puzzle.puzzleId)) {
        throw PuzzleAlreadyExistsException();
      }

      puzzles.add(puzzle);

      await file.writeAsString(jsonEncode(puzzles.map((p) => p.toJson()).toList()));
      Logger.i("Puzzle with ID '${puzzle.puzzleId}' saved.");
    } catch (e) {
      Logger.e("Error saving puzzle: $e");
      if (e is PuzzleAlreadyExistsException) rethrow;
      throw PuzzleSaveException();
    }
  }

  /// Mark a puzzle as completed
  Future<void> markPuzzleAsCompleted(String puzzleId) async {
    try {
      final file = await _getFile();
      List<PuzzleModel> puzzles = await loadPuzzles();

      int index = puzzles.indexWhere((p) => p.puzzleId == puzzleId);
      if (index == -1) {
        Logger.w("Puzzle '$puzzleId' not found.");
        throw PuzzleNotFoundException();
      }

      puzzles[index] = puzzles[index].copyWith(completed: true);

      await file.writeAsString(jsonEncode(puzzles.map((p) => p.toJson()).toList()));
      Logger.i("Puzzle '$puzzleId' marked as completed.");
    } catch (e) {
      Logger.w("Error marking puzzle as completed: $e");
      if (e is PuzzleNotFoundException) rethrow;
      throw PuzzleSaveException();
    }
  }

  /// Reset all puzzles' completion status to false
  Future<void> resetProgress() async {
    try {
      final file = await _getFile();
      List<PuzzleModel> puzzles = await loadPuzzles();

      puzzles = puzzles.map((puzzle) => puzzle.copyWith(completed: false)).toList();

      await file.writeAsString(jsonEncode(puzzles.map((p) => p.toJson()).toList()));
      Logger.i("All puzzles completed set to false");
    } catch (e) {
      Logger.e("Error resetting progress: $e");
      throw PuzzleResetException();
    }
  }

  /// Remove a single puzzle by ID
  Future<void> removePuzzle(String puzzleId) async {
    try {
      final file = await _getFile();
      List<PuzzleModel> puzzles = await loadPuzzles();

      final int index = puzzles.indexWhere((p) => p.puzzleId == puzzleId);
      if (index == -1) {
        Logger.w("Puzzle not found: $puzzleId");
        throw PuzzleNotFoundException();
      }

      puzzles.removeAt(index);

      await file.writeAsString(jsonEncode(puzzles.map((p) => p.toJson()).toList()));
      Logger.i("Puzzle removed: $puzzleId");
    } catch (e) {
      Logger.e("Error removing puzzle: $e");
      if (e is PuzzleNotFoundException) rethrow;
      throw PuzzleRemoveException();
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
      throw PuzzleClearException();
    }
  }
}
