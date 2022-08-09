import 'package:todo_app/model/todo_database.dart';
import 'package:todo_app/page/home/bloc/todo_event.dart';
import 'package:todo_app/page/home/bloc/todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<AddEvent>((event, emit) async {
      TodoDatabase todoDatabase = TodoDatabase();
      await todoDatabase.insertTodo(event.todo);
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
