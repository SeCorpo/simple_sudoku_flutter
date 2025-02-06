import 'package:flutter/material.dart';
import '../../models/puzzle_model.dart';

class GameGrid extends StatelessWidget {
  final PuzzleModel puzzle;
  final Function(int, int) onCellTap;
  final double gridSize;
  final bool showSolution;

  const GameGrid({
    Key? key,
    required this.puzzle,
    required this.onCellTap,
    required this.gridSize,
    required this.showSolution,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: puzzle.cols,
      ),
      itemCount: puzzle.rows * puzzle.cols,
      itemBuilder: (context, index) {
        int row = index ~/ puzzle.cols;
        int col = index % puzzle.cols;
        bool isCorrect = puzzle.grid[row][col].isCorrect;
        bool isFilled = puzzle.grid[row][col].isFilled;

        return GestureDetector(
          onTap: () => onCellTap(row, col),
          child: Container(
            margin: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: showSolution
                  ? (isCorrect ? Colors.green.withAlpha(128) : Colors.red.withAlpha(128)) // 50% opacity
                  : (isFilled ? Colors.black : Colors.white),
              border: Border.all(color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}
