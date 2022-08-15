import 'package:intl/intl.dart';

class Todo {
  String id;
  String content;
  DateTime time;
  int repeat;
  bool status;
  List<String> images;
  List<String> files;

  Todo(
      {required this.id,
      required this.content,
      required this.time,
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
        "files": files
      };

  Map<String, dynamic> toMapSQL() => {
        "id": id,
        "content": content,
        "repeat": repeat,
        "time": DateFormat("dd/MM/yyyy").format(time),
        "status": status,
      };

  factory Todo.fromMapSQL(Map<String, dynamic> data) {
    return Todo(
      id: data["id"],
      content: data["content"],
      repeat: data["repeat"],
      time: DateFormat("dd/MM/yyyy").parse(data["time"]),
      status: data["status"] == 0 ? false : true,
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
