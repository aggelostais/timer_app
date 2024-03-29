// Takes the number of ticks (seconds) we want and returns a stream 
// which emits the remaining seconds every second.
class Ticker {
  const Ticker();
  // why don't we use async* here?
  // The async* function is used to return a Stream.
  // The Stream.periodic method is used to create a Stream that emits events at a regular interval.
  Stream<int> tick({required int ticks}) {
    // duration: How often the tick should occur, function: What values should be emitted 
    // Input: 0,1,2,3,4
    // Output (10 ticks): 9,8,7,6,5,4,3,2,1,0
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }
}
