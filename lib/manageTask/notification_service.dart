import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../controller/Controller.dart';
import '../main.dart';
import 'taskForm.dart';

class NotificationService {
  static const String groupKey = 'com.android.example.task_manager2';
  static const String groupChannelId = 'task managerId';
  static const String groupChannelName = 'task managerName';
  static const String groupChannelDescription =
      'task manager decription of any task';
  static const AndroidNotificationDetails firstNotificationAndroidSpecifics =
      AndroidNotificationDetails(
          groupChannelId, groupChannelName, groupChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
          icon: "tt",
          largeIcon: DrawableResourceAndroidBitmap("dd"),
          groupKey: groupKey);
  static const NotificationDetails firstNotificationPlatformSpecifics =
      NotificationDetails(android: firstNotificationAndroidSpecifics);
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }
//initialise the notification
  Future<void> init() async {
    await configureLocalTimeZone();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('dd');
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, macOS: null);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');

        await Get.put(Controller()).changeStatus(Get.put(Controller())
            .listTask
            .indexWhere((element) => element.task == payload));
      }
    });
  }

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }

  //single notification
  Future<void> singleNotification(
      String task, TimeOfDay time, DateTime date, int id) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        "$task",
        "Mark As Completed",
        tz.TZDateTime.local(
            date.year, date.month, date.day, time.hour, time.minute),
        firstNotificationPlatformSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        androidAllowWhileIdle: true,
        payload: "$task");
  }

//sent notification which intervale day specify by user
  Future<void> zonedScheduleEveryDay({String? task, int? id}) async {
    await flutterLocalNotificationsPlugin.show(
        id!, task, "Mark As Completed", firstNotificationPlatformSpecifics);
  }

