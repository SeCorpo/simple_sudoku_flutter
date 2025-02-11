part of 'provider_bloc.dart';

@immutable
abstract class ProviderEvent {}

class LoadSavedPuzzles extends ProviderEvent {}

class SavePuzzle extends ProviderEvent {
  final PuzzleModel puzzle;
  SavePuzzle({required this.puzzle});
}
