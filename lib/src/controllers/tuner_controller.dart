import 'dart:typed_data';
import 'dart:developer';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';

class TunerController {
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  final pitchupDart = PitchHandler(InstrumentType.guitar);
  DateTime? lastEvaluatedTime;

  Function(String note, double pitch, String status)? onResult;
  Function(Object error)? onError;

  TunerController({this.onResult, this.onError});

  void startCapture() {
    _audioRecorder.start(_listener, _onError,
        sampleRate: 44100, bufferSize: 3000);
  }

  void stopCapture() {
    _audioRecorder.stop();
  }

  void _listener(dynamic obj) {
    //gets the audio sample
    final buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();

    if (lastEvaluatedTime == null ||
        DateTime.now().difference(lastEvaluatedTime!).inMilliseconds > 440) {
      lastEvaluatedTime = DateTime.now();
      final result = pitchDetectorDart.getPitch(audioSample);

      //if there is a pitch - evaluate it
      if (result.pitched && result.pitch > 60) {
        double pitch = double.parse(result.pitch.toStringAsFixed(2));
        final handledPitchResult = pitchupDart.handlePitch(pitch);
        log("pitch is $pitch");

        if (handledPitchResult.tuningStatus.name != 'undefined') {
          onResult?.call(handledPitchResult.note, pitch,
              _formatStatus(handledPitchResult.tuningStatus.name));
        }
      }
    }
  }

  void _onError(Object e) {
    onError?.call(e);
  }

  // Format the status to be more readable
  String _formatStatus(String status) {
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
        return status;
    }
  }
}
