part of 'timer_bloc.dart';

@immutable
sealed class TimerEvent {}

final class TimerStarted extends TimerEvent {
  final int duration;
  TimerStarted(this.duration);
}

final class TimerPaused extends TimerEvent {}

final class TimerResumed extends TimerEvent {}

final class TimerReset extends TimerEvent {}

final class _TimerTicked extends TimerEvent {
  final int duration;
  _TimerTicked(this.duration);
}
