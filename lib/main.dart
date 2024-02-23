import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:permission_handler/permission_handler.dart';
// import 'package:pitch_detector_dart/pitch_detector.dart';

// figure out a way to do this all at once
import 'package:fretly/src/screens/record_screen.dart';
import 'package:fretly/src/screens/tabs_screen.dart';
import 'package:fretly/src/screens/tune_screen.dart';
import 'package:fretly/src/screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
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
      TuneScreen(
        showPitch: showPitch,
      ),
      SettingsScreen(
        onShowPitchChanged: _handleShowPitchChanged,
        showPitch: showPitch,
      )
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
        body: Container(
          child: screens[index], // Your current screen
        ),
        bottomNavigationBar: _buildNavigationBar(),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: const Color.fromARGB(255, 255, 143, 143),
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        child: NavigationBar(
          backgroundColor: const Color.fromARGB(255, 19, 19, 19),
          height: 80,
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
      padding: const EdgeInsets.only(top: 5),
      child: NavigationDestination(
        icon: Icon(
          icon,
          color: Colors.grey[100],
          size: 32.0,
        ),
        label: label,
      ),
    );
  }
}
