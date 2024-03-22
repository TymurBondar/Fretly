import 'package:record/record.dart';

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
