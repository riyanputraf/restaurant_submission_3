import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/utils/date_time_helper.dart';
import 'package:restaurant/utils/service_background.dart';

class ScheduleProvider extends ChangeNotifier {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  Future<bool> scheduleFavoritRestaurant(bool value) async {
    _isScheduled = value;
    if (_isScheduled) {
      print('Notification Activated');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Notification Deadactivated');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}