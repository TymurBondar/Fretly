import 'dart:developer';

import 'package:flutter/material.dart';
// import services and widgets...

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(onPressed: () => log(""), child: const Text('Start Recording')),
              OutlinedButton(onPressed: () => log(""), child: const Text('Stop Recording')),
            ],
          ),
        ),
      ),
    );
  }
}
