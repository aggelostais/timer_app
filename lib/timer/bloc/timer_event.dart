part of 'timer_bloc.dart';

sealed class TimerEvent {
  const TimerEvent();
}

// Informs the TimerBloc that the timer should be started.
final class TimerStarted extends TimerEvent {
  const TimerStarted({required this.duration});
  final int duration;
}

// Informs the TimerBloc that the timer should be paused.
final class TimerPaused extends TimerEvent {
  const TimerPaused();
}

// Informs the TimerBloc that the timer should be resumed.
final class TimerResumed extends TimerEvent {
  const TimerResumed();
}

// Informs the TimerBloc that the timer should be reset.
class TimerReset extends TimerEvent {
  const TimerReset();
}

// Informs the TimerBloc that a tick has occurred and that it needs to update its state.
class _TimerTicked extends TimerEvent {
  const _TimerTicked({required this.duration});
  final int duration;
}