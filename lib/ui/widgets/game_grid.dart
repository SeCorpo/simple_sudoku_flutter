import 'package:flutter/material.dart';
import 'cell_widget.dart';
import '../../models/puzzle_model.dart';

class GameGrid extends StatelessWidget {
  final PuzzleModel puzzle;
  final Function(int, int) onCellTap;
  final double gridSize;

  const GameGrid({Key? key, required this.puzzle, required this.onCellTap, required this.gridSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(), // Prevents grid from scrolling separately
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: puzzle.cols,
      ),
      itemCount: puzzle.rows * puzzle.cols,
      itemBuilder: (context, index) {
        int row = index ~/ puzzle.cols;
        int col = index % puzzle.cols;
        return CellWidget(
          cell: puzzle.grid[row][col],
          onTap: () => onCellTap(row, col),
          gridSize: gridSize,
        );
      },
    );
  }
}
