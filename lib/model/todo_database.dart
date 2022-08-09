import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/todo.dart';

class TodoDatabase {
  static const String strTable = "Todo";
  static const String strId = "id";
  static const String strStatus = "status";
  static const String strContent = "content";
  static const String strTime = "time";
  static const String strImages = "images";
  static const String strFiles = "files";

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'todoapp.db'),
      onCreate: (database, version) async {
        await database.execute('''create table $strTable (
          $strId text,
          $strContent text,
          $strTime integer,
          $strStatus bool
        )''');
      },
      version: 1,
    );
  }

  Future<int> insertTodo(Todo todo) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.insert(strTable, todo.toMapSQL());
    db.close();
    return result;
  }

  Future<int> insertListTodo(List<Todo> todoList) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var todo in todoList) {
      result = await db.insert(strTable, todo.toMapSQL());
    }
    db.close();
    return result;
  }

  Future<List<Todo>> getData() async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query(strTable);
    db.close();
    return queryResult.map((todo) => Todo.fromMap(todo)).toList();
  }

  Future<int> deleteTodo(String id) async {
    final db = await initializeDB();
    return await db.delete(
      strTable,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future deleteAll() async {
    final db = await initializeDB();
    await db.rawDelete("Delete * from $strTable");
  }

  Future<int> updateTodo(Todo todo) async {
    final db = await initializeDB();
    int updateCount = await db.rawUpdate('''
    UPDATE $strTable 
    SET $strContent = ?, $strStatus = ? , $strTime = ?
    WHERE $strId = ?
    ''',
        [todo.content, todo.status, todo.time.millisecondsSinceEpoch, todo.id]);
    return updateCount;
  }
}
