import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

class ClueNumbersWidget extends StatelessWidget {
  final List<List<int>> clues;
  final bool isRow;
  final double gridSize;
  final List<bool> solved;
  final bool useSolvedColor;

  const ClueNumbersWidget({
    super.key,
    required this.clues,
    required this.isRow,
    required this.gridSize,
    required this.solved,
    required this.useSolvedColor,
  });

  @override
  Widget build(BuildContext context) {
    final puzzleTheme = AppTheme.puzzleTheme(context);

    int maxNumbers = clues.fold(1, (max, clue) => clue.length > max ? clue.length : max);

    return isRow
        ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(clues.length, (index) {
        Color textColor = (solved[index] && useSolvedColor)
            ? puzzleTheme.solvedClueColor
            : puzzleTheme.clueTextColor;

        return Container(
          width: gridSize * 2,
          height: gridSize,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: gridSize * 0.2),
          child: FittedBox(
            alignment: Alignment.centerRight,
            child: Text(
              clues[index].join(" "),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: gridSize * 0.4,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        );
      }),
    )
        : Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(clues.length, (index) {
        Color textColor = (solved[index] && useSolvedColor)
            ? puzzleTheme.solvedClueColor
            : puzzleTheme.clueTextColor;

        return Container(
          width: gridSize,
          height: gridSize * maxNumbers,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(vertical: gridSize * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: clues[index]
                .map((clueNumber) => Flexible(
              child: Text(
                "$clueNumber",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: gridSize * 0.4,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ))
                .toList(),
          ),
        );
      }),
    );
  }
}
