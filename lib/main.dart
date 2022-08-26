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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  int locale = 0;
  await SharedPreferences.getInstance()
      .then((preferences) => locale = preferences.getInt("language") ?? 0);
  runApp(MyApp(locale: locale));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.locale}) : super(key: key);
  final int locale;

  @override
  Widget build(BuildContext context) {
    Locale? localization = LocalizationService.getLocaleFromLanguage(
        langCode: LocalizationService.langCodes[locale]);
    return BlocProvider(
      create: (context) => TodoBloc(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        locale: localization, //LocalizationService.locale,
        fallbackLocale: LocalizationService.fallbackLocale,
        translations: LocalizationService(),
        // initialRoute: AppRoute.routeHomeScreen(),
        // initialBinding: AppBinding(),
        // getPages: AppRoute.generateGetPages(),
        home: const HomePage(),
      ),
    );
  }
}
