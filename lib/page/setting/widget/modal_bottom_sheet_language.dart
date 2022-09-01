import 'package:flutter/material.dart';
import 'package:todo_app/values/app_styles.dart';

void modalBottomSheetLanguage(BuildContext context, Function(String) action) {
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (builder) {
        return Container(
          height: 200,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  action("vi");
                },
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    Text("Tiếng Việt", style: AppStyles.h4),
                    const Spacer(),
                    Image.asset("assets/images/vietnam.png", width: 55),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  action("en");
                },
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    Text("English", style: AppStyles.h4),
                    const Spacer(),
                    Image.asset("assets/images/english.png", width: 55),
                    const SizedBox(width: 20)
                  ],
                ),
              )
            ],
          ),
        );
      });
}
