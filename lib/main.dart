import 'package:audio_player_app/module/sound_player.dart';
import 'package:flutter/material.dart';
import 'widget/timer.dart';
import 'module/sound_recorder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final timeController = TimerController();
  final recorder = SoundRecorder();
  final player = SoundPlayer();
  @override
  void initState() {
    super.initState();
    recorder.init();
    player.init();
  }

  @override
  void dispose() {
    super.dispose();
    recorder.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.redAccent[200],
          centerTitle: true,
          title: const Text('Audio Recording'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isPlaying ? playing() : TimerBuild(controller: timeController),
            const SizedBox(height: 20),
            buildStart(),
            const SizedBox(height: 20),
            buildPlay(),
          ],
        )),
      ),
    );
  }

  bool isRecording = false;
  Widget buildStart() {
    final icon = isRecording ? Icons.stop : Icons.mic;
    final text = isRecording ? 'STOP' : 'START';
    final primary = isRecording ? Colors.red : Colors.white;
    final onPrimary = isRecording ? Colors.white : Colors.black;

    return ElevatedButton.icon(
        onPressed: () async {
          setState(() {});
          isRecording = !recorder.isRecording;
          setState(() {
            if (isRecording) {
              timeController.startTimer();
            } else {
              timeController.stopTimer();
            }
          });
          await recorder.toggleRecording();
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(175, 50),
          primary: primary,
          onPrimary: onPrimary,
        ),
        icon: Icon(icon),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ));
  }

  var isPlaying = false;
  Widget buildPlay() {
    final icon = isPlaying ? Icons.stop : Icons.play_arrow;
    final text = isPlaying ? 'Stop Playing' : 'Play Recording';

    return ElevatedButton.icon(
        onPressed: () async {
          isPlaying = !isPlaying;
          await player.togglePlaying(
              whenFinished: () => setState(() {
                    isPlaying = !isPlaying;
                  }));
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(175, 50),
          primary: Colors.white,
          onPrimary: Colors.black,
        ),
        icon: Icon(icon),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ));
  }

  Widget playing() {
    return Container(
      alignment: Alignment.center,
      height: 230,
      width: 230,
      decoration: BoxDecoration(
        color: Colors.blueGrey[900],
        borderRadius: BorderRadius.circular(160),
        border: Border.all(width: 8, color: Colors.white),
      ),
      child: Icon(
        Icons.music_note_outlined,
        size: 120,
      ),
    );
  }
}
