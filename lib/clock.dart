import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stop_watch/clock_model.dart';
import 'package:stop_watch/providers.dart';

class ClockWidget extends StatefulWidget {
  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  late final ClockModel clock;
  late int count;
  late double time;
  late int secs;
  late int centiSecs;

  @override
  void initState() {
    count = 0;
    secs = 0;
    centiSecs = 0;
    clock = ClockModel();

    clock.addListener(() {
      clock.runClock().forEach((ticks) {
        print(ticks);
        if (secs != ticks ~/ 100)
          setState(() {
            secs = ticks ~/ 100;
          });
        if (secs == 0) {
          setState(() {
            centiSecs = ticks;
          });
        }
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
    return Column(
      children: [
        Row(
          children: [
            Text('$secs'),
            if (secs > 1) Text(' : $centiSecs'),
          ],
        ),
        TextButton(
            onPressed: () {
              clock.startTimer();
            },
            child: const Text('Start')),
        TextButton(
            onPressed: () {
              clock.stopTimer();
            },
            child: const Text('Stop')),
        TextButton(
            onPressed: () {
              clock.resetTimer();
              setState(() {
                count = 0;
              });
            },
            child: const Text('Reset')),
      ],
    );
  }

  void formatTime(int centiSec) {}
}
