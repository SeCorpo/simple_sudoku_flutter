import 'package:flutter/material.dart';
import '../../models/cell_model.dart';

class CellWidget extends StatelessWidget {
  final CellModel cell;
  final VoidCallback onTap;
  final double gridSize;

  const CellWidget({Key? key, required this.cell, required this.onTap, required this.gridSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: gridSize,
          height: gridSize,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: cell.isFilled
                ? Colors.black
                : cell.isMarked
                ? Colors.red
                : Colors.white,
            border: Border.all(color: Colors.black),
          ),
          child: cell.isMarked
              ? Icon(Icons.close, color: Colors.white, size: gridSize * 0.6)
              : null,
        ),
      ),
    );
  }
}
