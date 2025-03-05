import 'dart:io';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_sudoku_flutter/models/puzzle_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized

  late String documentsPath;
  late File puzzleFile;

  setUpAll(() async {
    // Get the actual Documents directory for Linux
    final String homeDir = Platform.environment['HOME'] ?? '/home/user';
    documentsPath = "$homeDir/Documents/simple_sudoku"; // Correct path

    // Ensure the directory exists
    final folder = Directory(documentsPath);
    if (!folder.existsSync()) {
      folder.createSync(recursive: true);
    }

    // Set the path to `puzzles.json`
    puzzleFile = File("$documentsPath/puzzles.json");

    print("📂 Using real directory: $documentsPath");
  });

  test('Remove only float puzzles from the actual Linux Documents folder', () async {
    final stopwatch = Stopwatch()..start();

    // Ensure the file exists before attempting to load puzzles
    if (!puzzleFile.existsSync()) {
      print("⚠️ No puzzles.json file found! Creating an empty one...");
      await puzzleFile.writeAsString(jsonEncode([])); // Create empty file
    }

    // Load puzzles manually from JSON file
    List<PuzzleModel> savedPuzzles = [];
    try {
      final content = await puzzleFile.readAsString();
      final List<dynamic> jsonList = jsonDecode(content);
      savedPuzzles = jsonList.map((json) => PuzzleModel.fromJson(json)).toList();
    } catch (e) {
      print("❌ Error loading puzzles: $e");
    }

    print("📂 Puzzles before removal: ${savedPuzzles.length}");

    // Count float puzzles before removal
    final int floatPuzzlesBefore = savedPuzzles.where((p) => p.difficulty == PuzzleDifficulty.float).length;
    print("🧩 Float puzzles before removal: $floatPuzzlesBefore");

    // Filter out only `float` difficulty puzzles
    final filteredPuzzles = savedPuzzles.where((p) => p.difficulty != PuzzleDifficulty.float).toList();

    // Overwrite the file with the filtered puzzles
    final jsonString = jsonEncode(filteredPuzzles.map((p) => p.toJson()).toList());
    await puzzleFile.writeAsString(jsonString);

    // Load puzzles again after removing float difficulty
    List<PuzzleModel> updatedPuzzles = [];
    try {
      final content = await puzzleFile.readAsString();
      final List<dynamic> jsonList = jsonDecode(content);
      updatedPuzzles = jsonList.map((json) => PuzzleModel.fromJson(json)).toList();
    } catch (e) {
      print("❌ Error reloading puzzles: $e");
    }

    print("📂 Puzzles after removal: ${updatedPuzzles.length}");

    // Count float puzzles after removal
    final int floatPuzzlesAfter = updatedPuzzles.where((p) => p.difficulty == PuzzleDifficulty.float).length;
    print("🧩 Float puzzles after removal: $floatPuzzlesAfter");

    // Ensure all `float` puzzles were removed and other puzzles remained
    expect(floatPuzzlesAfter, equals(0));
    expect(updatedPuzzles.length, equals(savedPuzzles.length - floatPuzzlesBefore));

    stopwatch.stop();
    print("✅ Successfully removed all float puzzles in ${stopwatch.elapsedMilliseconds}ms!");
    print("📂 JSON file updated: $documentsPath/puzzles.json");
  });
}
