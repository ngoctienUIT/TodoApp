import 'package:todo_app/model/data_sql.dart';
import 'package:todo_app/model/local_notification_manager.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/model/todo_database.dart';
import 'package:todo_app/page/home/bloc/get_repeat_interval.dart';
import 'package:todo_app/page/home/bloc/todo_event.dart';
import 'package:todo_app/page/home/bloc/todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<AddEvent>((event, emit) async {
      LocalNotificationManager localNotificationManager =
          LocalNotificationManager.init();
      localNotificationManager.showNotification(
          id: event.todo.id.hashCode,
          title: event.todo.title,
          body: event.todo.content);

      if (event.todo.repeat > 0) {
        localNotificationManager.repeatNotification(
            id: event.todo.id.hashCode - 1,
            title: event.todo.title,
            body: event.todo.content,
            repeat: getRepeatInterval(event.todo.repeat));
      }

      scheduledNotification(event.todo);

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

  Duration getDuration(int index) {
    switch (index) {
      case 1:
        return const Duration(minutes: 1);
      case 2:
        return const Duration(minutes: 5);
      case 3:
        return const Duration(minutes: 10);
      case 4:
        return const Duration(minutes: 15);
      case 5:
        return const Duration(minutes: 30);
      default:
        return const Duration(hours: 1);
    }
  }

  void scheduledNotification(Todo todo) {
    if (todo.remind > 0) {
      DateTime dateTimeStart = todo.date.add(
        Duration(
          hours: todo.startTime.hour,
          minutes: todo.startTime.minute,
        ),
      );

      DateTime dateTimeFinish = todo.date.add(
        Duration(
          hours: todo.finishTime.hour,
          minutes: todo.finishTime.minute,
        ),
      );
      int count = 0;

      do {
        count++;
        LocalNotificationManager localNotificationManager =
            LocalNotificationManager.init();
        localNotificationManager.scheduledNotification(
          id: todo.id.hashCode + count,
          title: todo.title,
          body: todo.content,
          duration: dateTimeStart.difference(DateTime.now()),
        );
        dateTimeStart = dateTimeStart.add(getDuration(todo.remind));
      } while (dateTimeStart.difference(dateTimeFinish).inMinutes < 0);
    }
  }
}
