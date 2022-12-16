import 'package:flutter/material.dart';
import 'package:restaurant/utils/shared_preferences_helper.dart';

class SharedPreferencesProvider extends ChangeNotifier {
  late SharedPreferencesHelper preferencesHelper;

  bool _isDailyRestoActive = false;
  bool get isDailyRestoActivate => _isDailyRestoActive;

  SharedPreferencesProvider({required this.preferencesHelper}) {
    _getDailyRestoPreferences();
  }

  void _getDailyRestoPreferences() async {
    _isDailyRestoActive = await preferencesHelper.isDailyRestoActivated;
    notifyListeners();
  }

  void enableDailyResto(bool value) {
    preferencesHelper.setDailyResto(value);
    _getDailyRestoPreferences();
  }
}