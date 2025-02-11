import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/game/game_bloc.dart';
import '../../services/puzzle_service.dart';
import '../../services/save_service.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select a Puzzle")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            ElevatedButton(
              onPressed: () {
                final puzzleService = context.read<PuzzleService>();
                final newPuzzle = puzzleService.generateRandomPuzzle(size: 7);

                context.read<GameBloc>().add(StartGameWithPuzzle(puzzle: newPuzzle));

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              },
              child: const Text("Generate New Puzzle"),
            ),
            const SizedBox(height: 20),

            FutureBuilder(
              future: context.read<SaveService>().loadPuzzles(),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading saved puzzles"));
                }
                final puzzles = snapshot.data ?? [];

                if (puzzles.isEmpty) {
                  return const Center(child: Text("No saved puzzles found"));
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: puzzles.length,
                    itemBuilder: (context, index) {
                      final puzzle = puzzles[index];
                      return ListTile(
                        title: Text("Puzzle ${index + 1}"),
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
