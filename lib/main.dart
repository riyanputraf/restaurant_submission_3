import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/common/styles.dart';
import 'package:restaurant/data/api/api_service.dart';
import 'package:restaurant/data/db/db_helper.dart';
import 'package:restaurant/data/model/restaurant.dart';
import 'package:restaurant/provider/database_provider.dart';
import 'package:restaurant/provider/restaurant_provider.dart';
import 'package:restaurant/provider/schedule_provider.dart';
import 'package:restaurant/provider/shared_preferences_provider.dart';
import 'package:restaurant/ui/favorite_page.dart';
import 'package:restaurant/ui/restaurant_detail.dart';
import 'package:restaurant/ui/home_page.dart';
import 'package:restaurant/ui/restaurant_search.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/utils/notif_helper.dart';
import 'package:restaurant/utils/service_background.dart';
import 'package:restaurant/utils/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();


  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();

  await AndroidAlarmManager.initialize();
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DatabaseProvider>(
            create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper())),
        ChangeNotifierProvider<RestaurantProvider>(
            create: (_) => RestaurantProvider(apiService: ApiService())),
        ChangeNotifierProvider<ScheduleProvider>(
            create: (_) => ScheduleProvider()),
        ChangeNotifierProvider<SharedPreferencesProvider>(
          create: (_) => SharedPreferencesProvider(
            preferencesHelper: SharedPreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: primaryColor,
                onPrimary: Colors.black,
                secondary: secondaryColor,
              ),
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: myTextTheme,
          appBarTheme: const AppBarTheme(elevation: 0),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: secondaryColor,
              onPrimary: Colors.white,
              textStyle: const TextStyle(),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(0),
                ),
              ),
            ),
          ),
        ),
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
                restaurant: ModalRoute.of(context)?.settings.arguments as Restaurant,
              ),
          RestaurantSearchPage.routeName: (context) => RestaurantSearchPage(
            query: ModalRoute.of(context)?.settings.arguments as String,
          ),
          FavoritPage.routeName: (context) => const FavoritPage(),
        },
      ),
    );
  }
}
