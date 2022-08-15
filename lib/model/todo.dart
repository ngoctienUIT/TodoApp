import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Todo {
  String id;
  String content;
  DateTime time;
  int repeat;
  bool status;
  List<String> images;
  List<String> files;
  Color color;

  Todo(
      {required this.id,
      required this.content,
      required this.time,
      this.color = Colors.white,
      this.repeat = 0,
      this.status = false,
      this.files = const [],
      this.images = const []});

  Map<String, dynamic> toMap() => {
        "id": id,
        "content": content,
        "repeat": repeat,
        "time": time,
        "status": status,
        "images": images,
        "files": files,
        "color": color.value
      };

  Map<String, dynamic> toMapSQL() => {
        "id": id,
        "content": content,
        "repeat": repeat,
        "time": DateFormat("dd/MM/yyyy").format(time),
        "status": status,
        "color": color.value
      };

  factory Todo.fromMapSQL(Map<String, dynamic> data) {
    return Todo(
      id: data["id"],
      content: data["content"],
      repeat: data["repeat"],
      time: DateFormat("dd/MM/yyyy").parse(data["time"]),
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
