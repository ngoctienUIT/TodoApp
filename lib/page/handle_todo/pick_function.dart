import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

Future<List<String>> pickFile() async {
  FilePickerResult? result =
      await FilePicker.platform.pickFiles(allowMultiple: true);

  if (result != null) {
    return result.paths.map((path) => path!).toList();
  } else {
    return [];
  }
}

Future<List<String>> pickImage() async {
  try {
    final imageList = await ImagePicker().pickMultiImage();
    if (imageList == null) return [];
    return imageList.map((image) => image.path).toList();
  } on PlatformException catch (_) {
    return [];
  }
}

Future<DateTime?> pickDate(BuildContext context, DateTime dateTime) =>
    showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
