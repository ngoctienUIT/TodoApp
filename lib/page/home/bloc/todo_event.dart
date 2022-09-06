import 'package:todo_app/model/todo.dart';

abstract class TodoEvent {}

class AddEvent extends TodoEvent {
  final Todo todo;
  AddEvent({required this.todo});
}

class DeleteEvent extends TodoEvent {
  final Todo todo;
  DeleteEvent({required this.todo});
}

class UpdateEvent extends TodoEvent {
  final Todo? todo;
  UpdateEvent({this.todo});
}

class CompleteEvent extends TodoEvent {
  final Todo todo;
  CompleteEvent({required this.todo});
}
