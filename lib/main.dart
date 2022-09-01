import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/page/home/bloc/todo_bloc.dart';
import 'package:todo_app/page/home/home_page.dart';
import 'package:todo_app/resources/localization_service.dart';
import 'package:todo_app/themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  int locale = 0;
  bool isDartMode = false;
  await SharedPreferences.getInstance().then((preferences) {
    locale = preferences.getInt("language") ?? 0;
    isDartMode = preferences.getBool("dartMode") ?? false;
  });
  runApp(MyApp(locale: locale, isDartMode: isDartMode));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.locale, required this.isDartMode})
      : super(key: key);
  final int locale;
  final bool isDartMode;

  @override
  Widget build(BuildContext context) {
    Locale? localization = LocalizationService.getLocaleFromLanguage(
        langCode: LocalizationService.langCodes[locale]);
    return BlocProvider(
      create: (context) => TodoBloc(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        theme: Themes.lightTheme,
        darkTheme: Themes.dartTheme,
        themeMode: isDartMode ? ThemeMode.dark : ThemeMode.light,
        locale: localization, //LocalizationService.locale,
        fallbackLocale: LocalizationService.fallbackLocale,
        translations: LocalizationService(),
        // initialRoute: AppRoute.routeHomeScreen(),
        // initialBinding: AppBinding(),
        // getPages: AppRoute.generateGetPages(),
        home: HomePage(locale: localization!.toString()),
      ),
    );
  }
}
