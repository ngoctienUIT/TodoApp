import 'dart:io' show Platform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationManager {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late InitializationSettings initSetting;
  BehaviorSubject<ReceiveNotification> get didReceiveNotificationSubject =>
      BehaviorSubject<ReceiveNotification>();

  LocalNotificationManager.init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      requestIOSPermission();
    }
    initiallizePlatform();
  }

  void requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()!
        .requestPermissions(alert: true, badge: true, sound: true);
  }

  void initiallizePlatform() {
    tz.initializeTimeZones();
    var initSettingAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    var initSetiingIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) {
        ReceiveNotification notification = ReceiveNotification(
            id: id, title: title!, body: body!, payload: payload!);
        didReceiveNotificationSubject.add(notification);
      },
    );

    initSetting = InitializationSettings(
        android: initSettingAndroid, iOS: initSetiingIOS);
    flutterLocalNotificationsPlugin.initialize(initSetting);
  }

  setOnNotificationReceive(Function onNotificationReceive) {
    didReceiveNotificationSubject.listen((value) {
      onNotificationReceive(value);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(
      initSetting,
      onSelectNotification: (payload) {
        onNotificationClick(payload);
      },
    );
  }

  Future showNotification(
      {int id = 0,
      String title = "",
      String body = "",
      String payload = "payload"}) async {
    await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails("channel id", "channel name",
              importance: Importance.max,
              channelDescription: "channel description"),
          iOS: IOSNotificationDetails(),
        ),
        payload: payload);
  }

  Future scheduledNotification(
      {int id = 0,
      String title = "",
      String body = "",
      String payload = "payload",
      required Duration duration}) async {
    flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(duration),
        const NotificationDetails(
          android: AndroidNotificationDetails("channel id 1", "channel name 1",
              playSound: true,
              priority: Priority.high,
              enableLights: true,
              importance: Importance.max,
              channelDescription: "channel description 1"),
          iOS: IOSNotificationDetails(),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  Future repeatNotification(
      {int id = 0,
      String title = "",
      String body = "",
      String payload = "payload",
      RepeatInterval repeat = RepeatInterval.everyMinute}) async {
    await flutterLocalNotificationsPlugin.periodicallyShow(
        id,
        title,
        body,
        repeat,
        const NotificationDetails(
          android: AndroidNotificationDetails("channel id 2", "channel name 2",
              playSound: true,
              priority: Priority.high,
              enableLights: true,
              importance: Importance.max,
              channelDescription: "channel description 2"),
          iOS: IOSNotificationDetails(),
        ),
        payload: payload,
        androidAllowWhileIdle: true);
  }

  Future cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

class ReceiveNotification {
  int id;
  String title;
  String body;
  String payload;
  ReceiveNotification(
      {required this.id,
      required this.title,
      required this.body,
      required this.payload});
}
