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
