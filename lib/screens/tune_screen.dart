import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:record/record.dart';
import 'dart:async';


class TuneScreen extends StatefulWidget {
  const TuneScreen({super.key});

  @override
  State<TuneScreen> createState() => _TuneScreenState();
}

class _TuneScreenState extends State<TuneScreen> {

  // THIS CODE IS FOR THE AUDIO PROCESSING (I DON'T KNOW WHAT I AM DOING 10X)
  final myRecording = AudioRecorder(); // I don't know where i should put this.
  Timer? timer;
  double volume = 0.0;
  double minVolume = -45.0;

  @override
  void dispose(){
    // Cancel the timer when the widget is disposed to avoid setState errors
    timer?.cancel();
    super.dispose();
  }

  startTimer() async {
    timer ??= Timer.periodic(
        const Duration(milliseconds: 50), (timer) => updateVolume());
  }

  updateVolume() async {
    Amplitude ampl = await myRecording.getAmplitude();
    if (ampl.current > minVolume) {
      setState(() {
        volume = (ampl.current - minVolume) / minVolume;
      });
    }
  }

  int volume0to(int maxVolumeToDisplay) {
    return (volume * maxVolumeToDisplay).round().abs();
  }

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
        await myRecording.startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
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
    return  FutureBuilder(
      future: startRecording(),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        return Center(child:  Text("Volume is ${volume0to(100)}", style: const TextStyle(fontSize: 55)));
      },
      );
  }
}
