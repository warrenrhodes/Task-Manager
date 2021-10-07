import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import "package:hive/hive.dart";
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager2/model/modelTitle.dart';
import 'package:task_manager2/myhomepage.dart';

import 'MyApplicatoinControllerBinding.dart';
import 'manageTask/notification_service.dart';
import 'manageTask/taskForm.dart';
import 'model/todo_Task.dart';
import 'theme/themeService.dart';
import 'theme/themedata.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();

  final taskDocument = await getApplicationDocumentsDirectory();
  Hive.init(taskDocument.path);
  Hive.registerAdapter<TodoTask>(TodoTaskAdapter());
  await Hive.openBox<TodoTask>("task");

  Hive.registerAdapter<TodoTitle>(TodoTitleAdapter());
  await Hive.openBox<TodoTitle>("title");
  await GetStorage.init();
  MyAppControllerBinding().dependencies();

  runApp(
    MyApp(), // Wrap your app
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  NotificationAppLaunchDetails? notificationAppLaunchDetails;
  @override
  void initState() {
    super.initState();
    localNotification();
  }

  Future<void> localNotification() async {
    notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      home: Myhomepage(),
    );
  }
}
