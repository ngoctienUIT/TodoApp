import 'package:todo_app/model/data_sql.dart';
import 'package:todo_app/model/todo_database.dart';
import 'package:todo_app/page/home/bloc/todo_event.dart';
import 'package:todo_app/page/home/bloc/todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<AddEvent>((event, emit) async {
      TodoDatabase todoDatabase = TodoDatabase();
      await todoDatabase.insertTodo(event.todo);
      for (var image in event.todo.images) {
        TodoDatabase().insertImage(
            DataSql(id: const Uuid().v1(), idTodo: event.todo.id, link: image));
      }
      for (var file in event.todo.files) {
        TodoDatabase().insertFile(
            DataSql(id: const Uuid().v1(), idTodo: event.todo.id, link: file));
      }
      emit(Success(list: await todoDatabase.getData()));
    });
    on<DeleteEvent>((event, emit) async {
      emit(Success(list: await TodoDatabase().getData()));
    });
    on<UpdateEvent>((event, emit) async {
      emit(Success(list: await TodoDatabase().getData()));
    });
  }
}
