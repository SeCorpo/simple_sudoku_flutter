import 'package:flutter/material.dart';
import '../../models/cell_model.dart';
import '../../core/theme/theme.dart';

class CellWidget extends StatelessWidget {
  final CellModel cell;
  final VoidCallback onTap;
  final double gridSize;
  final bool showSolution;

  const CellWidget({
    super.key,
    required this.cell,
    required this.onTap,
    required this.gridSize,
    required this.showSolution,
  });

  @override
  Widget build(BuildContext context) {
    final puzzleTheme = AppTheme.puzzleTheme(context);

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: gridSize,
          height: gridSize,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: showSolution
                ? (cell.isCorrect ? puzzleTheme.solutionCorrectColor : puzzleTheme.solutionIncorrectColor)
                : (cell.isFilled ? puzzleTheme.cellSelectedColor : puzzleTheme.cellColor),
            border: Border.all(color: puzzleTheme.gridLineColor),
          ),
        ),
      ),
    );
  }
}
