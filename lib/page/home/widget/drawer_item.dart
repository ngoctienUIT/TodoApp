import 'package:flutter/material.dart';

Widget drawerItem(
    {required IconData icon,
    required String title,
    required Function action,
    double size = 20}) {
  return InkWell(
    onTap: () {
      action();
    },
    splashColor: Colors.transparent,
    child: Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Icon(
            icon,
            size: size,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          )
        ],
      ),
    ),
  );
}
