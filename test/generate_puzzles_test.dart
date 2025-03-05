import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_sudoku_flutter/models/puzzle_model.dart';
import 'package:simple_sudoku_flutter/services/puzzle_service.dart';
import 'package:simple_sudoku_flutter/services/save_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PuzzleService puzzleService;
  late SaveService saveService;
  late String documentsPath;

  setUpAll(() async {
    final String homeDir = Platform.environment['HOME'] ?? '/home/user';
    documentsPath = "$homeDir/Documents";

    final folder = Directory(documentsPath);
    if (!folder.existsSync()) {
      folder.createSync(recursive: true);
    }

    print("📂 Using real directory: $documentsPath");

    // Mock `getApplicationDocumentsDirectory()` to return `~/Documents`
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
          (MethodCall methodCall) async {
        if (methodCall.method == 'getApplicationDocumentsDirectory') {
          return documentsPath;
        }
        return null;
      },
    );
  });

  setUp(() async {
    puzzleService = PuzzleService();
    saveService = SaveService();
  });

  test('Generate and save 1000 test puzzles with dynamic progress updates', () async {
    final stopwatch = Stopwatch()..start();
    int savedCount = 0;

    final savedPuzzlesBefore = await saveService.loadPuzzles();
    print("📂 Puzzles before test: ${savedPuzzlesBefore.length}");

    // Find the last test_puzzle_X ID
    int lastPuzzleId = savedPuzzlesBefore
        .where((p) => p.puzzleId.startsWith('test_puzzle_'))
        .map((p) => int.tryParse(p.puzzleId.split('_').last) ?? -1)
        .fold(-1, (a, b) => a > b ? a : b);

    // If no existing test puzzles, start from 0
    int startId = lastPuzzleId + 1;
    int endId = startId + 1000;

    print("🔢 Starting from test_puzzle_$startId, generating up to test_puzzle_${endId - 1}");

    // Dynamic update interval (slows down over time)
    int lastPrinted = startId;
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      if (savedCount == 0) return;

      int progress = ((savedCount / 1000) * 100).toInt(); // Percentage
      int progressStep = (progress < 10) ? 5 : (progress < 50) ? 10 : 25; // Change frequency dynamically

      if (savedCount >= lastPrinted + progressStep) {
        print("⏳ Progress: $progress% ($savedCount / 1000)");
        lastPrinted = savedCount;
      }

      if (savedCount >= 1000) {
        timer.cancel();
      }
    });

    // Generate and save 1000 new puzzles, continuing from last ID
    for (int i = startId; i < endId; i++) {
      final puzzle = puzzleService.generateRandomPuzzle(size: 5).copyWith(
        puzzleId: "test_puzzle_$i",
        difficulty: PuzzleDifficulty.float,
        starRating: 1,
      );

      await saveService.savePuzzle(puzzle);
      savedCount++; // Increment saved count
    }

    // Load puzzles after adding new ones
    final savedPuzzlesAfter = await saveService.loadPuzzles();
    print("📂 Puzzles after test: ${savedPuzzlesAfter.length}");

    // Ensure at least 1000 new puzzles were added
    expect(savedPuzzlesAfter.length, greaterThanOrEqualTo(savedPuzzlesBefore.length + 1000));

    stopwatch.stop();
    print("✅ Successfully generated and saved 1000 test puzzles in ${stopwatch.elapsedMilliseconds}ms!");
    print("📂 JSON file location: $documentsPath/simple_sudoku/puzzles.json");
  });
}
