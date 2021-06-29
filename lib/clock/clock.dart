import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'clock_model.dart';

class ClockWidget extends StatefulWidget {
  ClockWidget({this.countDown = true, this.initialTime}) {
    if (countDown && initialTime == null) {
      assert(countDown == true && initialTime != null,
          'To count down, an initial time must be provided');
    }
  }

  final bool countDown;
  final Duration? initialTime;

  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  late final ClockModel clock;
  late int hours;
  late int mins;
  late int secs;
  late int centiSecs;

  /// if the clock is running or stop
  late bool state;

  void resetCountDown() {
    clock = ClockModel(countDown: widget.countDown);

    /// get correspondent value for each field
    hours = widget.initialTime!.inSeconds ~/ 3600;
    mins = (widget.initialTime!.inSeconds - (hours * 3600)) ~/ 60;
    secs = widget.initialTime!.inSeconds - (hours * 3600) - (mins * 60);
  }

  void resetCountUp() {
    clock = ClockModel(countDown: widget.countDown);
    hours = 0;
    mins = 0;
    secs = 0;
    centiSecs = 0;
  }

  @override
  void initState() {
    state = false;

    /// initialize fields

    /// counting down
    if (widget.countDown) {
      resetCountDown();
    }

    /// counting up
    else {
      resetCountUp();
    }

    /// add a listener to the clock stream to udpate h/m/s
    clock.addListener(() {
      clock.runClock().forEach((centisecs) {
        print('centisecs: $centisecs');

        /// ticks~/100 provide secs
        if (secs != centisecs ~/ 100)
          setState(() {
            secs = centisecs ~/ 100;
          });
        if (mins != centisecs ~/ 6000)
          setState(() {
            mins = centisecs ~/ 6000;
          });
        if (hours != centisecs ~/ 360000)
          setState(() {
            hours = centisecs ~/ 360000;
          });
        setState(() {
          centiSecs = centisecs % 100;
        });
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${hours != 0 ? '$hours:' : '00:'}'),
              Text('${mins != 0 ? '$mins:' : '00:'}'),
              Text('${secs != 0 ? '$secs:' : '00:'}'),
              Text('${centiSecs != 0 ? '$centiSecs' : '00'}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    /// only call startTimer if clock is stop
                    if (!state) {
                      clock.startTimer();
                      state = true;
                    }
                  },
                  child: const Text('Start')),
              TextButton(
                  onPressed: () {
                    /// only call stopTimer if clock is running
                    if (state) {
                      clock.stopTimer();
                      state = false;
                    }
                  },
                  child: const Text('Stop')),
              TextButton(
                  onPressed: () {
                    clock.resetTimer();
                    if (widget.countDown) {
                      setState(() {
                        resetCountDown();
                      });
                    } else {
                      setState(() {
                        resetCountUp();
                      });
                    }
                  },
                  child: const Text('Reset')),
            ],
          ),
        ],
      ),
    );
  }

  void formatTime(int centiSec) {}
}
