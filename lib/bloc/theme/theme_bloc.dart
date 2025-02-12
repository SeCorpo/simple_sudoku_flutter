import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(themeMode: ThemeMode.system)) {
    on<InitializeTheme>(_onInitializeTheme);
    on<ToggleTheme>(_onToggleTheme);
    on<SetTheme>(_onSetTheme);

    // Dispatch event to load theme on startup
    add(InitializeTheme());
  }

  /// Handle theme initialization from SharedPreferences
  Future<void> _onInitializeTheme(InitializeTheme event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('themeMode') ?? ThemeMode.system.index;
    emit(ThemeState(themeMode: ThemeMode.values[index]));
  }

  void _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) async {
    ThemeMode newTheme;

    // Cycle through Light -> Dark -> System
    if (state.themeMode == ThemeMode.light) {
      newTheme = ThemeMode.dark;
    } else if (state.themeMode == ThemeMode.dark) {
      newTheme = ThemeMode.system;
    } else {
      newTheme = ThemeMode.light;
    }

    emit(ThemeState(themeMode: newTheme));
    _saveTheme(newTheme); // Save the new theme
  }

  void _onSetTheme(SetTheme event, Emitter<ThemeState> emit) {
    emit(ThemeState(themeMode: event.themeMode));
    _saveTheme(event.themeMode);
  }

  /// Save the selected theme to SharedPreferences
  Future<void> _saveTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeMode', themeMode.index);
  }
}
