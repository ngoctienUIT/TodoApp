import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget customPopupRemind(Function(int) action, int index) {
  List<String> remindList = [
    "Không Lặp",
    "1 Phút",
    "5 Phút",
    "10 Phút",
    "15 phút",
    "30 phút",
    "1 giờ"
  ];
  return PopupMenuButton(
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
          child: const Text("1 Phút")),
      PopupMenuItem(
          onTap: () {
            action(2);
          },
          child: const Text("5 Phút")),
      PopupMenuItem(
          onTap: () {
            action(3);
          },
          child: const Text("10 Phút")),
      PopupMenuItem(
          onTap: () {
            action(4);
          },
          child: const Text("15 Phút")),
      PopupMenuItem(
          onTap: () {
            action(4);
          },
          child: const Text("30 Phút")),
      PopupMenuItem(
          onTap: () {
            action(4);
          },
          child: const Text("1 Giờ")),
    ],
    child: Container(
      padding: const EdgeInsets.all(15),
      height: 65,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: const Color.fromRGBO(182, 190, 224, 1)),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(FontAwesomeIcons.bell,
              color: Color.fromRGBO(182, 190, 224, 1)),
          const SizedBox(width: 10),
          Text(
            remindList[index],
            style: const TextStyle(color: Color.fromRGBO(182, 190, 224, 1)),
          )
        ],
      ),
    ),
  );
}
