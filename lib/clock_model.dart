import 'package:flutter/cupertino.dart';

class ClockModel extends ChangeNotifier {
  ClockModel({int initialTime = 2000}) {
    _initialTime = initialTime;
    _timeLeft = _initialTime;
  }

  /// if counting down or up, default to down
  bool _timeMode = false;

  /// Only for countdown mode
  /// initial time a player has
  late int _initialTime;

  /// time left until 0
  late int _timeLeft;

  /// time elapsed, only count up mode
  int _timeElapsed = 0;

  /// controls start/stop
  bool _controller = true;

  int get timeElapsed => _timeElapsed;
  bool get timeMode => _timeMode;

  Stream<int> runClock() async* {
    if (_timeMode)
      while (_controller) {
        await Future.delayed(
          Duration(milliseconds: 10),
        );
        print('_timeElapsed: $_timeElapsed');
        yield _timeElapsed++;
      }
    else {
      while (_controller) {
        if (_timeLeft == 0) break;
        await Future.delayed(
          Duration(milliseconds: 10),
        );
        yield _timeLeft--;
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
    _timeLeft = _initialTime;
    _timeElapsed = 0;
    notifyListeners();
  }
}
