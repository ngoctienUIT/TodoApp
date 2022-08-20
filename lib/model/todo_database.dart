import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/data_sql.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/page/handle_todo/pick_function.dart';
import 'package:uuid/uuid.dart';

class TodoDatabase {
  Future<Database> initializeDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (database, version) async {
        database.execute('''create table Todo (
              id text, code integer, 
              title text, content text, 
              remind integer, repeat integer, 
              date text, startTime text, finishTime text, 
              status bool, color integer)''');

        database
            .execute("create table Image (id text, idTodo text, link text)");

        database.execute("create table File (id text, idTodo text, link text)");
      },
      version: 1,
    );
  }

  Future<int> insertTodo(Todo todo) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.insert("Todo", todo.toMapSQL());
    // db.close();
    return result;
  }

  Future<int> insertListTodo(List<Todo> todoList) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var todo in todoList) {
      result = await db.insert("Todo", todo.toMapSQL());
    }
    // db.close();
    return result;
  }

  Future<List<Todo>> getData() async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult =
        await db.query("Todo", orderBy: "date, startTime");
    // db.close();
    return queryResult.map((todo) => Todo.fromMapSQL(todo)).toList();
  }

  Future<int> deleteTodo(String id) async {
    final db = await initializeDB();
    return await db.delete(
      "Todo",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future deleteAll() async {
    final db = await initializeDB();
    await db.rawDelete("Delete * from Todo");
  }

  Future<int> updateTodo(Todo todo) async {
    final db = await initializeDB();
    int updateCount = await db.rawUpdate('''
    UPDATE Todo 
    SET title = ?, content = ?, status = ?, date = ?, startTime = ?, finishTime = ?, color = ?, remind = ?, repeat = ?
    WHERE id = ?''', [
      todo.title,
      todo.content,
      todo.status,
      DateFormat("dd/MM/yyyy").format(todo.date),
      timeOfDateToString(todo.startTime),
      timeOfDateToString(todo.finishTime),
      todo.color.value,
      todo.remind,
      todo.repeat,
      todo.id
    ]);
    return updateCount;
  }

  //Image

  Future<int> insertImage(DataSql imageSql) async {
    int result = 0;
    final Database db = await initializeDB().then((value) {
      return value;
    });
    result = await db.insert("Image", imageSql.toMap());
    // db.close();
    return result;
  }

  Future<int> insertListImage(List<String> imageList, String idTodo) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var image in imageList) {
      result = await db.insert("Image",
          DataSql(id: const Uuid().v1(), idTodo: idTodo, link: image).toMap());
    }
    // db.close();
    return result;
  }

  Future<List<DataSql>> getImageData(String idTodo) async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult =
        await db.rawQuery('SELECT * FROM Image WHERE idTodo = ?', [idTodo]);
    // final List<Map<String, dynamic>> queryResult = await db.query("Image");
    // db.close();
    return queryResult.map((image) => DataSql.fromMap(image)).toList();
  }

  Future<int> deleteImage(String id) async {
    final db = await initializeDB();
    return await db.delete(
      "Image",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future deleteImageAll(String idTodo) async {
    final db = await initializeDB();
    await db.rawDelete("Delete * from Image");
  }

  // File
  Future<int> insertFile(DataSql imageSql) async {
    int result = 0;
    final Database db = await initializeDB().then((value) {
      return value;
    });
    result = await db.insert("File", imageSql.toMap());
    // db.close();
    return result;
  }

  Future<int> insertListFile(List<String> imageList, String idTodo) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var image in imageList) {
      result = await db.insert("File",
          DataSql(id: const Uuid().v1(), idTodo: idTodo, link: image).toMap());
    }
    // db.close();
    return result;
  }

  Future<List<DataSql>> getFileData(String idTodo) async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult =
        await db.rawQuery('SELECT * FROM File WHERE idTodo = ?', [idTodo]);
    // final List<Map<String, dynamic>> queryResult = await db.query("Image");
    // db.close();
    return queryResult.map((image) => DataSql.fromMap(image)).toList();
  }

  Future<int> deleteFile(String id) async {
    final db = await initializeDB();
    return await db.delete(
      "File",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future deleteFileAll(String idTodo) async {
    final db = await initializeDB();
    await db.rawDelete("Delete * from Image");
  }
}
