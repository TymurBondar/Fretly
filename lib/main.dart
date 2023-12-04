import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("I don't know what I am doing"),
        ),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: const Color.fromARGB(255, 18, 86, 141),
            labelTextStyle: MaterialStateProperty.all(
               const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)
            ),
          ),
          child: NavigationBar(
            backgroundColor: const Color.fromARGB(255, 26, 104, 168),
            destinations: const [
              NavigationDestination(
                icon: Icon(
                  Icons.graphic_eq_outlined,
                  color: Colors.white,
                  size: 38.0,
                ),
                label: ("Record"),
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.picture_as_pdf,
                  color: Colors.white,
                  size: 38.0,
                ),
                label: "Tabs",
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.music_note_outlined,
                  color: Colors.white,
                  size: 38.0,
                ),
                label: "Tune",
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 38.0,
                ),
                label: "Settings",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
