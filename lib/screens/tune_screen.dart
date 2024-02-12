import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';

class TuneScreen extends StatefulWidget {
  final bool showPitch;
  const TuneScreen({super.key, required this.showPitch});

  @override
  State<TuneScreen> createState() => _TuneScreenState();
}

class _TuneScreenState extends State<TuneScreen> {
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  final pitchupDart = PitchHandler(InstrumentType.guitar);
  DateTime? lastEvaluatedTime;

  String note = "";
  double pitch = 0.00;
  String status = "Play \nSomething!";

  void _startCapture() {
    _audioRecorder.start(listener, onError,
        sampleRate: 44100, bufferSize: 3000);

    setState(() {
      note = "";
    });
  }

  void listener(dynamic obj) {
    //Gets the audio sample
    var buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();

    if (lastEvaluatedTime == null ||
        DateTime.now().difference(lastEvaluatedTime!).inMilliseconds > 440) {
      lastEvaluatedTime = DateTime.now();
      // Update last evaluated time
      //Uses pitch_detector_dart library to detect a pitch from the audio sample

      final result = pitchDetectorDart.getPitch(audioSample);

      //If there is a pitch - evaluate it
      if (result.pitched && result.pitch > 60) {
        //Uses the pitchupDart library to check a given pitch for a Guitar
        pitch = double.parse(result.pitch.toStringAsFixed(2));
        final handledPitchResult = pitchupDart.handlePitch(pitch);
        log("pitch is $pitch");
        if (handledPitchResult.tuningStatus.name != 'undefined') {
          setState(() {
            note = handledPitchResult.note;
            status = formatStatus(handledPitchResult.tuningStatus.name);
          });
        }
      }
    }
  }

  void onError(Object e) {}

  @override
  void initState() {
    super.initState();
    _startCapture(); // Start capture when widget is initialized
  }

  @override
  void dispose() {
    // _stopCapture(); // Ensure to stop capture when disposing the widget
    _audioRecorder.stop();
    super.dispose();
  }

  String formatStatus(String status) {
    switch (status) {
      case "toolow":
        return "too low";
      case "toohigh":
        return "too high";
      case "waytoolow":
        return "way too low";
      case "waytoohigh":
        return "way too high";
      default:
        return status; // Returns the original status if it doesn't match any case
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300.0,
            height: 300.0,
            decoration: BoxDecoration(
              color: status == 'tuned'
                  ? const Color.fromARGB(255, 80, 141, 105)
                  : Colors.teal[300],
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color.fromARGB(255, 255, 143, 143),
                width: 8.0,
              ),
            ),
            child: Center(
                child: Text(
              widget.showPitch ? "$note \n the pitch is $pitch" : note,
              style: const TextStyle(
                  fontSize: 38,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )),
          ),
          Text(
            status,
            style: const TextStyle(
              fontSize: 48,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
