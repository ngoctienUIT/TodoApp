import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';

Widget fileListWidget(List<String> list) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: SizedBox(
      width: double.infinity,
      height: list.length * 55.0,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.fileLines,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 10),
                  Text(basename(list[index])),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}
