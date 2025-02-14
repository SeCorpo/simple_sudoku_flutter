import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/provider/provider_bloc.dart';
import '../../models/puzzle_model.dart';

class SavePuzzleWidget extends StatelessWidget {
  final PuzzleModel puzzle;

  const SavePuzzleWidget({Key? key, required this.puzzle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PuzzleDifficulty? selectedDifficulty;
    int? selectedStarRating;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButton<PuzzleDifficulty>(
              value: selectedDifficulty,
              hint: const Text("Select Difficulty"),
              onChanged: (difficulty) {
                setState(() {
                  selectedDifficulty = difficulty;
                });
              },
              items: PuzzleDifficulty.values.map((difficulty) {
                return DropdownMenuItem<PuzzleDifficulty>(
                  value: difficulty,
                  child: Text(difficulty.name.toUpperCase()),
                );
              }).toList(),
            ),
            DropdownButton<int>(
              value: selectedStarRating,
              hint: const Text("Select Star Rating"),
              onChanged: (rating) {
                setState(() {
                  selectedStarRating = rating;
                });
              },
              items: List.generate(5, (index) => index + 1).map((rating) {
                return DropdownMenuItem<int>(
                  value: rating,
                  child: Text("$rating Stars"),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: (selectedDifficulty != null && selectedStarRating != null)
                  ? () {
                final categorizedPuzzle = puzzle.copyWith(
                  difficulty: selectedDifficulty!,
                  starRating: selectedStarRating!,
                );
                context.read<ProviderBloc>().add(SavePuzzle(puzzle: categorizedPuzzle));
              }
                  : null,
              child: const Text("Save Puzzle"),
            ),
          ],
        );
      },
    );
  }
}
