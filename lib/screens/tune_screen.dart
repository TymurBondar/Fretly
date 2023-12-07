import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';

// FOR log()
import 'dart:developer';

// FOR CAPTURING AUDIO FROM THE MIC
import 'package:record/record.dart';

// FOR TIMER
import 'dart:async';

// FOR DETECTING PITCH
import 'package:pitch_detector_dart/algorithm/pitch_algorithm.dart';
import 'package:pitch_detector_dart/algorithm/yin.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitch_detector_dart/pitch_detector_result.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';
import 'package:pitchupdart/pitch_result.dart';
import 'package:pitchupdart/tuning_status.dart';

class TuneScreen extends StatefulWidget {
  const TuneScreen({super.key});

  @override
  State<TuneScreen> createState() => _TuneScreenState();
}

class _TuneScreenState extends State<TuneScreen> {
  // final pitchDetectorDart = PitchDetector(44100, 2000); // Creates a pitch detector.

  final myRecording = AudioRecorder(); // Creates a recorder that will listen for sound FROM THE RECORD PACKAGE.

  // void startStreaming() async{

  //   // Start the audio stream
  // Stream<Uint8List> audioStream = await myRecording.startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
  // log("streaming started");

  // // Listen to the stream
  // audioStream.listen((Uint8List data) {
  //   log("listening to the stream");
  //   // Convert Uint8List to List<int>
  //   List<int> intData = myRecording.convertBytesToInt16(data);
  //   log("converted to List<int>: $intData");

  //   // Convert List<int> to List<double>
  //   List<double> doubleData = intData.map((i) => i / 32768.0).toList();
  //   log("converted to doubledata: $doubleData");

  //   // Now use doubleData with your pitch detection library
  //   try{
  //     final result = pitchDetectorDart.getPitch(doubleData);
  //     log("result is: ${result.pitch}");
  //   }catch(e) {log("$e");}
    
    // Do something with the pitch detection result
// });

//   }

  //Call the get pitch method passing as a parameter the audio sample (List<double>) to detect a pitch 
  // final result = pitchDetectorDart.getPitch(myRecording);


  
  Future<bool> startRecording() async {
    // I used Permission_handler package before, I don't think I need it anymore but I will still keep it commented, DELETE IN THE FUTURE
    // var permissionStatus = await Permission.microphone.request();
    // log("${permissionStatus.isGranted}"); //permission is now granted
    var permission = await myRecording.hasPermission();

    if (permission) {
      // log(".hasPermission is working");
      //there is an error in this try block
      try {
        if (!await myRecording.isRecording()) {
          await myRecording
              .startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
          startTimer();
        }
      } catch (e) {
        log("Error during recording setup: $e");
        return false; // Return false if there is an error
      }
      log("volume is ${volume0to(100)}");
      // log("Access to Microphone Granted");
      return true;
    } else {
      log("Denied!!!!");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    startStreaming();
    // return FutureBuilder(
    //   future: startRecording(),
    //   builder: (context, AsyncSnapshot<bool> snapshot) {
        return const Center(
            child: Text("Pitch!!",
                style:  TextStyle(fontSize: 55)));
    //   },
    // );
  }
}
