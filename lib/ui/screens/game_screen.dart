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
  bool _showSolution = false; // Controls whether to show the solution

  @override
  void initState() {
    super.initState();
    puzzle = PuzzleService.generateRandomPuzzle(size: 7);
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
                  puzzle = PuzzleService.generateRandomPuzzle(size: 7);
                });
              },
              child: const Text("New Puzzle"),
            ),
          ],
        );
      },
    );
  }

  /// Toggle visibility of the correct answers
  void _toggleSolutionView() {
    setState(() {
      _showSolution = !_showSolution;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Sudoku Puzzle"),
        actions: [
          IconButton(
            icon: Icon(_showSolution ? Icons.visibility_off : Icons.visibility),
            onPressed: _toggleSolutionView,
            tooltip: _showSolution ? "Hide Solution" : "Show Solution",
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double gridSize = constraints.maxWidth < 600 ? 30 : 40;

          int maxRowClueLength = puzzle.rowClues.fold(1, (max, clue) => clue.length > max ? clue.length : max);
          int maxColClueLength = puzzle.colClues.fold(1, (max, clue) => clue.length > max ? clue.length : max);

          double dynamicClueWidth = (gridSize * maxRowClueLength).clamp(50, 150); // Left Clues Width
          double dynamicClueHeight = (gridSize * maxColClueLength).clamp(50, 150); // Top Clues Height

          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Clue Numbers (Column Clues)
                SizedBox(
                  height: dynamicClueHeight,
                  child: Padding(
                    padding: EdgeInsets.only(left: dynamicClueWidth), // Align with row clues
                    child: ClueNumbers(clues: puzzle.colClues, isRow: false, gridSize: gridSize),
                  ),
                ),

                // Main Content (Row Clues + Grid)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Left Clue Numbers (Row Clues)
                    SizedBox(
                      width: dynamicClueWidth,
                      child: ClueNumbers(clues: puzzle.rowClues, isRow: true, gridSize: gridSize),
                    ),

                    // Puzzle Grid
                    SizedBox(
                      width: gridSize * puzzle.cols,
                      height: gridSize * puzzle.rows,
                      child: GameGrid(
                        puzzle: puzzle,
                        onCellTap: toggleCellState,
                        gridSize: gridSize,
                        showSolution: _showSolution, // Pass solution visibility state
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
