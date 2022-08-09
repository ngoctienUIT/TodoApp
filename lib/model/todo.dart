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

  Map<String, dynamic> toMap() => {
        "id": id,
        "content": content,
        "time": 123,
        "status": status,
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
