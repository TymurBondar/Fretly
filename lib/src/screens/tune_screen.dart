import 'package:flutter/material.dart';
import 'package:fretly/src/controllers/tuner_controller.dart';

class TuneScreen extends StatefulWidget {
  final bool showPitch;
  const TuneScreen({super.key, required this.showPitch});

  @override
  State<TuneScreen> createState() => _TuneScreenState();
}

class _TuneScreenState extends State<TuneScreen> {
  final TunerController _tunerController = TunerController();

  String _note = "";
  double _pitch = 0.00;
  String _status = "Play \nSomething!";

  @override
  void initState() {
    super.initState();
    _tunerController.onResult = (note, pitch, status) {
      setState(() {
        _note = note;
        _pitch = pitch;
        _status = status;
      });
    };
    _tunerController.startCapture(); // Start capture when widget is initialized
  }

  @override
  void dispose() {
    // Ensure to stop capture when disposing the widget
    _tunerController.stopCapture();
    super.dispose();
  }

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
              color: _status == 'tuned'
                  ? const Color.fromARGB(255, 80, 141, 105)
                  : const Color.fromARGB(255, 173, 171, 171),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color.fromARGB(255, 255, 143, 143),
                width: 8.0,
              ),
            ),
            child: Center(
                child: Text(
              widget.showPitch ? "$_note \n the pitch is $_pitch" : _note,
              style: const TextStyle(
                  fontSize: 38,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )),
          ),
          Text(
            _status,
            style: const TextStyle(
              fontSize: 48,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
