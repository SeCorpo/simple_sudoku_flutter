import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../core/custom_exceptions.dart';
import '../../services/save_service.dart';
import '../../models/puzzle_model.dart';

part 'provider_event.dart';
part 'provider_state.dart';

class ProviderBloc extends Bloc<ProviderEvent, ProviderState> {
  final SaveService _saveService;
  List<PuzzleModel> _puzzles = [];

  ProviderBloc(this._saveService) : super(ProviderInitial()) {
    on<LoadSavedPuzzles>(_onLoadSavedPuzzles);
    on<SavePuzzle>(_onSavePuzzle);
    on<MarkPuzzleCompleted>(_onMarkPuzzleCompleted);
    on<ResetProgress>(_onResetProgress);
    on<GetNextUncompletedPuzzle>(_onGetNextUncompletedPuzzle);
    on<RemovePuzzle>(_onRemovePuzzle);
  }

  /// Load saved puzzles and sort them by difficulty and star rating
  void _onLoadSavedPuzzles(LoadSavedPuzzles event, Emitter<ProviderState> emit) async {
    emit(LoadingSavedPuzzles());
    try {
      final savedPuzzles = await _saveService.loadPuzzles();

      if (savedPuzzles.isNotEmpty) {
        savedPuzzles.sort((a, b) {
          int difficultyComparison = a.difficulty.index.compareTo(b.difficulty.index);
          if (difficultyComparison != 0) {
            return difficultyComparison;
          }
          return a.starRating.compareTo(b.starRating);
        });

        _puzzles = savedPuzzles;
        emit(SavedPuzzlesLoaded(puzzles: _puzzles));
      } else {
        _puzzles = [];
        emit(NoSavedPuzzles());
      }
    } catch (e) {
      emit(SavePuzzleError(error: e.toString()));
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
      emit(SavePuzzleError(error: e.toString()));
    }
  }

  void _onMarkPuzzleCompleted(MarkPuzzleCompleted event, Emitter<ProviderState> emit) async {
    try {
      await _saveService.markPuzzleAsCompleted(event.puzzleId);
      add(LoadSavedPuzzles());
    } catch (e) {
      emit(MarkPuzzleCompletedError(error: e.toString()));
    }
  }

  void _onResetProgress(ResetProgress event, Emitter<ProviderState> emit) async {
    try {
      await _saveService.resetProgress();
      add(LoadSavedPuzzles());
    } catch (e) {
      emit(SavePuzzleError(error: e.toString()));
    }
  }

  /// Get the next uncompleted puzzle from the sorted list
  void _onGetNextUncompletedPuzzle(GetNextUncompletedPuzzle event, Emitter<ProviderState> emit) async {
    try {
      final nextPuzzle = _puzzles.firstWhere(
            (puzzle) => !puzzle.completed,
        orElse: () => throw PuzzleNotFoundException(),
      );

      emit(
        event.fromHome
            ? NextPuzzleFromHome(puzzle: nextPuzzle)
            : NextPuzzleFromGame(puzzle: nextPuzzle),
      );
    } catch (e) {
      emit(NextPuzzleNotFoundError(error: e.toString(), fromHome: event.fromHome));
    }
  }

  void _onRemovePuzzle(RemovePuzzle event, Emitter<ProviderState> emit) async {
    try {
      await _saveService.removePuzzle(event.puzzleId);
      emit(PuzzleRemoved(puzzleId: event.puzzleId));

      // Reload saved puzzles after removal
      add(LoadSavedPuzzles());
    } catch (e) {
      emit(RemovePuzzleError(error: e.toString()));
    }
  }
}
