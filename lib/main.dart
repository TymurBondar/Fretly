import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:pitch_detector_dart/pitch_detector.dart';

// figure out a way to do this all at once
import 'package:fretly/screens/record_screen.dart';
import 'package:fretly/screens/tabs_screen.dart';
import 'package:fretly/screens/tune_screen.dart';
import 'package:fretly/screens/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int index = 2; // Initial index
  bool showPitch = false;

  

  void _handleShowPitchChanged(bool value) {
    log("the value is :$value");
    setState(() {
      showPitch = value;
    });
  }

 @override
Widget build(BuildContext context) {
  final screens = [
    const RecordScreen(),
    const TabsScreen(),
    TuneScreen(showPitch: showPitch,),
    SettingsScreen(
      onShowPitchChanged: _handleShowPitchChanged,
      showPitch: showPitch,
    )
  ];
  return MaterialApp(
    home: Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.fromARGB(255, 245, 247, 250), Color.fromARGB(255, 195, 207, 226)], // Customize your gradient colors
          ),
        ),
        child: screens[index], // Your current screen
      ),
      bottomNavigationBar: _buildNavigationBar(),
    ),
  );
}


  Widget _buildNavigationBar() {
    return  NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: const Color.fromARGB(255, 224, 30, 121),
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        child: NavigationBar(
          backgroundColor: const Color.fromARGB(255, 182, 12, 63),
          height: 65,
          selectedIndex: index,
          onDestinationSelected: (int index) {
            setState(() => this.index = index);
            // Handle navigation logic here
          },
          destinations: [
            _buildNavigationDestination(CupertinoIcons.mic, "Record"),
            _buildNavigationDestination(CupertinoIcons.music_note_list, "Tabs"),
            _buildNavigationDestination(CupertinoIcons.tuningfork, "Tune"),
            _buildNavigationDestination(CupertinoIcons.settings, "Settings"),
          ],
        ),
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
