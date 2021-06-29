import 'package:flutter/cupertino.dart';

class ClockModel extends ChangeNotifier {
  ClockModel({int? initialTime, bool countDown = false}) {
    if (countDown && initialTime == null)
      assert(countDown == true && initialTime != null,
          'To count down, an initial time must be provided');
    _countDown = countDown;

    /// if counting down, initial time must not be null
    /// set time left to initial time
    if (countDown && initialTime != null) {
      _initialTime = initialTime;
    }
    if (_initialTime != null) {
      _timeLeft = _initialTime!;
    } else
      _timeLeft = 0;
  }

  /// if counting down or up, default to down
  late bool _countDown;

  /// Only for countdown mode
  /// initial time a player has
  int? _initialTime;

  /// time left until 0
  late int _timeLeft;

  /// time elapsed, only count up mode
  int _timeElapsed = 0;

  /// controls start/stop
  bool _controller = true;

  int get timeElapsed => _timeElapsed;
  bool get timeMode => _countDown;

  Stream<int> runClock() async* {
    if (_countDown) {
      while (_controller) {
        if (_timeLeft == 0) {
          break;
        }
        await Future.delayed(
          Duration(milliseconds: 10),
        );
        yield _timeLeft--;
      }
    } else {
      while (_controller) {
        await Future.delayed(
          Duration(milliseconds: 10),
        );
//        print('_timeElapsed: $_timeElapsed');
        yield _timeElapsed++;
      }
    }
  }

  static void formatTime(int centiSec) {}

  startTimer() {
    _controller = true;
    notifyListeners();
  }

  stopTimer() {
    _controller = false;
    notifyListeners();
  }

  resetTimer() {
    if (_countDown) {
      _timeLeft = _initialTime!;
    }
    _timeElapsed = 0;
    notifyListeners();
  }
}
