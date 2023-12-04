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
               const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)
            ),
          ),
          child: NavigationBar(
            backgroundColor: const Color.fromARGB(255, 26, 104, 168),
            height: 60,
            selectedIndex: 2,
            destinations: const [
              Padding(
                padding: EdgeInsets.only(top: 17.5),
                child: NavigationDestination(
                    icon: Icon(
                      Icons.graphic_eq_outlined,
                      color: Colors.white,
                      size: 36.0,
                    ),
                    label: ("Record"),
                  ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 17.5),
                child: NavigationDestination(
                  icon: Icon(
                    Icons.picture_as_pdf,
                    color: Colors.white,
                    size: 36.0,
                  ),
                  label: "Tabs",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 17.5),
                child: NavigationDestination(
                  icon: Icon(
                    Icons.music_note_outlined,
                    color: Colors.white,
                    size: 36.0,
                  ),
                  label: "Tune",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 17.5),
                child: NavigationDestination(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 36.0,
                  ),
                  label: "Settings",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
