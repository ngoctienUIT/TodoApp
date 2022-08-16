import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Todo {
  String id;
  String content;
  DateTime startTime;
  DateTime finishTime;
  int repeat;
  bool status;
  Color color;
  List<String> images;
  List<String> files;

  Todo(
      {required this.id,
      required this.content,
      required this.startTime,
      required this.finishTime,
      this.color = Colors.white,
      this.repeat = 0,
      this.status = false,
      this.files = const [],
      this.images = const []});

  Map<String, dynamic> toMap() => {
        "id": id,
        "content": content,
        "repeat": repeat,
        "startTime": startTime,
        "finishTime": finishTime,
        "status": status,
        "images": images,
        "files": files,
        "color": color.value
      };

  Map<String, dynamic> toMapSQL() => {
        "id": id,
        "content": content,
        "repeat": repeat,
        "startTime": DateFormat("dd/MM/yyyy").format(startTime),
        "finishTime": DateFormat("dd/MM/yyyy").format(finishTime),
        "status": status,
        "color": color.value
      };

  factory Todo.fromMapSQL(Map<String, dynamic> data) {
    return Todo(
      id: data["id"],
      content: data["content"],
      repeat: data["repeat"],
      startTime: DateFormat("dd/MM/yyyy").parse(data["startTime"]),
      finishTime: DateFormat("dd/MM/yyyy").parse(data["finishTime"]),
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
