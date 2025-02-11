part of 'game_bloc.dart';

@immutable
sealed class GameEvent {}

class GenerateNewPuzzle extends GameEvent {
  final int size;
  GenerateNewPuzzle({required this.size});
}

class StartGameWithPuzzle extends GameEvent {
  final PuzzleModel puzzle;
  StartGameWithPuzzle({required this.puzzle});
}

class ToggleSolution extends GameEvent {}

class ToggleCell extends GameEvent {
  final int row;
  final int col;
  ToggleCell({required this.row, required this.col});
}
