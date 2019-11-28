import 'package:flutter/material.dart';
import 'package:workout_helper/general/flip_panel.dart';

class FlipCountDownUtil {

  static final int MAX_RESTING_MINS = 20;

  static FlipClock buildRestingCount(int startSecond, Function onCountdownEnd,
      BuildContext context, {double digitSize = 60.0}) {
    int min = (startSecond / 60).floor();
    int seconds = (startSecond - min * 60);
    FlipClock restingCount = FlipClock.simple(
      startTime: DateTime(2018, 0, 0, 0, min, seconds),
      timeLeft: Duration(minutes: MAX_RESTING_MINS),
      height: digitSize + 5,
      digitColor: Colors.white,
      backgroundColor: Theme
          .of(context)
          .primaryColor,
      digitSize: digitSize,
      borderRadius: const BorderRadius.all(Radius.circular(3.0)),
      onCountDownEnd: () {
        onCountdownEnd();
      },
    );
    return restingCount;
  }
}