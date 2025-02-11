import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/game/game_bloc.dart';
import '../../models/puzzle_model.dart';
import '../widgets/game_grid.dart';
import '../widgets/clue_numbers.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Sudoku Game"),
        actions: [
          BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              bool showSolution = (state is GameLoaded) ? state.showSolution : false;
              return IconButton(
                icon: Icon(showSolution ? Icons.visibility_off : Icons.visibility),
                onPressed: () => context.read<GameBloc>().add(ToggleSolution()),
                tooltip: showSolution ? "Hide Solution" : "Show Solution",
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          if (state is GameInitial) {
            return _buildInitialScreen(context);
          } else if (state is GameLoaded) {
            return _buildGameUI(context, state.puzzle, state.showSolution);
          } else if (state is GameWon) {
            return _buildGameUI(context, state.puzzle, false, isWon: true);
          } else {
            return const Center(child: Text("Unknown state"));
          }
        },
      ),
    );
  }

  /// Show "New Puzzle" button when no puzzle is loaded (fail-safe feature)
  Widget _buildInitialScreen(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => context.read<GameBloc>().add(GenerateNewPuzzle(size: 7)),
        child: const Text("New Puzzle"),
      ),
    );
  }

  Widget _buildGameUI(BuildContext context, PuzzleModel puzzle, bool showSolution, {bool isWon = false}) {
    double gridSize = MediaQuery.of(context).size.width < 600 ? 30 : 40;
    int maxRowClueLength = puzzle.rowClues.fold(1, (max, clue) => clue.length > max ? clue.length : max);
    int maxColClueLength = puzzle.colClues.fold(1, (max, clue) => clue.length > max ? clue.length : max);

    double dynamicClueWidth = (gridSize * maxRowClueLength).clamp(50, 150);
    double dynamicClueHeight = (gridSize * maxColClueLength).clamp(50, 150);

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top Clue Numbers
          SizedBox(
            height: dynamicClueHeight,
            child: Padding(
              padding: EdgeInsets.only(left: dynamicClueWidth),
              child: ClueNumbers(clues: puzzle.colClues, isRow: false, gridSize: gridSize),
            ),
          ),

          // Main Content (Row Clues + Grid)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Left Clue Numbers
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
                  onCellTap: (row, col) => context.read<GameBloc>().add(ToggleCell(row: row, col: col)),
                  gridSize: gridSize,
                  showSolution: showSolution,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // "New Puzzle" Button
          ElevatedButton(
            onPressed: () => context.read<GameBloc>().add(GenerateNewPuzzle(size: 7)),
            child: const Text("New Puzzle"),
          ),

          // Show "You Won!" if the game is completed
          if (isWon)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("🎉 You Won! 🎉", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }
}
