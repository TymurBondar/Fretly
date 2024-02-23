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
  String audioPath = '';

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
          decoration: const InputDecoration(hintText: "Enter name here"),
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
        String path = await getAudioPath("temp"); // Updated to include name
        await audioRecord.start(config, path: path);
        log("recording started");
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      log("$e");
    }
  }

  Future<void> stopRecording() async {
    try {
      String? tempPath = await audioRecord.stop();
      log("Recording stopped");
      setState(() {
        isRecording = false;
      });

      if (tempPath != null) {
        renameRecording(tempPath);
      }
    } catch (e) {
      log("$e");
    }
  }

  void renameRecording(String tempPath) {
    // Delay the prompt to ensure it's not called with an outdated context
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String? name = await promptRecordingName(context);
      if (name != null && name.isNotEmpty) {
        String finalPath = await getAudioPath(name);
        File(tempPath).renameSync(finalPath);
        setState(() {
          audioPath = finalPath;
          updateRecordingsList();
        });
        log("File saved to $audioPath");
      } else {
        // Optionally delete the temp file if no name is given
        File(tempPath).delete();
      }
    });
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

  void deleteRecording(String filePath) {
    File(filePath).delete();
    updateRecordingsList();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    floatingActionButton: Padding(
      padding: const EdgeInsets.only(bottom: 125.0), // Adjust this value as needed
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color.fromARGB(255, 19, 19, 19), width: 4),
        ),
        child: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: const Color.fromARGB(255, 255, 143, 143),
          onPressed: () {
            if (isRecording) {
              stopRecording();
            } else {
              startRecording();
            }
          },
          child: Icon(isRecording ? Icons.stop : Icons.mic),
        ),
      ),
    ),
    body: Column(
      children: [
        Expanded(
          child: ListView(
            children: audioFiles
                .map((file) => Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => playRecording(file),
                            child: Text(
                              "Play: ${file.split('/').last}",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 19, 19, 19)),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deleteRecording(file),
                        ),
                      ],
                    ))
                .toList(),
          ),
        ),
      ],
    ),
  );
}
}