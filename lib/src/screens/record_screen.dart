import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import '../controllers/record_controller/recorder_controller.dart'; // Adjust the import path as necessary

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  late RecordingController _recorderController;
  bool isRecording = false;
  List<String> _audioFiles = [];

  @override
  void initState() {
    super.initState();
    _recorderController = RecordingController();
    _loadInitialData();
  }

  void _loadInitialData() async {
    _audioFiles = await _recorderController.getRecordings();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _recorderController.dispose();
    super.dispose();
  }

  Future<void> updateRecordingsList() async {
    List<String> newRecordings = await _recorderController.getRecordings();
    setState(() {
      _audioFiles = newRecordings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Screen'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              if (isRecording) {
                await _recorderController.stopRecording();
                setState(() {
                  isRecording = false;
                });
                log(isRecording
                    .toString()); //after testing the variable changes
                updateRecordingsList();
              } else {
                // Define how you want to generate the path for your recording
                await _recorderController.startRecording();
                setState(() {
                  isRecording = true;
                });
                log(isRecording
                    .toString()); //after testing the variable changes
              }
            },
            child: Text(isRecording
                ? 'Stop Recording'
                : 'Start Recording'), //this text doesn't change though
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _audioFiles.length,
              itemBuilder: (context, index) {
                final file = _audioFiles[index];
                return ListTile(
                  title: Text(file.split('/').last),
                  onTap: () => _recorderController.playRecording(file),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await _recorderController.deleteRecording(file);
                      updateRecordingsList();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
