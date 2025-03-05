part of 'provider_bloc.dart';

@immutable
abstract class ProviderEvent {}

class LoadSavedPuzzles extends ProviderEvent {}

class SavePuzzle extends ProviderEvent {
  final PuzzleModel puzzle;
  SavePuzzle({required this.puzzle});
}

class MarkPuzzleCompleted extends ProviderEvent {
  final String puzzleId;
  MarkPuzzleCompleted({required this.puzzleId});
}

class ResetProgress extends ProviderEvent {}

class GetNextUncompletedPuzzle extends ProviderEvent {}