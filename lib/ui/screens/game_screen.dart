import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/game/game_bloc.dart';
import '../../bloc/provider/provider_bloc.dart';
import '../../bloc/shop/shop_bloc.dart';
import '../../core/theme/button_styles.dart';
import '../../core/utils/logger.dart';
import '../../models/puzzle_model.dart';
import '../widgets/confirmation_dialog_widget.dart';
import '../widgets/congratulations_widget.dart';
import '../widgets/game_grid.dart';
import '../widgets/clue_numbers_widget.dart';
import '../widgets/icon_button_with_badge_widget.dart';
import '../widgets/save_puzzle_widget.dart';
import '../widgets/slider_widget.dart';
import '../widgets/snackbar_widget.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ShopBloc>().add(LoadShop());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Sudoku Game"),
        actions: [
          BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              if (state is GameLoaded) {
                bool showSolution = state.showSolution;
                bool showCluesSolution = state.showCluesSolution;

                return Row(
                  children: [
                    IconButton(
                      icon: Icon(showSolution ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => context.read<GameBloc>().add(ToggleSolution()),
                      tooltip: showSolution ? "Hide Solution" : "Show Solution",
                    ),
                    IconButton(
                      icon: Icon(showCluesSolution ? Icons.check_box : Icons.check_box_outline_blank),
                      onPressed: () => context.read<GameBloc>().add(ToggleCluesSolution()),
                      tooltip: showCluesSolution ? "Hide Clue Solution" : "Show Clue Solution",
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),

      body: MultiBlocListener(
        listeners: [
          BlocListener<ProviderBloc, ProviderState>(
            listener: (context, state) {
              if (state is PuzzleSaved) {
                SnackBarWidget.show(context, "Puzzle saved successfully!");
              } else if (state is SavePuzzleError) {
                SnackBarWidget.show(context, state.error, isError: true);
              } else if (state is MarkPuzzleCompletedError) {
                SnackBarWidget.show(context, state.error, isError: true);
              } else if (state is NextPuzzleFromGame) {
                context.read<GameBloc>().add(StartGameWithPuzzle(puzzle: state.puzzle));
                context.read<ProviderBloc>().add(LoadSavedPuzzles());
              } else if (state is NextPuzzleNotFoundError && !state.fromHome) {
                SnackBarWidget.show(context, state.error, isError: true);
              } else if (state is PuzzleRemoved) {
                SnackBarWidget.show(context, "Puzzle removed successfully!");
              } else if (state is RemovePuzzleError) {
                SnackBarWidget.show(context, state.error, isError: true);
              }
            },
          ),
          BlocListener<ShopBloc, ShopState>(
            listener: (context, state) {
              if (state is ShopLoaded && state.infoMessage != null) {
                SnackBarWidget.show(context, state.infoMessage!);
              }
            },
          ),
        ],
        child: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            if (state is GameInitial) {
              return _buildInitialScreen(context, state.defaultPuzzleSize);
            } else if (state is GameLoaded) {
              return _buildGameUI(context, state.puzzle, state.showSolution, state.showCluesSolution);
            } else if (state is GameWon) {
              if (state.puzzle.completed) {
                Logger.i("Puzzle '${state.puzzle.puzzleId}' is already completed.");
              } else if (state.puzzle.starRating == 0) {
                Logger.i("Puzzle '${state.puzzle.puzzleId}' is not saved and therefore can't be completed.");
              } else {
                context.read<ProviderBloc>().add(MarkPuzzleCompleted(puzzleId: state.puzzle.puzzleId));
              }
              return _buildGameUI(context, state.puzzle, true, true, isWon: true, pointsAwarded: state.pointsAwarded,);
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

  Widget _buildGameUI(BuildContext context, PuzzleModel puzzle, bool showSolution, bool showCluesSolution, {bool isWon = false, int? pointsAwarded,}) {
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
          _buildPowerupRow(context),
          const SizedBox(height: 10),

          // Top Clue Numbers
          SizedBox(
            height: dynamicClueHeight,
            child: Padding(
              padding: EdgeInsets.only(left: dynamicClueWidth),
              child: ClueNumbersWidget(
                clues: puzzle.colClues,
                isRow: false,
                gridSize: gridSize,
                solved: List.generate(puzzle.cols, (col) => puzzle.isColumnSolved(col)),
                useSolvedColor: showCluesSolution,
              ),
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
                child: ClueNumbersWidget(
                  clues: puzzle.rowClues,
                  isRow: true,
                  gridSize: gridSize,
                  solved: List.generate(puzzle.rows, (row) => puzzle.isRowSolved(row)),
                  useSolvedColor: showCluesSolution,
                ),
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

          // "New Puzzle" and "Remove Puzzle" Buttons
          _buildNewPuzzleButton(context, puzzle.cols),
          const SizedBox(height: 10),
          _buildRemovePuzzleButton(context, puzzle.puzzleId),
          const SizedBox(height: 10),

          // Show "You Won!" and Save Button if the game is completed
          if (isWon) ...[
            _buildNextPuzzleButton(context),
            const SizedBox(height: 10),
            CongratulationsWidget(
              message: pointsAwarded != null && pointsAwarded > 0
                  ? "+$pointsAwarded points earned!"
                  : "",
            ),
            SavePuzzleWidget(puzzle: puzzle)
          ],
        ],
      ),
    )
    );
  }

  Widget _buildPowerupRow(BuildContext context) {
    final gameState = context.watch<GameBloc>().state;
    final showCluesAlreadyUsed =
        gameState is GameLoaded && gameState.showCluesSolution;
    final showSolutionIsActive =
        gameState is GameLoaded && gameState.showSolution;

    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, shopState) {
        if (shopState is! ShopLoaded) return const SizedBox();
        final counts = shopState.itemCounts;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButtonWithBadge(
              icon: Icons.visibility_rounded,
              count: counts['solved_state_5s'] ?? 0,
              color: showSolutionIsActive ? Colors.grey : Colors.deepPurple,
              onPressed: (counts['solved_state_5s'] ?? 0) > 0 && !showSolutionIsActive
                  ? () {
                context.read<GameBloc>().add(
                  UseSolvedState5sPowerup(
                    onConsumed: () => context.read<ShopBloc>().add(LoadShop()),
                  ),
                );
              }
                  : null,
              countdownSeconds: showSolutionIsActive ? 5 : null,
            ),

            const SizedBox(width: 8),

            IconButtonWithBadge(
              icon: Icons.lightbulb_circle,
              count: counts['show_clues'] ?? 0,
              color: showCluesAlreadyUsed ? Colors.grey : Colors.teal,
              onPressed: (counts['show_clues'] ?? 0) > 0 && !showCluesAlreadyUsed
                  ? () {
                context.read<GameBloc>().add(
                  UseShowCluesPowerup(
                    onConsumed: () => context.read<ShopBloc>().add(LoadShop()),
                  ),
                );
              }
                  : null,
            ),
          ],
        );
      },
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
          child: const Text("Generate New Puzzle"),
        ),
      ],
    );
  }

  /// "Remove Puzzle" button to delete the current puzzle
  Widget _buildRemovePuzzleButton(BuildContext context, String puzzleId) {
    return ElevatedButton(
      style: AppButtonStyles.redButtonStyle,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => ConfirmationDialogWidget(
            title: "Remove Puzzle",
            content: "Are you sure you want to remove this puzzle? This action cannot be undone.",
            onConfirm: () {
              context.read<ProviderBloc>().add(RemovePuzzle(puzzleId: puzzleId));
              Navigator.pop(context);
            },
          ),
        );
      },
      child: const Text("Remove Puzzle"),
    );
  }

  /// "Next Puzzle" button that triggers fetching of the next uncompleted puzzle
  Widget _buildNextPuzzleButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<ProviderBloc>().add(GetNextUncompletedPuzzle(fromHome: false));
      },
      child: const Text("Next Puzzle"),
    );
  }
}
