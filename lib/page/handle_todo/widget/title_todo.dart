import 'package:flutter/material.dart';
import 'package:todo_app/values/app_styles.dart';

Widget titleTodo(
    {required TextEditingController titleController,
    required Function action}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: titleController,
            style: AppStyles.h3,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelStyle: AppStyles.h3,
              hintStyle: AppStyles.h3,
              hintText: 'Title',
            ),
            maxLines: 1,
          ),
        ),
      ),
      InkWell(
        onTap: () {
          action();
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromRGBO(182, 190, 224, 0.5),
              ),
              borderRadius: BorderRadius.circular(90)),
          child: const Icon(Icons.close_rounded),
        ),
      ),
      const SizedBox(width: 30),
    ],
  );
}
