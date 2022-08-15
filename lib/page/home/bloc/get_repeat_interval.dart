import 'package:flutter_local_notifications/flutter_local_notifications.dart';

RepeatInterval getRepeatInterval(int id) {
  switch (id) {
    case 1:
      return RepeatInterval.everyMinute;
    case 2:
      return RepeatInterval.hourly;
    case 3:
      return RepeatInterval.daily;
    default:
      return RepeatInterval.weekly;
  }
}
