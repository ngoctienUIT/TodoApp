import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/page/home/widget/item_todo.dart';
import 'package:todo_app/values/app_styles.dart';

Widget buildItem({required List<Todo> todoList, required bool filter}) {
  if (todoList.isEmpty) {
    return Center(
      child: Text(
        "Không có dữ liệu!",
        style: AppStyles.h3
            .copyWith(color: const Color.fromRGBO(156, 166, 201, 1)),
      ),
    );
  }

  return ListView.builder(
    itemCount: todoList.length,
    itemBuilder: (context, index) {
      return ItemTodo(
        todo: todoList[index],
        filter: filter,
      );
    },
  );
}
