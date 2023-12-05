import 'package:flutter/material.dart';

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
  final screens = [
    const Center(
      child: Text(
        "Record",
        style: TextStyle(fontSize: 72),
      ),
    ),
    const Center(
      child: Text(
        "Tabs",
        style: TextStyle(fontSize: 72),
      ),
    ),
    const Center(
      child: Text(
        "Tune",
        style: TextStyle(fontSize: 72),
      ),
    ),
    const Center(
      child: Text(
        "Settings",
        style: TextStyle(fontSize: 72),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: screens[index],
        bottomNavigationBar: _buildNavigationBar(),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: const Color.fromARGB(255, 18, 86, 141),
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
      child: NavigationBar(
        backgroundColor: const Color.fromARGB(255, 26, 104, 168),
        height: 55,
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