//repeat notification every week
  Future<void> zonedScheduleForWeek(
      {String? task,
      DateTime? date,
      var listOfNextNotificationDay,
      TimeOfDay? time,
      int? id}) async {
    final prefs = await SharedPreferences.getInstance();
    final list = json.decode(prefs.getString("listOfTaskForTest")!);
    if (!list.contains(task)) {
      await flutterLocalNotificationsPlugin.show(
          id!, task, "Mark As Completed", firstNotificationPlatformSpecifics);
      list.add(task);
      prefs.setString("listOfTaskForTest", json.encode(list));
    }
    for (var i = 0; i < listOfNextNotificationDay.length; i++) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          id!,
          task,
          "${DateFormat("EE, d MMM yyyy").format(date!)} \n ${formatTimeOfDay(time!)}",
          _nextInstanceOfWeekTime(listOfNextNotificationDay[i], time),
          firstNotificationPlatformSpecifics,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.wallClockTime,
          androidAllowWhileIdle: true);
    }
  }

  //Notification Of month
  Future<void> zonedScheduleForMonth(
      {String task = "",
      String validWeekOfMonth = "",
      TimeOfDay? time,
      int id = 0,
      String rangeOfDayForMonth = ""}) async {
    switch (rangeOfDayForMonth) {
      case "First":
        await monthNotification(task, time!, validWeekOfMonth, "First", id);
        break;
      case "Second":
        await monthNotification(task, time!, validWeekOfMonth, "Second", id);
        break;
      case "Third":
        await monthNotification(task, time!, validWeekOfMonth, "Third", id);
        break;
      case "Fourth":
        await monthNotification(task, time!, validWeekOfMonth, "Fourth", id);
        break;
      default:
        await monthNotification(task, time!, validWeekOfMonth, "Last", id);
    }
  }

  Future<void> monthNotification(String task, TimeOfDay time,
      String validWeekOfMonth, String rangeOfDayForMonth, int id) async {
    List listday = [];
    tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local);
    for (int i = 1;
        i <=
            tz.TZDateTime(tz.local, scheduledDate.year, scheduledDate.month, 0)
                .day;
        i++) {
      if (DateTime(scheduledDate.year, scheduledDate.month, i).weekday ==
          TaskForm.week(validWeekOfMonth)) {
        listday.add(tz.TZDateTime(
            tz.local, scheduledDate.year, scheduledDate.month, i));
      }
    }
    if (rangeOfDayForMonth == "First")
      scheduledDate =
          listday.first.add(Duration(hours: time.hour, minutes: time.minute));
    else if (rangeOfDayForMonth == "Second")
      scheduledDate = listday
          .elementAt(1)
          .add(Duration(hours: time.hour, minutes: time.minute));
    else if (rangeOfDayForMonth == "Third")
      scheduledDate = listday
          .elementAt(2)
          .add(Duration(hours: time.hour, minutes: time.minute));
    else if (rangeOfDayForMonth == "Fourth")
      scheduledDate = listday
          .elementAt(3)
          .add(Duration(hours: time.hour, minutes: time.minute));
    else
      scheduledDate =
          listday.last.add(Duration(hours: time.hour, minutes: time.minute));
    await flutterLocalNotificationsPlugin.zonedSchedule(id, task,
        "Mark As Completed", scheduledDate, firstNotificationPlatformSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        androidAllowWhileIdle: true);
  }

  // Notification of years
  Future<void> zonedScheduleEveryYear({String task = "", int id = 0}) async {
    await flutterLocalNotificationsPlugin.show(
        id, task, "Mark As Completed", firstNotificationPlatformSpecifics);
  }

  tz.TZDateTime _nextInstanceOfTenAM(TimeOfDay time) {
    // tz.TZDateTime.local(startOnOfDate.year, startOnOfDate.month, startOnOfDate.day, time.hour, time.minute).toLocal();
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfWeekTime(String weekday, TimeOfDay time) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTenAM(time);
    while (scheduledDate.weekday != TaskForm.week(weekday)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> closeAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  //return the int of any week day

  formatTimeOfDay(TimeOfDay createTime) {
    final now = new DateTime.now();
    final dt = DateTime(
        now.year, now.month, now.day, createTime.hour, createTime.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  NotificationService._internal();
}

// import 'dart:convert';
// import 'dart:ffi';
// import 'dart:math';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:task_manager2/myhomepage.dart';
// import 'model/todo_Task.dart';
// import 'package:get/get.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;
// class NotificationService {
//   Future<void> init() async {
//     AwesomeNotifications().initialize(null, [
//       NotificationChannel(
//           channelKey: 'key1',
//           importance: NotificationImportance.Max,
//           channelName: 'Notification',
//           channelDescription: "Notification example",
//           defaultColor: Color(0XFF9050DD),
//           ledColor: Colors.white,
//           playSound: true,
//           enableLights: true,
//           enableVibration: true)
//     ]);
//     await configureLocalTimeZone();
//   }
//   static final NotificationService _notificationService =
//   NotificationService._internal();
//   factory NotificationService() {
//     return _notificationService;
//   }
//   //configure a time zone
//   Future<void> configureLocalTimeZone() async {
//     tz.initializeTimeZones();
//     final String currentTimeZone =
//         await FlutterNativeTimezone.getLocalTimezone();
//     tz.setLocalLocation(tz.getLocation(currentTimeZone));
//   }
//   //sent notification which intervale day specify by user
//   Future<void> zonedScheduleEveryDay(
//       {String task}) async {
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id:  Random().nextInt(pow(2, 10)),
//         icon: 'resource://drawable/tt',
//         largeIcon: 'resource://drawable/dd',
//         channelKey: 'key1',
//         title: task,
//         body:
//         "${DateFormat("EE, d MMM yyyy").format(DateTime.now())} \n ${formatTimeOfDay(TimeOfDay.now())}",
//         displayOnBackground: true,
//         displayOnForeground: true,
//       ),
//       actionButtons: [
//         new NotificationActionButton(
//           buttonType: ActionButtonType.Default,
//           key: "button",
//           enabled: true,
//           label: "Completed the task ",
//         ),
//       ],
//     );
//   }
//   //repeat notification every week
//   Future<void> zonedScheduleForWeek(
//       {String task,
//       DateTime date,
//       var listOfNextNotificationDay,
//       TimeOfDay time}) async {
//     final prefs = await SharedPreferences.getInstance();
//     final list = json.decode(prefs.getString("listOfTaskForTest"));
//     if (!list.contains(task )){
//       await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//           id:  Random().nextInt(pow(2, 10)),
//           icon: 'resource://drawable/tt',
//           largeIcon: 'resource://drawable/dd',
//           channelKey: 'key1',
//           title: task,
//           body:
//           "${DateFormat("EE, d MMM yyyy").format(date)} \n ${formatTimeOfDay(time)}",
//           displayOnBackground: true,
//           displayOnForeground: true,
//         ),
//         actionButtons: [
//           new NotificationActionButton(
//             buttonType: ActionButtonType.Default,
//             key: "button",
//             enabled: true,
//             label: "Completed the task ",
//           ),
//         ],
//       );
//       list.add(task);
//       prefs.setString("listOfTaskForTest", json.encode(list));
//     }
//     for(var i=0; i<listOfNextNotificationDay.length; i++){
//       await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//           id:  Random().nextInt(pow(2, 10)),
//           icon: 'resource://drawable/tt',
//           largeIcon: 'resource://drawable/dd',
//           channelKey: 'key1',
//           title: task,
//           body:
//           "${DateFormat("EE, d MMM yyyy").format(date)} \n ${formatTimeOfDay(time)}",
//           displayOnBackground: true,
//           displayOnForeground: true,
//         ),
//         actionButtons: [
//           new NotificationActionButton(
//             buttonType: ActionButtonType.Default,
//             key: "button",
//             enabled: true,
//             label: "Completed the task ",
//           ),
//         ],
//         schedule: NotificationCalendar.fromDate(date: _nextInstanceOfWeekTime(listOfNextNotificationDay[i], time), allowWhileIdle: true),
//       );
//     }
//   }
// //Notification Of month
//   Future<void> zonedScheduleForMonth(
//       {String task, String validWeekOfMonth, TimeOfDay time, String rangeOfDayForMonth}) async {
//     DateTime date = DateTime.now();
//     switch (rangeOfDayForMonth){
//       case "First":
//         await monthNotification(task, date, time, validWeekOfMonth, "First");
//         break;
//       case "Second":
//         await monthNotification(task, date, time, validWeekOfMonth, "Second");
//         break;
//       case "Third":
//         await monthNotification(task, date, time, validWeekOfMonth, "Third");
//         break;
//       case "Fourth":
//         await monthNotification(task, date, time, validWeekOfMonth, "Fourth");
//         break;
//       default:
//         await monthNotification(task, date, time, validWeekOfMonth, "Last");
//     }
//   }
//   Future<void> monthNotification(String task, DateTime date, TimeOfDay time, String validWeekOfMonth, String rangeOfDayForMonth) async {
//     List listday =[];
//     tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local);
//     for (int i = 1; i <= tz.TZDateTime(tz.local, scheduledDate.year, scheduledDate.month, 0).day; i++){
//       if( DateTime(scheduledDate.year, scheduledDate.month, i).weekday == week(validWeekOfMonth))  {
//         listday.add( tz.TZDateTime(tz.local, scheduledDate.year, scheduledDate.month, i));
//       }
//     }
//     if(rangeOfDayForMonth == "First") scheduledDate = listday.first.add(Duration(hours: time.hour, minutes:time.minute));
//     else if (rangeOfDayForMonth == "Second") scheduledDate = listday.elementAt(1).add(Duration(hours: time.hour, minutes:time.minute));
//     else if (rangeOfDayForMonth == "Third") scheduledDate = listday.elementAt(2).add(Duration(hours: time.hour, minutes:time.minute));
//     else if(rangeOfDayForMonth == "Fourth") scheduledDate = listday.elementAt(3).add(Duration(hours: time.hour, minutes:time.minute));
//     else scheduledDate = listday.last.add(Duration(hours: time.hour, minutes:time.minute));
//     await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//           id:  Random().nextInt(pow(2, 10)),
//           icon: 'resource://drawable/tt',
//           largeIcon: 'resource://drawable/dd',
//           channelKey: 'key1',
//           title: task,
//           body: "${DateFormat("EE, d MMM yyyy").format(date)} \n ${formatTimeOfDay(time)}",
//           displayOnBackground: true,
//           displayOnForeground: true,
//         ),
//         actionButtons: [
//           new NotificationActionButton(
//             buttonType: ActionButtonType.Default,
//             key: "button",
//             enabled: true,
//             label: "Completed the task ",
//           ),
//         ],
//         schedule: NotificationCalendar.fromDate(date: scheduledDate,)
//     );
//   }
//   // Notification of years
//   Future<void> zonedScheduleEveryYear(
//     {String task}) async {
//     await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//           id:  Random().nextInt(pow(2, 10)),
//           icon: 'resource://drawable/tt',
//           largeIcon: 'resource://drawable/dd',
//           channelKey: 'key1',
//           title: task,
//           body: "${DateFormat("EE, d MMM yyyy").format(DateTime.now())} \n ${formatTimeOfDay(TimeOfDay.now())}",
//           displayOnBackground: true,
//           displayOnForeground: true,
//         ),
//         actionButtons: [
//           new NotificationActionButton(
//             buttonType: ActionButtonType.Default,
//             key: "button",
//             enabled: true,
//             label: "Completed the task ",
//           ),
//         ],
//     );
//   }
// //single notification
//   Future<void> singleNotification(String task, TimeOfDay time, DateTime date) async {
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id:  Random().nextInt(pow(2, 10)),
//         icon: 'resource://drawable/tt',
//         largeIcon: 'resource://drawable/dd',
//         channelKey: 'key1',
//         title: task,
//         body: "${DateFormat("EE, d MMM yyyy").format(date)} \n ${formatTimeOfDay(time)}",
//         displayOnBackground: true,
//         displayOnForeground: true,
//         payload: {"task":task}
//       ),
//       actionButtons: [
//         new NotificationActionButton(
//           buttonType: ActionButtonType.Default,
//           key: "button",
//           enabled: true,
//           label: "Completed the task ",
//         ),
//       ],
//       schedule: NotificationCalendar.fromDate(date: tz.TZDateTime.local(date.year, date.month, date.day, time.hour,time.minute),)
//     );
//   }
//   tz.TZDateTime _nextInstanceOfTenAM(TimeOfDay time) {
//     // tz.TZDateTime.local(startOnOfDate.year, startOnOfDate.month, startOnOfDate.day, time.hour, time.minute).toLocal();
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduledDate = tz.TZDateTime(
//         tz.local, now.year, now.month, now.day, time.hour, time.minute);
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//     return scheduledDate;
//   }
//   tz.TZDateTime _nextInstanceOfWeekTime(String weekday, TimeOfDay time) {
//     tz.TZDateTime scheduledDate = _nextInstanceOfTenAM(time);
//     while (scheduledDate.weekday != week(weekday)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//     return scheduledDate;
//   }
//   formatTimeOfDay(TimeOfDay createTime) {
//     final now = new DateTime.now();
//     final dt = DateTime(
//         now.year, now.month, now.day, createTime.hour, createTime.minute);
//     final format = DateFormat.jm(); //"6:00 AM"
//     return format.format(dt);
//   }
//   int week(String day) {
//     int i = 0;
//     switch (day) {
//       case "monday":
//         i = 1;
//         break;
//       case "tuesday":
//         i = 2;
//         break;
//       case "wednesday":
//         i = 3;
//         break;
//       case "thursday":
//         i = 4;
//         break;
//       case "friday":
//         i = 5;
//         break;
//       case "saturday":
//         i = 6;
//         break;
//       case "sunday":
//         i = 7;
//         break;
//     }
//     return i;
//   }
//   Future<void> closeAllNotification() async {
//     await AwesomeNotifications().cancelAll();
//   }
