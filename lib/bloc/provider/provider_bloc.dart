import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../services/save_service.dart';
import '../../models/puzzle_model.dart';

part 'provider_event.dart';
part 'provider_state.dart';

class ProviderBloc extends Bloc<ProviderEvent, ProviderState> {
  final SaveService _saveService;

  ProviderBloc(this._saveService) : super(ProviderInitial()) {
    on<LoadSavedPuzzles>(_onLoadSavedPuzzles);
    on<SavePuzzle>(_onSavePuzzle);
  }

  /// Load saved puzzles
  void _onLoadSavedPuzzles(LoadSavedPuzzles event, Emitter<ProviderState> emit) async {
    emit(LoadingSavedPuzzles());
    final savedPuzzles = await _saveService.loadPuzzles();

    if (savedPuzzles.isNotEmpty) {
      emit(SavedPuzzlesLoaded(puzzles: savedPuzzles));
    } else {
      emit(NoSavedPuzzles());
    }
  }

  /// Save a solved puzzle and refresh the list
  void _onSavePuzzle(SavePuzzle event, Emitter<ProviderState> emit) async {
    try {
      await _saveService.savePuzzle(event.puzzle);
      emit(PuzzleSaved());

      // Reload saved puzzles after saving
      add(LoadSavedPuzzles());
    } catch (e) {
      emit(SavePuzzleError(error: "Failed to save puzzle: $e"));
    }
  }
}
