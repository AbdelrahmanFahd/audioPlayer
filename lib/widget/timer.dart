import 'dart:async';

import 'package:flutter/material.dart';

class TimerController extends ValueNotifier<bool> {
  TimerController({bool isPlaying = false}) : super(isPlaying);

  void startTimer() => value = true;
  void stopTimer() => value = false;
}

class TimerBuild extends StatefulWidget {
  TimerBuild({required this.controller, Key? key}) : super(key: key);
  final TimerController controller;

  @override
  State<TimerBuild> createState() => _TimerBuildState();
}

class _TimerBuildState extends State<TimerBuild> {
  Duration duration = const Duration();
  Timer? timer;

  void startTimer({bool resets = true}) {
    if (resets) reset();
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer({bool resets = true}) {
    if (resets) reset();

    setState(() => timer!.cancel());
  }

  void reset() {
    setState(() => duration = const Duration());
  }

  void addTime() {
    setState(() {
      final newDurationSeconds = duration.inSeconds + 1;
      duration = Duration(seconds: newDurationSeconds);
    });
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      widget.controller.value ? startTimer() : stopTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Container(
      alignment: Alignment.center,
      height: 230,
      width: 230,
      decoration: BoxDecoration(
        color: Colors.blueGrey[900],
        borderRadius: BorderRadius.circular(160),
        border: Border.all(width: 8, color: Colors.white),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.mic, size: 35),
          Text(
            '$minutes:$seconds',
            style: const TextStyle(
                fontWeight: FontWeight.w900, fontSize: 45, color: Colors.white),
          ),
          Text(
            widget.controller.value ? 'Stop' : 'Press Start',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
