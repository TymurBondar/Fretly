import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
// import services and widgets...

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  late AudioRecorder audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  List<String> audioFiles = [];
  String audioPath =
      '/private/var/mobile/Containers/Data/Application/66FD38E4-2DC2-4B82-A130-70EBA3000985/tmp/mixkit-dog-barking-twice-1.wav';

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioRecord = AudioRecorder();
    updateRecordingsList(); // New method to update list
  }

  void updateRecordingsList() async {
    final recordings = await getRecordings();
    setState(() {
      audioFiles = recordings;
    });
  }

  @override
  void dispose() {
    audioRecord.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<List<String>> getRecordings() async {
    final directory = await getApplicationDocumentsDirectory();
    final audioDirectory = Directory('${directory.path}/AudioRecordings');
    if (await audioDirectory.exists()) {
      return audioDirectory
          .listSync() // List all files
          .map((item) => item.path) // Convert to path strings
          .where((item) => item.endsWith('.wav')) // Filter for .wav files
          .toList();
    } else {
      return [];
    }
  }

  Future<String?> promptRecordingName(BuildContext context) async {
  String? recordingName;

  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Name Your Recording'),
      content: TextField(
        onChanged: (value) {
          recordingName = value;
        },
        decoration: InputDecoration(hintText: "Enter name here"),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop(recordingName);
          },
        ),
      ],
    ),
  );
}


  Future<String> getAudioPath(String name) async {
    final directory = await getApplicationDocumentsDirectory();
    final audioDirectory = Directory('${directory.path}/AudioRecordings');
    if (!await audioDirectory.exists()) {
      await audioDirectory.create(recursive: true);
    }
    return '${audioDirectory.path}/$name.wav';
  }

  RecordConfig config = const RecordConfig(
      encoder:
          // AudioEncoder.pcm16bits, // Choose an encoder, e.g., AAC Low Complexity
          AudioEncoder.wav,
      bitRate: 128000, // Bit rate in bits per second, e.g., 128 kbps
      sampleRate: 44100, // Sample rate in Hz, e.g., CD quality is 44100 Hz
      numChannels: 1, // Number of channels, 1 for mono
      device: null, // Use the default device
      autoGain: false, // Depending on your need, enable or disable auto gain
      echoCancel: false, // Enable or disable echo cancellation
      noiseSuppress: false // Enable or disable noise suppression
      );

  Future<void> startRecording() async {
    try {
    if (await audioRecord.hasPermission()) {
      String? name = await promptRecordingName(context);
      if (name != null && name.isNotEmpty) {
        String path = await getAudioPath(name); // Updated to include name
        await audioRecord.start(config, path: path);
        log("recording started");
        setState(() {
          isRecording = true;
        });
      }
    }
  } catch (e) {
    log("$e");
  }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stop();
      log("recording stopped");
      setState(() {
        isRecording = false;
        audioPath = path!;
        updateRecordingsList(); // Refresh the list after recording
      });
      log("file saved to $audioPath");
    } catch (e) {
      log("$e");
    }
  }

  Future<void> playRecording(String filePath) async {
    try {
      // Source urlSource = UrlSource(audioPath);
      // await audioPlayer.play(urlSource);
      OpenFile.open(filePath);
    } catch (e) {
      log("the Error is in playRecording(): $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
              onPressed: isRecording ? stopRecording : startRecording,
              child: isRecording
                  ? const Text("Stop Recording")
                  : const Text("Start Recording")),
          ...audioFiles.map((file) => OutlinedButton(
              onPressed: () => playRecording(file),
              child: Text("Play: ${file.split('/').last}"))),
        ],
      ),
    );
  }
}
