import 'package:flutter/material.dart';

void modalBottomSheetMenu(BuildContext context,
    {required List<String> list,
    required Function(int) action,
    int index = 0}) {
  FixedExtentScrollController mainController =
      FixedExtentScrollController(initialItem: index);
  int position = mainController.initialItem;
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (builder) {
        return Container(
          height: 200,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: StatefulBuilder(builder: (context, setState) {
            return ListWheelScrollView(
              itemExtent: 50,
              perspective: 0.005,
              diameterRatio: 1.2,
              controller: mainController,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (value) {
                action(value);
                setState(() {
                  position = value;
                });
              },
              children: List.generate(
                list.length,
                (index) => Text(
                  list[index],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: index == position ? Colors.red : Colors.black,
                  ),
                ),
              ),
            );
          }),
        );
      });
}
