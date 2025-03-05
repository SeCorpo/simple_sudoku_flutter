import 'package:flutter/material.dart';
import '../../models/puzzle_model.dart';
import '../widgets/cell_widget.dart';

class GameGrid extends StatelessWidget {
  final PuzzleModel puzzle;
  final Function(int, int) onCellTap;
  final double gridSize;
  final bool showSolution;

  const GameGrid({
    super.key,
    required this.puzzle,
    required this.onCellTap,
    required this.gridSize,
    required this.showSolution,
  });

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

        return CellWidget(
          cell: puzzle.grid[row][col],
          gridSize: gridSize,
          onTap: () => onCellTap(row, col),
          showSolution: showSolution,
        );
      },
    );
  }
}
