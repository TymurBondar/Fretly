import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:pitch_detector_dart/pitch_detector.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int index = 2; // Initial index

  // THIS CODE IS FOR THE AUDIO PROCESSING (I DON'T KNOW WHAT I AM DOING 10X)
  final myRecording = AudioRecorder(); // I don't know where i should put this.
  Timer? timer;
  double volume = 0.0;
  double minVolume = -45.0;

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
    log(".hasPermission is working");
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
    log("Access to Microphone Granted");
    return true;
  } else {
    log("Denied!!!!");
    return false;
  }
}



  final screens = [
    const Center(
      child: Text(
        "Record",
        style: TextStyle(fontSize: 72),
      ),
    ),
    const Center(
      child: Text(
        "Tabs",
        style: TextStyle(fontSize: 72),
      ),
    ),
    const Center(child: Text("yes", style: TextStyle(fontSize: 72))),
    const Center(
      child: Text(
        "Settings",
        style: TextStyle(fontSize: 72),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: startRecording(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          return Scaffold(
            body: snapshot.hasData
                ? Center(
                  child: Text("VOLUME\n${volume0to(100)}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 42, fontWeight: FontWeight.bold)),
                )
                : screens[index],
            bottomNavigationBar: _buildNavigationBar(),
          );
        });
  }

  Widget _buildNavigationBar() {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: const Color.fromARGB(255, 18, 86, 141),
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
      child: NavigationBar(
        backgroundColor: const Color.fromARGB(255, 26, 104, 168),
        height: 55,
        selectedIndex: index,
        onDestinationSelected: (int index) {
          setState(() => this.index = index);
          // Handle navigation logic here
        },
        destinations: [
          _buildNavigationDestination(Icons.graphic_eq_outlined, "Record"),
          _buildNavigationDestination(Icons.picture_as_pdf, "Tabs"),
          _buildNavigationDestination(Icons.music_note_outlined, "Tune"),
          _buildNavigationDestination(Icons.settings, "Settings"),
        ],
      ),
    );
  }

  Widget _buildNavigationDestination(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: NavigationDestination(
        icon: Icon(
          icon,
          color: Colors.white,
          size: 36.0,
        ),
        label: label,
      ),
    );
  }
}
