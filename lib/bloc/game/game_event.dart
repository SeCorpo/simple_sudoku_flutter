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

class GameWonEvent extends GameEvent {
  final PuzzleModel puzzle;

  GameWonEvent({required this.puzzle});
}

class ToggleCluesSolution extends GameEvent {}

class UseShowCluesPowerup extends GameEvent {
  final void Function()? onConsumed;

  UseShowCluesPowerup({this.onConsumed});
}

class UseSolvedState5sPowerup extends GameEvent {
  final void Function()? onConsumed;

  UseSolvedState5sPowerup({this.onConsumed});
}
