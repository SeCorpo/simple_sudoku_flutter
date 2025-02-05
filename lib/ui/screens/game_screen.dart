import 'package:flutter/material.dart';
import '../../models/puzzle_model.dart';
import '../../services/puzzle_service.dart';
import '../widgets/game_grid.dart';
import '../widgets/clue_numbers.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late PuzzleModel puzzle;

  @override
  void initState() {
    super.initState();
    puzzle = PuzzleService.generateRandomPuzzle(size: 6);
  }

  void toggleCellState(int row, int col) {
    setState(() {
      puzzle.grid[row][col].toggle();
      if (puzzle.isSolved()) {
        _showWinDialog();
      }
    });
  }

  /// Show Win Dialog when puzzle is completed
  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("🎉 Congratulations!"),
          content: const Text("You solved the puzzle!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  puzzle = PuzzleService.generateRandomPuzzle(size: 10);
                });
              },
              child: const Text("New Puzzle"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nonogram Puzzle")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double gridSize = constraints.maxWidth < 600 ? 30 : 40;

          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Column Clues
                SizedBox(
                  height: gridSize * 2,
                  child: ClueNumbers(clues: puzzle.colClues, isRow: false, gridSize: gridSize),
                ),

                // Main Content (Row Clues + Grid)
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row Clues (Left of Grid)
                      SizedBox(
                        width: gridSize * 2,
                        child: ClueNumbers(clues: puzzle.rowClues, isRow: true, gridSize: gridSize),
                      ),

                      // Puzzle Grid
                      SizedBox(
                        width: gridSize * puzzle.cols,
                        height: gridSize * puzzle.rows,
                        child: GameGrid(puzzle: puzzle, onCellTap: toggleCellState, gridSize: gridSize),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
