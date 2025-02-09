part of 'game_bloc.dart';

@immutable
sealed class GameState {}

class GameInitial extends GameState {}

class GameLoaded extends GameState {
  final PuzzleModel puzzle;
  final bool showSolution;

  GameLoaded({required this.puzzle, this.showSolution = false});
}

class GameWon extends GameState {
  final PuzzleModel puzzle;

  GameWon({required this.puzzle});
}
