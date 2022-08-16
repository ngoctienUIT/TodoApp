import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget customPopupMenu(Function(int) action, int index) {
  List<String> repeatList = [
    "Không Lặp",
    "Mỗi Phút",
    "Mỗi Giờ",
    "Mỗi Ngày",
    "Mỗi Tuần"
  ];
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 50),
    child: PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      offset: const Offset(5, 0),
      position: PopupMenuPosition.under,
      itemBuilder: (context) => [
        PopupMenuItem(
            onTap: () {
              action(0);
            },
            child: const Text("Không Lặp")),
        PopupMenuItem(
            onTap: () {
              action(1);
            },
            child: const Text("Mỗi Phút")),
        PopupMenuItem(
            onTap: () {
              action(2);
            },
            child: const Text("Mỗi Giờ")),
        PopupMenuItem(
            onTap: () {
              action(3);
            },
            child: const Text("Mỗi Ngày")),
        PopupMenuItem(
            onTap: () {
              action(4);
            },
            child: const Text("Mỗi Tuần")),
      ],
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: const Color.fromRGBO(182, 190, 224, 1)),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(FontAwesomeIcons.repeat,
                color: Color.fromRGBO(182, 190, 224, 1)),
            const SizedBox(width: 10),
            Text(
              repeatList[index],
              style: const TextStyle(color: Color.fromRGBO(182, 190, 224, 1)),
            )
          ],
        ),
      ),
    ),
  );
}
