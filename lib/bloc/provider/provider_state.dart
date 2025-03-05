part of 'provider_bloc.dart';

@immutable
abstract class ProviderState {}

class ProviderInitial extends ProviderState {}

class LoadingSavedPuzzles extends ProviderState {}

class NoSavedPuzzles extends ProviderState {}

class SavedPuzzlesLoaded extends ProviderState {
  final List<PuzzleModel> puzzles;
  SavedPuzzlesLoaded({required this.puzzles});
}

class PuzzleSaved extends ProviderState {}

class SavePuzzleError extends ProviderState {
  final String error;
  SavePuzzleError({required this.error});
}

class MarkPuzzleCompletedError extends ProviderState {
  final String error;
  MarkPuzzleCompletedError({required this.error});
}

/// State for when Next Puzzle is fetched from HomeScreen
class NextPuzzleFromHome extends ProviderState {
  final PuzzleModel puzzle;
  NextPuzzleFromHome({required this.puzzle});
}

/// State for when Next Puzzle is fetched from GameScreen
class NextPuzzleFromGame extends ProviderState {
  final PuzzleModel puzzle;
  NextPuzzleFromGame({required this.puzzle});
}

class NextPuzzleNotFoundError extends ProviderState {
  final String error;
  final bool fromHome;  // True if error originated from HomeScreen

  NextPuzzleNotFoundError({required this.error, required this.fromHome});
}
