import 'dart:typed_data';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';

class TuneScreen extends StatefulWidget {
  const TuneScreen({super.key});

  @override
  State<TuneScreen> createState() => _TuneScreenState();
}

class _TuneScreenState extends State<TuneScreen> {
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  final pitchupDart = PitchHandler(InstrumentType.guitar);

  String note = "";
  double pitch = 0.00;
  String status = "";

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

    //Uses pitch_detector_dart library to detect a pitch from the audio sample

    //data is a list of super wierd numbers
    // log("$audioSample");

    final result = pitchDetectorDart.getPitch(audioSample);

    //If there is a pitch - evaluate it
    if (result.pitched && result.pitch > 60) {
      //Uses the pitchupDart library to check a given pitch for a Guitar
      pitch = double.parse(result.pitch.toStringAsFixed(2));
      final handledPitchResult = pitchupDart.handlePitch(pitch);
      if (handledPitchResult.tuningStatus.name != 'undefined') {
        setState(() {
          note = handledPitchResult.note;
          status = handledPitchResult.tuningStatus.name;
        });
      }
      // note = handledPitchResult.note;
      log("the pitch is $pitch \n the closest note is $note \n the status is $status");
    }
  }

  void onError(Object e) {
    log("$e");
  }

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

  Map<String, double> frequencies = {
    'E2': 82.41,
    'A2': 110.00,
    'D3': 146.83,
    'G3': 196.00,
    'B3': 246.94,
    'E4': 329.63
  };

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
              color: status == 'tuned' ? const Color.fromARGB(255, 11, 169, 103) : Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Center(
                child: Text(
              note,
              style: const TextStyle(
                  fontSize: 124,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )),
          ),
          Text(
            status,
            style: const TextStyle(fontSize: 64),
          ),
        ],
      ),
    );
  }
}
