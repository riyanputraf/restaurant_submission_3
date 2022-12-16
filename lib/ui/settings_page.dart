import 'package:provider/provider.dart';
import 'package:restaurant/provider/schedule_provider.dart';
import 'package:restaurant/provider/shared_preferences_provider.dart';
import 'package:restaurant/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  static const String settingsTitle = 'Settings';

  const SettingsPage({Key? key}) : super(key: key);

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(settingsTitle),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(settingsTitle),
      ),
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView(
      children: [
        Material(
          child: Consumer<SharedPreferencesProvider>(
              builder: (context, provider, child) {
            return ListTile(
              title: const Text('Restaurant Notification'),
              trailing: Consumer<ScheduleProvider>(
                  builder: (context, scheduledProvider, _) {
                return Switch.adaptive(
                  value: provider.isDailyRestoActivate,
                  onChanged: (value) {
                    scheduledProvider.scheduleFavoritRestaurant(value);
                    provider.enableDailyResto(value);
                  },
                );
              }),
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
