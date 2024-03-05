import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:timer_app/ticker.dart';
part 'timer_event.dart';
part 'timer_state.dart';

// Bloc: Takes a stream of TimerEvents as input and
// transforms them into a stream of TimerStates as output.
class TimerBloc extends Bloc<TimerEvent, TimerState> {
  // TimerBloc: Constructor
  // Create TimerBloc, take a Ticker as a parameter and initialize the state with TimerInitial.
  // Listen to TimerStarted, TimerPaused, and _TimerTicked events
  // and call the corresponding event handlers.
  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(const TimerInitial(_duration)) {
    on<TimerStarted>(_onStarted);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
    on<_TimerTicked>(_onTicked);
  }

  final Ticker _ticker;
  static const int _duration = 60; // initial duration
  StreamSubscription<int>?
      _tickerSubscription; // StreamSubscription: A subscription on a Stream.

  // we cancel the subscription when the bloc is closed
  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  // TimerStarted Event Handler: If the TimerBloc receives a TimerStarted event,
  // it pushes a TimerRunInProgress state with the start duration.
  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(TimerRunInProgress(event.duration));
    // If was already an open _tickerSubscription (previous timer) cancel it
    // to deallocate the memory to not have multiple subscriptions running on parallel.
    _tickerSubscription?.cancel();

    // Listen to the _ticker.tick stream and
    // on every tick add a _TimerTicked event with the remaining duration.
    _tickerSubscription = _ticker
        .tick(ticks: event.duration)
        .listen((duration) => add(_TimerTicked(duration: duration)));
  }

  // If the state of our TimerBloc is TimerRunInProgress, pause the _tickerSubscription
  // and stop listening to the stream of ticks.
  // Then, we emit a TimerRunPause state with the current duration.
  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(state.duration));
    }
  }

  // If the state of our TimerBloc is TimerRunPause, resume the _tickerSubscription
  // and start listening to the stream of ticks again.
  void _onResumed(TimerResumed resume, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.duration));
    }
  }

  // If the TimerBloc receives a TimerReset event, we cancel the _tickerSubscription
  // and push a TimerInitial state with the initial duration.
  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(const TimerInitial(_duration));
  }

  // Every time a _TimerTicked event is received, if the tick’s duration is greater than 0,
  // we need to push an updated TimerRunInProgress state with the new duration.
  // Otherwise, if the tick’s duration is 0, our timer has ended and
  // we need to push a TimerRunComplete state.
  void _onTicked(_TimerTicked event, Emitter<TimerState> emit) {
    emit(
      event.duration > 0
          ? TimerRunInProgress(event.duration)
          : const TimerRunComplete(),
    );
  }
}
