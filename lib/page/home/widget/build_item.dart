import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/page/home/widget/item_todo.dart';

Widget buildItem(List<Todo> todoList) {
  if (todoList.isEmpty) {
    return const Center(
        child: Text(
      "Không có dữ liệu!",
      style: TextStyle(
          fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
    ));
  }

  return ListView.builder(
    itemCount: todoList.length,
    itemBuilder: (context, index) {
      return ItemTodo(todo: todoList[index]);
    },
  );
}
