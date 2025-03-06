part of 'game_bloc.dart';

@immutable
sealed class GameState {}

class GameInitial extends GameState {
  final int defaultPuzzleSize;

  GameInitial({required this.defaultPuzzleSize});
}

class GameLoaded extends GameState {
  final PuzzleModel puzzle;
  final bool showSolution;
  final bool showCluesSolution;

  GameLoaded({required this.puzzle, this.showSolution = false, this.showCluesSolution = false});
}

class GameWon extends GameState {
  final PuzzleModel puzzle;

  GameWon({required this.puzzle});
}
