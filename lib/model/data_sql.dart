class DataSql {
  String id;
  String idTodo;
  String link;

  DataSql({required this.id, required this.idTodo, required this.link});

  Map<String, dynamic> toMap() => {"id": id, "idTodo": idTodo, "link": link};

  factory DataSql.fromMap(Map<String, dynamic> data) =>
      DataSql(id: data["id"], idTodo: data["idTodo"], link: data["link"]);
}
