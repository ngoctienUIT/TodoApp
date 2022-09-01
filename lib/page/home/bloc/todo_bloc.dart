import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/data_sql.dart';
import 'package:todo_app/model/local_notification_manager.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/model/todo_database.dart';
import 'package:todo_app/model/todo_firebase.dart';
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

      if (event.todo.repeat > 0) {
        localNotificationManager.repeatNotification(
            id: event.todo.code - 1,
            title: event.todo.title,
            body: event.todo.content,
            repeat: getRepeatInterval(event.todo.repeat));
      }

      scheduledNotification(event.todo);

      addTodo(event.todo);
      emit(Success(list: await TodoDatabase().getData()));
    });

    on<DeleteEvent>((event, emit) async {
      removeScheduledNotification(event.todo);
      deleteTodo(event.todo);
      emit(Success(list: await TodoDatabase().getData()));
    });

    on<UpdateEvent>((event, emit) async {
      emit(Success(list: await TodoDatabase().getData()));
    });

    on<CompleteEvent>((event, emit) async {
      removeScheduledNotification(event.todo);
      if (event.todo.status) {
        LocalNotificationManager localNotificationManager =
            LocalNotificationManager.init();
        localNotificationManager.cancelNotification(event.todo.code);
        localNotificationManager.showNotification(
            id: event.todo.code - 1,
            title: "Hoàn thành",
            body: event.todo.title);
      } else {
        scheduledNotification(event.todo);
      }
    });
  }

  Future addTodo(Todo todo) async {
    if (FirebaseAuth.instance.currentUser != null) TodoFirebase.addTodo(todo);

    TodoDatabase todoDatabase = TodoDatabase();
    await todoDatabase.insertTodo(todo);
    for (var image in todo.images) {
      TodoDatabase().insertImage(
          DataSql(id: const Uuid().v1(), idTodo: todo.id, link: image));
    }

    for (var file in todo.files) {
      TodoDatabase().insertFile(
          DataSql(id: const Uuid().v1(), idTodo: todo.id, link: file));
    }
  }

  Future deleteTodo(Todo todo) async {
    if (FirebaseAuth.instance.currentUser != null) {
      TodoFirebase.deleteTodo(todo.id);
    }
    await TodoDatabase().deleteTodo(todo.id);
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

  void removeScheduledNotification(Todo todo) {
    if (todo.remind > 0) {
      DateTime dateTimeStart = addTime(todo.date, todo.startTime);
      DateTime dateTimeFinish = addTime(todo.date, todo.finishTime);
      int count = 0;

      do {
        count++;
        LocalNotificationManager localNotificationManager =
            LocalNotificationManager.init();
        localNotificationManager.cancelNotification(todo.code + count);
        dateTimeStart = dateTimeStart.add(getDuration(todo.remind));
      } while (dateTimeStart.difference(dateTimeFinish).inMinutes < 0);
    }
  }

  void scheduledNotification(Todo todo) {
    DateTime dateTimeStart = addTime(todo.date, todo.startTime);
    DateTime dateTimeFinish = addTime(todo.date, todo.finishTime);
    if (todo.remind > 0) {
      int count = 0;
      do {
        count++;
        LocalNotificationManager localNotificationManager =
            LocalNotificationManager.init();
        if (dateTimeStart.difference(DateTime.now()).inMinutes > 0) {
          localNotificationManager.scheduledNotification(
            id: todo.code + count,
            title: todo.title,
            body: todo.content,
            duration: dateTimeStart.difference(DateTime.now()),
          );
        }
        dateTimeStart = dateTimeStart.add(getDuration(todo.remind));
      } while (dateTimeStart.difference(dateTimeFinish).inMinutes < 0);
    } else if (todo.remind == 0 &&
        dateTimeStart.difference(DateTime.now()).inMinutes > 0) {
      LocalNotificationManager localNotificationManager =
          LocalNotificationManager.init();
      localNotificationManager.scheduledNotification(
        id: todo.code + 1,
        title: todo.title,
        body: todo.content,
        duration: dateTimeStart.difference(DateTime.now()),
      );
    }
  }

  DateTime addTime(DateTime date, TimeOfDay time) => date.add(
        Duration(
          hours: time.hour,
          minutes: time.minute,
        ),
      );
}
