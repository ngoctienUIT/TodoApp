class Todo {
  String id;
  String content;
  DateTime time;
  bool status;
  List<String> images;
  List<String> files;

  Todo(
      {required this.id,
      required this.content,
      required this.time,
      this.status = false,
      this.files = const [],
      this.images = const []});

  /*Map<String, dynamic> toMap() => {
        "id": id,
        "content": content,
        "time": time,
        "status": status,
        "images": images,
        "files": files
      };*/

  Map<String, dynamic> toMapSQL() => {
        "id": id,
        "content": content,
        "time": time.millisecondsSinceEpoch,
        "status": status,
      };

  Map<String, dynamic> toMap() => {
        "id": id,
        "content": content,
        "time": time,
        "status": status,
        "files": files,
        "images": images
      };

  factory Todo.fromMap(Map<String, dynamic> data) {
    return Todo(
      id: data["id"],
      content: data["content"],
      time: DateTime(data["time"]),
      status: data["status"] == 0 ? false : true,
      /*files: data["files"],
        images: data["images"]*/
    );
  }
}
