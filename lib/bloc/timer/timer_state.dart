part of 'timer_bloc.dart';

@immutable
sealed class TimerState {}

final class TimerInitial extends TimerState {
  final int duration;
  TimerInitial(this.duration);
}

final class TimerRunInProgress extends TimerState {
  final int duration;
  TimerRunInProgress(this.duration);
}

final class TimerPausedState extends TimerState {
  final int duration;
  TimerPausedState(this.duration);
}

final class TimerRunComplete extends TimerState {}
