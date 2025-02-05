import 'package:flutter/material.dart';

class ClueNumbers extends StatelessWidget {
  final List<List<int>> clues;
  final bool isRow;
  final double gridSize;

  const ClueNumbers({Key? key, required this.clues, required this.isRow, required this.gridSize})
      : super(key: key);

  /// **Groups consecutive filled cells into numbers**
  static List<int> groupClueNumbers(List<bool> cells) {
    List<int> groupedNumbers = [];
    int count = 0;

    for (bool isFilled in cells) {
      if (isFilled) {
        count++;
      } else if (count > 0) {
        groupedNumbers.add(count);
        count = 0;
      }
    }

    if (count > 0) groupedNumbers.add(count); // Add last group if exists

    return groupedNumbers.isEmpty ? [0] : groupedNumbers; // Ensure at least [0]
  }

  @override
  Widget build(BuildContext context) {
    return isRow
        ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: clues.map((clue) {
        return Container(
          width: gridSize * 1.8, // Adjust width for better alignment
          height: gridSize,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: gridSize * 0.2),
          child: Text(
            clue.join(" "), // Display grouped numbers
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: gridSize * 0.5, fontWeight: FontWeight.bold),
          ),
        );
      }).toList(),
    )
        : Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: clues.map((clue) {
        return Container(
          width: gridSize,
          height: gridSize * 1.8, // Adjust height for alignment
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(vertical: gridSize * 0.2),
          child: Text(
            clue.join("\n"), // Show numbers in separate lines
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: gridSize * 0.5, fontWeight: FontWeight.bold),
          ),
        );
      }).toList(),
    );
  }
}
