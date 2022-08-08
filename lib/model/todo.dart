class Todo {
  String id;
  String content;
  DateTime time;
  List<String> images;
  List<String> files;

  Todo(
      {required this.id,
      required this.content,
      required this.time,
      required this.files,
      required this.images});

  Map<String, dynamic> toMap() => {
        "id": id,
        "content": content,
        "time": time,
        "images": images,
        "files": files
      };
}
