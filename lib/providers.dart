import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stop_watch/clock_model.dart';

final streamTimerProvider = StreamProvider.autoDispose<int>((ref) async* {
  int i = 0;
  while (true) {
    await Future.delayed(
      Duration(seconds: 1),
    );
    yield i++;
  }
});

final timerProvider = ChangeNotifierProvider((ref) => ClockModel());
