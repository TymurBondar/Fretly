import 'package:record/record.dart';
// import 'package:audioplayers/audioplayers.dart'; // No needed rn, may implement a custom player.
import 'package:path_provider/path_provider.dart';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import './record_config.dart';
import 'package:open_file/open_file.dart';

//store audiofiles
//play recording
// delete recording

class RecordingController with ChangeNotifier {
  late final AudioRecorder
      _audioRecorder; // No longer directly instantiated here
  // late final AudioPlayer _audioPlayer;

  RecordingController() {
    _initSelf();
  }

  void _initSelf() {
    _audioRecorder = AudioRecorder();
    // Any additional setup
    // _audioPlayer = AudioPlayer();
  }

  Future<String> getAudioPath(String name) async {
    final directory = await getApplicationDocumentsDirectory();
    final audioDirectory = Directory('${directory.path}/AudioRecordings');
    if (!await audioDirectory.exists()) {
      await audioDirectory.create(recursive: true);
    }
    return '${audioDirectory.path}/$name.wav';
  }

  Future<bool> startRecording() async {
    // Implement recording start logic
    bool hasPermission = await _audioRecorder.hasPermission();
    if (!hasPermission) {
      return false;
    }

    try {
      // Retrieve the highest ID used so far and increment it for the new recording
      int highestId = await getHighestRecordingId();
      int newId = highestId + 1;
      String recordingName = "Recording_$newId";

      // Update the stored highest ID
      // await updateHighestRecordingId(newId);

      // Use the unique name for the new recording
      String path = await getAudioPath(recordingName);
      await _audioRecorder.start(config, path: path);
      return true;
    } catch (e) {
      log("Failed to start recording: $e");
      return false;
    }
  }

  Future<void> stopRecording() async {
    // Implement recording stop logic
    try {
      await _audioRecorder.stop();
      // Optionally, you can perform additional actions after stopping,
      // such as updating a state or processing the recorded file.
    } catch (e) {
      log("Failed to stop recording: $e");
      // Handle the error or notify the user as needed
    }
  }

  Future<void> playRecording(String path) async {
    // Implement playback logic
    try {
      // await _audioPlayer.play(DeviceFileSource(path));
      // This will play the audio file from the given path
      // open the recording
      OpenFile.open(path);
    } catch (e) {
      log("Failed to play recording: $e");
      // Handle the error, such as informing the user that playback failed
    }
  }

  //function to delete the recording
  Future<void> deleteRecording(String path) async {
    // Implement deletion logic
    try {
      await File(path).delete();
      // Optionally, you can perform additional actions after deleting,
      // such as updating a state or notifying the user.
    } catch (e) {
      log("Failed to delete recording: $e");
      // Handle the error or notify the user as needed
    }
  }

  //function to name the recording after it is created
  Future<void> nameRecording(String path, String name) async {
    // Implement renaming logic
    try {
      await File(path).rename(name);
      // Optionally, you can perform additional actions after renaming,
      // such as updating a state or notifying the user.
    } catch (e) {
      log("Failed to rename recording: $e");
      // Handle the error or notify the user as needed
    }
  }

  Future<int> getHighestRecordingId() async {
    List<String> existingRecordings =
        await getRecordings(); // Assuming this returns a list of filenames
    int highestId = 0;

    // Regular expression to extract the numerical part of the recording name
    final RegExp regex = RegExp(r'Recording_(\d+)');

    for (String fileName in existingRecordings) {
      final match = regex.firstMatch(fileName);
      if (match != null && match.groupCount >= 1) {
        int currentId = int.parse(match.group(1)!);
        if (currentId > highestId) {
          highestId = currentId;
        }
      }
    }

    return highestId;
  }

  Future<List<String>> getRecordings() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final audioDirectory = Directory('${directory.path}/AudioRecordings');
      if (await audioDirectory.exists()) {
        final files = audioDirectory
            .listSync() // Consider using .list() asynchronously for large directories
            .where((item) => item.path.endsWith(
                '.wav')) // Filter for .wav files or your preferred format
            .map((item) => item.path)
            .toList();
        notifyListeners();
        return files; // Just return the list of file paths
      } else {
        return []; // Return an empty list if the directory does not exist
      }
    } catch (e) {
      log("Failed to get recordings: $e"); // Use print or a logging package if you're not using Flutter's developer tools
      return []; // Return an empty list in case of error
    }
  }
}
