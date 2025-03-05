import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_sudoku_flutter/core/utils/string_utils.dart';
import 'package:simple_sudoku_flutter/ui/screens/settings_screen.dart';
import '../../bloc/game/game_bloc.dart';
import '../../bloc/provider/provider_bloc.dart';
import '../widgets/snackbar_widget.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProviderBloc>().add(LoadSavedPuzzles());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select a Puzzle"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<GameBloc>().add(GenerateNewPuzzle(size: 5));

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              },
              child: const Text("Generate New Puzzle"),
            ),
            const SizedBox(height: 20),

            BlocListener<ProviderBloc, ProviderState>(
              listener: (context, state) {
                if (state is NextPuzzleFromHome) {
                  context.read<GameBloc>().add(StartGameWithPuzzle(puzzle: state.puzzle));
                  context.read<ProviderBloc>().add(LoadSavedPuzzles());

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GameScreen()),
                  );
                } else if (state is NextPuzzleNotFoundError && state.fromHome) {
                  SnackBarWidget.show(context, state.error, isError: true);
                }
              },
              child: ElevatedButton(
                onPressed: () {
                  context.read<ProviderBloc>().add(GetNextUncompletedPuzzle(fromHome: true));
                },
                child: const Text("Next Puzzle"),
              ),
            ),
            const SizedBox(height: 20),

            BlocBuilder<ProviderBloc, ProviderState>(
              builder: (context, state) {
                if (state is LoadingSavedPuzzles) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is NoSavedPuzzles) {
                  return const Center(child: Text("No saved puzzles found"));
                }
                if (state is SavedPuzzlesLoaded) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.puzzles.length,
                      itemBuilder: (context, index) {
                        final puzzle = state.puzzles[index];
                        return ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Puzzle ${index + 1} - ${puzzle.rows} ${StringUtils.capitalize(puzzle.difficulty.name)}"),
                              Row(
                                children: [
                                  ...List.generate(
                                    puzzle.starRating,
                                        (index) => const Icon(Icons.star, color: Colors.amber, size: 20),
                                  ),
                                  if (puzzle.completed)
                                    const Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Icon(Icons.check_circle, color: Colors.green, size: 22),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.play_arrow),
                          onTap: () {
                            context.read<GameBloc>().add(StartGameWithPuzzle(puzzle: puzzle));

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const GameScreen()),
                            );
                          },
                        );
                      },
                    ),
                  );
                }
                return const Center(child: Text("Error loading puzzles"));
              },
            ),
          ],
        ),
      ),
    );
  }
}
