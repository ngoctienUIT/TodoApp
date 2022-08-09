import 'package:todo_app/model/todo.dart';

abstract class TodoState {}

class TodoInitial extends TodoState {}

class Success extends TodoState {
  List<Todo> list;
  Success({required this.list});
}
