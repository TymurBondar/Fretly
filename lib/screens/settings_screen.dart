import 'package:flutter/material.dart';
// import services and widgets...

class SettingsScreen extends StatefulWidget {
  final Function(bool) onShowPitchChanged;
  final bool showPitch;

  const SettingsScreen(
      {super.key, required this.onShowPitchChanged, required this.showPitch});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    bool showPitch = widget.showPitch;
    return Center(
      child: ListView(
        children: [
          SwitchListTile(
            title:
                const Text(style: TextStyle(color: Colors.black), 'Show Pitch'),
            value: showPitch,
            activeColor: const Color.fromARGB(255, 255, 143, 143),
            inactiveThumbColor: const Color.fromARGB(255, 19, 19, 19),
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
