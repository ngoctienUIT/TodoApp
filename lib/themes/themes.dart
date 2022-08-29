import 'package:flutter/material.dart';
import 'package:todo_app/values/app_colors.dart';

class Themes {
  final lightTheme = ThemeData.light().copyWith(
    backgroundColor: AppColors.backgroundColorLight,
    bottomSheetTheme:
        BottomSheetThemeData(backgroundColor: AppColors.backgroundColorLight),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundColorLight,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: const TextStyle(
        color: Color.fromRGBO(156, 166, 201, 1),
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      iconTheme: const IconThemeData(
        color: Color.fromRGBO(159, 161, 184, 1),
        size: 25,
      ),
    ),
  );
  final dartTheme = ThemeData.dark().copyWith(
    backgroundColor: AppColors.backgroundColorDart,
    bottomSheetTheme:
        BottomSheetThemeData(backgroundColor: AppColors.backgroundColorDart),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundColorDart,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
        size: 25,
      ),
    ),
  );
}
