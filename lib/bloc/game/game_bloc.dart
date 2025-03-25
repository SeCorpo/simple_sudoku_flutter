import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../models/puzzle_model.dart';
import '../../services/puzzle_service.dart';
import '../../services/shop_service.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final PuzzleService _puzzleService;
  final ShopService _shopService;

  GameBloc(this._puzzleService, this._shopService) : super(GameInitial(defaultPuzzleSize: 5)) {
    on<GenerateNewPuzzle>(_onGenerateNewPuzzle);
    on<StartGameWithPuzzle>(_onStartGameWithPuzzle);
    on<ToggleSolution>(_onToggleSolution);
    on<ToggleCell>(_onToggleCell);
    on<GameWonEvent>(_onGameWon);
    on<ToggleCluesSolution>(_onToggleCluesSolution);
    on<UseShowCluesPowerup>(_onUseShowCluesPowerup);
    on<UseSolvedState5sPowerup>(_onUseSolvedState5sPowerup);
  }

  void _onGenerateNewPuzzle(GenerateNewPuzzle event, Emitter<GameState> emit) {
    final puzzle = _puzzleService.generateRandomPuzzle(size: event.size);
    emit(GameLoaded(puzzle: puzzle, showSolution: false, showCluesSolution: false));
  }

  void _onStartGameWithPuzzle(StartGameWithPuzzle event, Emitter<GameState> emit) {
    emit(GameLoaded(puzzle: event.puzzle, showSolution: false, showCluesSolution: false));
  }

  void _onToggleSolution(ToggleSolution event, Emitter<GameState> emit) {
    if (state is GameLoaded) {
      final currentState = state as GameLoaded;
      emit(GameLoaded(
          puzzle: currentState.puzzle,
          showSolution: !currentState.showSolution,
          showCluesSolution: currentState.showCluesSolution));
    }
  }

  void _onToggleCell(ToggleCell event, Emitter<GameState> emit) {
    if (state is GameLoaded) {
      final currentState = state as GameLoaded;
      currentState.puzzle.grid[event.row][event.col].toggle();

      if (currentState.puzzle.isSolved()) {
        add(GameWonEvent(puzzle: currentState.puzzle));
      } else {
        emit(GameLoaded(
          puzzle: currentState.puzzle,
          showSolution: currentState.showSolution,
          showCluesSolution: currentState.showCluesSolution,));
      }
    }
  }
  void _onGameWon(GameWonEvent event, Emitter<GameState> emit) async {
    final puzzle = event.puzzle;
    int points = 0;

    // Award points is puzzle is won, for buying powerups
    final multiplier = switch (puzzle.difficulty) {
      PuzzleDifficulty.float => 0.0,
      PuzzleDifficulty.easy => 0.2,
      PuzzleDifficulty.medium => 0.5,
      PuzzleDifficulty.hard => 1.0,
      PuzzleDifficulty.expert => 3.0,
      PuzzleDifficulty.impossible => 5.0,
      };

    points = max(1, (multiplier * puzzle.starRating).round());
    await _shopService.addPoints(points);

    emit(GameWon(puzzle: event.puzzle, pointsAwarded: points));
  }

  void _onToggleCluesSolution(ToggleCluesSolution event, Emitter<GameState> emit) {
    if (state is GameLoaded) {
      final currentState = state as GameLoaded;
      emit(GameLoaded(
        puzzle: currentState.puzzle,
        showSolution: currentState.showSolution,
        showCluesSolution: !currentState.showCluesSolution,
      ));
    }
  }

  void _onUseShowCluesPowerup(UseShowCluesPowerup event, Emitter<GameState> emit) async {
    final current = state;
    if (current is! GameLoaded) return;

    final itemKey = 'show_clues';
    final itemCount = await _shopService.getItemCount(itemKey);
    if (itemCount <= 0) return;

    await _shopService.consumeItem(itemKey);
    event.onConsumed?.call();

    emit(GameLoaded(
      puzzle: current.puzzle,
      showSolution: current.showSolution,
      showCluesSolution: true,
    ));
  }

  void _onUseSolvedState5sPowerup(UseSolvedState5sPowerup event, Emitter<GameState> emit) async {
    final current = state;
    if (current is! GameLoaded) return;

    final itemKey = 'solved_state_5s';
    final itemCount = await _shopService.getItemCount(itemKey);
    if (itemCount <= 0) return;

    emit(GameLoaded(
      puzzle: current.puzzle,
      showSolution: true,
      showCluesSolution: current.showCluesSolution,
    ));

    await _shopService.consumeItem(itemKey);
    event.onConsumed?.call();

    await Future.delayed(const Duration(seconds: 5));

    if (state is GameLoaded) {
      final updated = state as GameLoaded;
      emit(GameLoaded(
        puzzle: updated.puzzle,
        showSolution: false,
        showCluesSolution: updated.showCluesSolution,
      ));
    }
  }

}
