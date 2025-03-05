import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../models/puzzle_model.dart';
import '../../services/puzzle_service.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final PuzzleService _puzzleService;

  GameBloc(this._puzzleService) : super(GameInitial(defaultPuzzleSize: 5)) {
    on<GenerateNewPuzzle>(_onGenerateNewPuzzle);
    on<StartGameWithPuzzle>(_onStartGameWithPuzzle);
    on<ToggleSolution>(_onToggleSolution);
    on<ToggleCell>(_onToggleCell);
    on<GameWonEvent>(_onGameWon);
  }

  void _onGenerateNewPuzzle(GenerateNewPuzzle event, Emitter<GameState> emit) {
    final puzzle = _puzzleService.generateRandomPuzzle(size: event.size);
    emit(GameLoaded(puzzle: puzzle, showSolution: false));
  }

  void _onStartGameWithPuzzle(StartGameWithPuzzle event, Emitter<GameState> emit) {
    emit(GameLoaded(puzzle: event.puzzle, showSolution: false));
  }

  void _onToggleSolution(ToggleSolution event, Emitter<GameState> emit) {
    if (state is GameLoaded) {
      final currentState = state as GameLoaded;
      emit(GameLoaded(puzzle: currentState.puzzle, showSolution: !currentState.showSolution));
    }
  }

  void _onToggleCell(ToggleCell event, Emitter<GameState> emit) {
    if (state is GameLoaded) {
      final currentState = state as GameLoaded;
      currentState.puzzle.grid[event.row][event.col].toggle();

      if (currentState.puzzle.isSolved()) {
        add(GameWonEvent(puzzle: currentState.puzzle));
      } else {
        emit(GameLoaded(puzzle: currentState.puzzle, showSolution: currentState.showSolution));
      }
    }
  }
  void _onGameWon(GameWonEvent event, Emitter<GameState> emit) {
    emit(GameWon(puzzle: event.puzzle));
  }
}
