import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/game/game_bloc.dart';
import '../../bloc/provider/provider_bloc.dart';
import '../../models/puzzle_model.dart';
import '../widgets/congratulations_widget.dart';
import '../widgets/game_grid.dart';
import '../widgets/clue_numbers_widget.dart';
import '../widgets/save_puzzle_widget.dart';
import '../widgets/slider_widget.dart';
import '../widgets/snackbar_widget.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

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
            SnackBarWidget.show(context, "Puzzle saved successfully!");
          } else if (state is SavePuzzleError) {
            SnackBarWidget.show(context, state.error, isError: true);
          } else if (state is MarkPuzzleCompletedError) {
            SnackBarWidget.show(context, state.error, isError: true);
          }
        },
        child: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            if (state is GameInitial) {
              return _buildInitialScreen(context, state.defaultPuzzleSize);
            } else if (state is GameLoaded) {
              return _buildGameUI(context, state.puzzle, state.showSolution);
            } else if (state is GameWon) {
              if(!state.puzzle.completed) {
                context.read<ProviderBloc>().add(
                    MarkPuzzleCompleted(puzzleId: state.puzzle.puzzleId));
              }
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
  Widget _buildInitialScreen(BuildContext context, int defaultPuzzleSize) {
    return _buildNewPuzzleButton(context, defaultPuzzleSize);
  }

  Widget _buildGameUI(BuildContext context, PuzzleModel puzzle, bool showSolution, {bool isWon = false}) {
    double gridSize = MediaQuery.of(context).size.width < 600 ? 30 : 40;
    int maxRowClueLength = puzzle.rowClues.fold(1, (max, clue) => clue.length > max ? clue.length : max);
    int maxColClueLength = puzzle.colClues.fold(1, (max, clue) => clue.length > max ? clue.length : max);

    double dynamicClueWidth = (gridSize * maxRowClueLength).clamp(50, 150);
    double dynamicClueHeight = (gridSize * maxColClueLength).clamp(50, 150);

    return Center(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top Clue Numbers
          SizedBox(
            height: dynamicClueHeight,
            child: Padding(
              padding: EdgeInsets.only(left: dynamicClueWidth),
              child: ClueNumbersWidget(clues: puzzle.colClues, isRow: false, gridSize: gridSize),
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
                child: ClueNumbersWidget(clues: puzzle.rowClues, isRow: true, gridSize: gridSize),
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
          _buildNewPuzzleButton(context, puzzle.cols),

          // Show "You Won!" and Save Button if the game is completed
          if (isWon) ...[
            const CongratulationsWidget(),
            SavePuzzleWidget(puzzle: puzzle)
          ],
        ],
      ),
    )
    );
  }

  /// Button to generate a new puzzle with size selection
  Widget _buildNewPuzzleButton(BuildContext context, int puzzleSize) {
    int selectedSize = puzzleSize;

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
