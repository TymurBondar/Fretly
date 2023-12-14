import 'dart:developer';
import 'package:flutter/material.dart';
// import services and widgets...

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                  child: OutlinedButton(
                      onPressed: () => log("started"),
                      child: const Text(
                        'Start Recording',
                        textAlign: TextAlign.center,
                      ))),
              Flexible(
                  child:  OutlinedButton(
                      onPressed: () => log('stopped'),
                      child: const Text(
                        'Stop Recording',
                        textAlign: TextAlign.center,
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
