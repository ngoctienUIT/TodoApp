import 'package:flutter/material.dart';
import 'package:todo_app/values/app_colors.dart';
import 'package:todo_app/values/app_styles.dart';

class Themes {
  final lightTheme = ThemeData.light().copyWith(
    backgroundColor: AppColors.backgroundColorLight,
    bottomSheetTheme:
        BottomSheetThemeData(backgroundColor: AppColors.backgroundColorLight),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundColorLight,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: AppStyles.h3.copyWith(
        color: const Color.fromRGBO(156, 166, 201, 1),
      ),
      iconTheme: const IconThemeData(
        color: Color.fromRGBO(159, 161, 184, 1),
        size: 25,
      ),
    ),
    textTheme: const TextTheme(
      headline5: TextStyle(
        color: Color.fromRGBO(182, 190, 224, 1),
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
      titleTextStyle: AppStyles.h3.copyWith(color: Colors.white),
      iconTheme: const IconThemeData(
        color: Colors.white,
        size: 25,
      ),
    ),
    textTheme: const TextTheme(
      headline5: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}
