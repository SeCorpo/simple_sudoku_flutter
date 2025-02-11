import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/game/game_bloc.dart';
import '../../bloc/provider/provider_bloc.dart';
import '../../models/puzzle_model.dart';
import '../widgets/game_grid.dart';
import '../widgets/clue_numbers.dart';
import '../widgets/slider_widget.dart';

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
      body: BlocListener<ProviderBloc, ProviderState>(
        listener: (context, state) {
          if (state is PuzzleSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Puzzle saved successfully!")),
            );
          } else if (state is SavePuzzleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: BlocBuilder<GameBloc, GameState>(
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
      ),
    );
  }

  /// Show "New Puzzle" button when no puzzle is loaded (fail-safe feature)
  Widget _buildInitialScreen(BuildContext context) {
    return _buildNewPuzzleButton(context);
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
          _buildNewPuzzleButton(context),

          // Show "You Won!" and Save Button if the game is completed
          if (isWon) ...[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("🎉 You Won! 🎉", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<ProviderBloc>().add(SavePuzzle(puzzle: puzzle));
              },
              child: const Text("Save Puzzle"),
            ),
          ],
        ],
      ),
    );
  }

  /// Button to generate a new puzzle with size selection
  Widget _buildNewPuzzleButton(BuildContext context) {
    int selectedSize = 7;

    return Column(
      children: [
        SliderWidget(
          min: 5,
          max: 15,
          divisions: 10,
          initialValue: selectedSize,
          onChanged: (size) {
            selectedSize = size;
          },
        ),

        const SizedBox(height: 10),

        ElevatedButton(
          onPressed: () {
            context.read<GameBloc>().add(GenerateNewPuzzle(size: selectedSize));
          },
          child: const Text("New Puzzle"),
        ),
      ],
    );
  }


}
