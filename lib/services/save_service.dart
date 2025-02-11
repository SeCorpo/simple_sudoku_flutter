import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/puzzle_model.dart';

class SaveService {
  static const String _fileName = "puzzles.json";

  /// Get the file location for saving puzzles
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/$_fileName");
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

      puzzles.add(puzzle);

      final String jsonString = jsonEncode(puzzles.map((p) => p.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      print("Error saving puzzle: $e");
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
