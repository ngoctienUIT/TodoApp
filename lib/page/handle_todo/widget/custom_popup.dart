import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app/page/handle_todo/widget/modal_bottom_sheet_menu.dart';

Widget customPopup(BuildContext context,
    {required List<String> list,
    required Function(int) action,
    IconData icon = FontAwesomeIcons.bell,
    int index = 0}) {
  return InkWell(
    onTap: () {
      modalBottomSheetMenu(
        context,
        list: list,
        action: (index) {
          action(index);
        },
        index: index,
      );
    },
    child: Container(
      padding: const EdgeInsets.all(15),
      height: 65,
      width: 150,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: const Color.fromRGBO(182, 190, 224, 1)),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: const Color.fromRGBO(182, 190, 224, 1),
          ),
          const SizedBox(width: 10),
          Text(
            list[index],
            style: const TextStyle(color: Color.fromRGBO(182, 190, 224, 1)),
          )
        ],
      ),
    ),
  );
}
