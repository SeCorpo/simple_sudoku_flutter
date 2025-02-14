import 'package:flutter/material.dart';

class PuzzleTheme {
  static const PuzzleTheme light = PuzzleTheme._(
    cellSelectedColor: Colors.black,
    cellColor: Colors.white,
    clueTextColor: Colors.black87,
    gridLineColor: Colors.black54,
    solutionCorrectColor: Colors.green,
    solutionIncorrectColor: Colors.red,
  );

  static const PuzzleTheme dark = PuzzleTheme._(
    cellSelectedColor: Colors.black,
    cellColor: Colors.grey,
    clueTextColor: Colors.white70,
    gridLineColor: Colors.white38,
    solutionCorrectColor: Colors.green,
    solutionIncorrectColor: Colors.red,
  );

  final Color cellSelectedColor;
  final Color cellColor;
  final Color clueTextColor;
  final Color gridLineColor;
  final Color solutionCorrectColor;
  final Color solutionIncorrectColor;

  const PuzzleTheme._({
    required this.cellSelectedColor,
    required this.cellColor,
    required this.clueTextColor,
    required this.gridLineColor,
    required this.solutionCorrectColor,
    required this.solutionIncorrectColor,
  });
}