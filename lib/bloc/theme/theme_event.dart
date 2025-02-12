part of 'theme_bloc.dart';

@immutable
abstract class ThemeEvent {}

class ToggleTheme extends ThemeEvent {}

class SetTheme extends ThemeEvent {
  final ThemeMode themeMode;
  SetTheme({required this.themeMode});
}
