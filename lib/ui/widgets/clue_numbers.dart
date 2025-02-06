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
    int maxNumbers = clues.fold(1, (max, clue) => clue.length > max ? clue.length : max);

    return isRow
        ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(clues.length, (index) {
        return Container(
          width: gridSize * 2, // Ensure row clues have enough width
          height: gridSize, // Match row height
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: gridSize * 0.2),
          child: FittedBox(
            alignment: Alignment.centerRight,
            child: Text(
              clues[index].join(" "), // Display grouped numbers inline
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: gridSize * 0.4, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }),
    )
        : Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(clues.length, (index) {
        return Container(
          width: gridSize, // Ensure column clues have enough width
          height: gridSize * maxNumbers, // Adjust height dynamically
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(vertical: gridSize * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: clues[index]
                .map((num) => Flexible(
              child: Text(
                "$num",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: gridSize * 0.4, fontWeight: FontWeight.bold),
              ),
            ))
                .toList(),
          ),
        );
      }),
    );
  }
}
