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

Future<DateTime?> pickDate(BuildContext context,
        {required DateTime initDate}) =>
    showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

Future<TimeOfDay?> pickTime(BuildContext context) => showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

String timeOfDateToString(TimeOfDay time) {
  String timeString = "";
  if (time.hour < 10) {
    timeString += "0${time.hour}:";
  } else {
    timeString += "${time.hour}:";
  }
  if (time.minute < 10) {
    timeString += "0${time.minute}";
  } else {
    timeString += "${time.minute}";
  }
  return timeString;
}

TimeOfDay stringToTimeOfDate(String time) {
  int hour = int.parse(time.substring(0, 2));
  int minute = int.parse(time.substring(3, 5));
  return TimeOfDay(hour: hour, minute: minute);
}

DateTime getDateNow() {
  DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}
