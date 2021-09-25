import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import "package:hive/hive.dart";
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager2/model/modelTitle.dart';
import 'package:task_manager2/myhomepage.dart';

import 'MyApplicatoinControllerBinding.dart';
import 'manageTask/notification_service.dart';
import 'manageTask/taskForm.dart';
import 'model/todo_Task.dart';
import 'provider/dartThemePorvider.dart';
import 'theme/themedadta.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  NotificationService().closeAllNotification();
  prefs = await SharedPreferences.getInstance();
  prefs!.setString("listOfAlarmNotification", json.encode([]));
  prefs!.setString("listOfAlarmNotificationOfWeek", json.encode([]));
  prefs!.setString("listOfAlarmNotificationOfMonth", json.encode([]));
  prefs!.setString("listOfAlarmNotificationOfYears", json.encode([]));
  prefs!.setString("listOfTaskForTest", json.encode([]));
  //hive for task
  final taskDocument = await getApplicationDocumentsDirectory();
  Hive.init(taskDocument.path);
  Hive.registerAdapter<TodoTask>(TodoTaskAdapter());
  await Hive.openBox<TodoTask>("task");
// hive for title
//   final document = await getApplicationDocumentsDirectory();
//   Hive.init(document.path);
  Hive.registerAdapter<TodoTitle>(TodoTitleAdapter());
  await Hive.openBox<TodoTitle>("title");
  MyAppControllerBinding().dependencies();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DarkThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  NotificationAppLaunchDetails? notificationAppLaunchDetails;
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    localNotification();
  }

  Future<void> localNotification() async {
    notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.setdarkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Styles.themeData(themeChange.darkTheme, context),
      home: Myhomepage(),
    );
  }
}
