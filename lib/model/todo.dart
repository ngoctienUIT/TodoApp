import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/page/handle_todo/pick_function.dart';

class Todo {
  String id;
  String title;
  String content;
  DateTime date;
  TimeOfDay startTime;
  TimeOfDay finishTime;
  int repeat;
  int remind;
  bool status;
  Color color;
  List<String> images;
  List<String> files;

  Todo(
      {required this.id,
      required this.title,
      required this.content,
      required this.date,
      required this.startTime,
      required this.finishTime,
      this.color = Colors.white,
      this.repeat = 0,
      this.remind = 0,
      this.status = false,
      this.files = const [],
      this.images = const []});

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "content": content,
        "repeat": repeat,
        "remind": remind,
        "startTime": startTime,
        "finishTime": finishTime,
        "status": status,
        "images": images,
        "files": files,
        "color": color.value
      };

  Map<String, dynamic> toMapSQL() => {
        "id": id,
        "title": title,
        "content": content,
        "repeat": repeat,
        "remind": remind,
        "date": DateFormat("dd/MM/yyyy").format(date),
        "startTime": timeOfDateToString(startTime),
        "finishTime": timeOfDateToString(finishTime),
        "status": status,
        "color": color.value
      };

  factory Todo.fromMapSQL(Map<String, dynamic> data) {
    return Todo(
      id: data["id"],
      title: data["title"],
      content: data["content"],
      repeat: data["repeat"],
      remind: data["remind"],
      date: DateFormat("dd/MM/yyyy").parse(data["date"]),
      startTime: stringToTimeOfDate(data["startTime"]),
      finishTime: stringToTimeOfDate(data["finishTime"]),
      status: data["status"] == 0 ? false : true,
      color: Color(data["color"]),
    );
  }

  // factory Todo.fromMap(Map<String, dynamic> data) {
  //   return Todo(
  //       id: data["id"],
  //       content: data["content"],
  //       time: DateTime(data["time"]),
  //       status: data["status"] == 0 ? false : true,
  //       files: data["files"],
  //       images: data["images"]);
  // }
}
