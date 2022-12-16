import 'dart:isolate';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:restaurant/data/api/api_service.dart';
import 'package:restaurant/main.dart';
import 'package:restaurant/utils/notif_helper.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    print('Notif Triggered');
    final NotificationHelper notificationHelper = NotificationHelper();
    var result = await ApiService().listRestaurant(http.Client());
    await notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, result);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}