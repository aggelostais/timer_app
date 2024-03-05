part of 'timer_bloc.dart';

// sealed class is a class that can only be extended by classes declared in the same file
sealed class TimerState {
  const TimerState(this.duration);
  final int duration;

  @override
  List<Object> get props => [duration];
}

// TimerInitial: ready to start counting down from the specified duration.
final class TimerInitial extends TimerState {
  const TimerInitial(super.duration);

  @override
  String toString() => 'TimerInitial { duration: $duration }';
}

// TimerRunPause: paused at some remaining duration.
final class TimerRunPause extends TimerState {
  const TimerRunPause(super.duration);

  @override
  String toString() => 'TimerRunPause { duration: $duration }';
}

// TimerRunInProgress: actively counting down from the specified duration.
final class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(super.duration);

  @override
  String toString() => 'TimerRunInProgress { duration: $duration }';
}

// TimerRunComplete: completed with a remaining duration of 0.
final class TimerRunComplete extends TimerState {
  const TimerRunComplete() : super(0);
}