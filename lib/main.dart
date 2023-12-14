import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:pitch_detector_dart/pitch_detector.dart';

// figure out a way to do this all at once
import 'package:fretly/screens/record_screen.dart';
import 'package:fretly/screens/tabs_screen.dart';
import 'package:fretly/screens/tune_screen.dart';
import 'package:fretly/screens/settings_screen.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int index = 2; // Initial index

  final screens = [
    const RecordScreen(),
    const TabsScreen(),
    const TuneScreen(),
    const SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  Widget _buildNavigationBar() {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: const Color.fromARGB(255, 11, 169, 103),
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15)
          ),
          child: NavigationBar(
            backgroundColor: const Color.fromARGB(255, 4, 4, 10),
            height: 65,
            selectedIndex: index,
            onDestinationSelected: (int index) {
              setState(() => this.index = index);
              // Handle navigation logic here
            },
            destinations: [
              _buildNavigationDestination(Icons.graphic_eq_outlined, "Record"),
              _buildNavigationDestination(Icons.picture_as_pdf, "Tabs"),
              _buildNavigationDestination(Icons.music_note_outlined, "Tune"),
              _buildNavigationDestination(Icons.settings, "Settings"),
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
