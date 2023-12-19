import 'package:flutter/material.dart';
// import services and widgets...

class SettingsScreen extends StatefulWidget {
  final Function(bool) onShowPitchChanged;
  final bool showPitch;

  const SettingsScreen({super.key, required this.onShowPitchChanged, required this.showPitch});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  

  @override
  Widget build(BuildContext context) {
    bool showPitch = widget.showPitch;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Show Pitch'),
            value: showPitch,
            onChanged: (bool value) {
              setState(() {
                showPitch = value;
              });
              widget.onShowPitchChanged(value); // Invoke the callback here
            },
          ),
        ],
      ),
    );
  }
}
