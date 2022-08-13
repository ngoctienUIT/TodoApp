import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails("channel id", "channel name",
          importance: Importance.max,
          channelDescription: "channel description"),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future showNotification(
      {int id = 0,
      String title = "",
      String body = "",
      String payload = ""}) async {
    _notification.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }
}
