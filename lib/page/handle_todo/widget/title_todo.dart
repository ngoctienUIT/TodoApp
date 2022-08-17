import 'package:flutter/material.dart';

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
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
