import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:file_picker/file_picker.dart';

class TabsScreen extends StatelessWidget {
  const TabsScreen({super.key});

  openFileFromPath() async {
    // var file = await OpenFile.open(path);
    // log("$file");

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      log("${file.path}");
      OpenFile.open(file.path);
    } else {
      // User canceled the picker
      log("file is null");
    }
  }

  displaySelectedFile(path){
    
  } 

  @override
  Widget build(BuildContext context) {
    return Center(
        child: OutlinedButton(
            onPressed: () => openFileFromPath(),
            child: const Text("Pick a Tab to view")));
  }
}
