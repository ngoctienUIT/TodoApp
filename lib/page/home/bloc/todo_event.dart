import 'package:todo_app/model/todo.dart';

abstract class TodoEvent {}

class AddEvent extends TodoEvent {
  final Todo todo;
  AddEvent({required this.todo});
}

class DeleteEvent extends TodoEvent {}

class UpdateEvent extends TodoEvent {}
