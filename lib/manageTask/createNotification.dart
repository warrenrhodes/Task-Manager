import 'dart:convert';
import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager2/controller/Controller.dart';
import 'package:task_manager2/main.dart';
import 'package:task_manager2/manageTask/taskForm.dart';
import 'package:task_manager2/model/todo_Task.dart';

import 'notification_service.dart';

/// Global [SharedPreferences] object.
// SharedPreferences prefs;
class CreateNotification {
  Future<int> getListOfPendingNotificationRequest() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotificationRequests.length;
  }

  createNotification(TodoTask task) {
    if (task.repeat!.containsKey("Day")) {
      int _data = task.repeat!['Day'][0];
      DateTime startOnOfDate = task.repeat!['Day'][1];
      TimeOfDay time = TaskForm.stringToTimeOfDay(task.repeat!['Day'][2]);
      int id = Random().nextInt(pow(2, 31).toInt());
      final taskrepeat = {"task": task.task, "key": "Day", "id": id};
      final list =
          json.decode(prefs!.get("listOfAlarmNotification").toString());
      list.add(taskrepeat);
      prefs!.setString('listOfAlarmNotification', json.encode(list));
      prefs!.setString('repeatMapKey', json.encode(list));
      AndroidAlarmManager.periodic(
          Duration(days: _data), id, callbackDispatcher,
          startAt: DateTime(startOnOfDate.year, startOnOfDate.month,
              startOnOfDate.day, time.hour, time.minute));
    } else if (task.repeat!.containsKey("Week")) {
      int _data = task.repeat!['Week'][0];
      int id = Random().nextInt(pow(2, 31).toInt());
      List<String> validay = task.repeat!["Week"][1];
      DateTime startOnOfDate = task.repeat!["Week"][2];
      TimeOfDay time = TaskForm.stringToTimeOfDay(task.repeat!['Week'][3]);
      DateTime delay = DateTime(startOnOfDate.year, startOnOfDate.month,
          startOnOfDate.day, time.hour, time.minute);
      final taskrepeat = {
        "task": task.task,
        "listOfNextNotificationDay": validay,
        "key": "Week",
        "id": id
      };
      final list =
          json.decode(prefs!.get("listOfAlarmNotificationOfWeek").toString());
      list.add(taskrepeat);
      prefs!.setString('listOfAlarmNotificationOfWeek', json.encode(list));
      prefs!.setString('repeatMapKey', json.encode(list));
      AndroidAlarmManager.periodic(
          Duration(days: 7 * _data), id, callbackDispatcher,
          startAt: delay);
    } else if (task.repeat!.containsKey("Month")) {
      int _data = task.repeat!['Month'][0];
      String _rangeOfDayForMonth = task.repeat!['Month'][1];
      String _validWeekOfMonth = task.repeat!['Month'][2];
      String _startOnOfMonth = task.repeat!['Month'][3];
      TimeOfDay time = TaskForm.stringToTimeOfDay(task.repeat!['Month'][4]);
      int id = Random().nextInt(pow(2, 31).toInt());
      final taskrepeat = {
        "task": task.task,
        "key": "Month",
        "rangeOfDayForMonth": _rangeOfDayForMonth,
        "validWeekOfMonth": _validWeekOfMonth,
        "time": time,
        "id": id
      };
      final list =
          json.decode(prefs!.get("listOfAlarmNotificationOfMonth").toString());
      list.add(taskrepeat);
      prefs!.setString('listOfAlarmNotificationOfMonth', json.encode(list));
      prefs!.setString('repeatMapKey', json.encode(list));
      AndroidAlarmManager.periodic(
          Duration(days: 31 * _data), id, callbackDispatcher,
          startAt: DateTime(
              DateTime.now().year,
              TaskForm.month(_startOnOfMonth),
              DateTime.now().day,
              time.hour,
              time.minute));
    } else if (task.repeat!.containsKey("Year")) {
      int _data = task.repeat!['Year'][0];
      DateTime startOnOfDate = task.repeat!['Year'][1];
      TimeOfDay time = TaskForm.stringToTimeOfDay(task.repeat!['Year'][2]);
      int id = task.id!;
      final taskrepeat = {"task": task.task, "key": "Year", "id": id};
      final list =
          json.decode(prefs!.get("listOfAlarmNotificationOfYears").toString());
      list.add(taskrepeat);
      prefs!.setString('listOfAlarmNotificationOfYears', json.encode(list));
      prefs!.setString('repeatMapKey', json.encode(list));
      AndroidAlarmManager.periodic(
          Duration(days: _data * 365), id, callbackDispatcher,
          startAt: DateTime(startOnOfDate.year, startOnOfDate.month,
              startOnOfDate.day, time.hour, time.minute));
    } else {
      if ((task.date!.year == DateTime.now().year &&
              task.date!.month == DateTime.now().month &&
              task.date!.day == DateTime.now().day) &&
          (TaskForm.stringToTimeOfDay(task.time!).hour ==
                  TimeOfDay.now().hour &&
              TaskForm.stringToTimeOfDay(task.time!).minute ==
                  TimeOfDay.now().minute)) {
      } else {
        DateTime startOnOfDate = task.date!;
        TimeOfDay time = TaskForm.stringToTimeOfDay(task.time!);
        NotificationService()
            .singleNotification(task.task, time, startOnOfDate, task.id!);
      }
    }
  }

  deleteNotification(int id , String taskName) {
    flutterLocalNotificationsPlugin.cancel(id);
    AndroidAlarmManager.cancel(id);
    Get.find<Controller>().deleteForSharePreference(taskName);
  }

  static callbackDispatcher(int id) async {
    await NotificationService().init();
    final prefs = await SharedPreferences.getInstance();
    // get the current map values
    await prefs.reload();
    final repeat = json.decode(prefs.getString('repeatMapKey')!);
    final repeate = repeat.where((element) => element["id"] == id).toList();
    final repeats = repeate[0];
    switch (repeats["key"]) {
      case "Day":
        NotificationService()
            .zonedScheduleEveryDay(task: repeats["task"], id: repeats["id"]);
        break;
      case "Week":
        NotificationService().zonedScheduleForWeek(
            task: repeats["task"],
            listOfNextNotificationDay: repeats["listOfNextNotificationDay"],
            id: repeats["id"]);
        break;
      case "Month":
        NotificationService().zonedScheduleForMonth(
            task: repeats["task"],
            rangeOfDayForMonth: repeats["rangeOfDayForMonth"],
            time: repeats["time"],
            validWeekOfMonth: repeats["validWeekOfMonth"],
            id: repeats["id"]);
        break;
      default:
        NotificationService()
            .zonedScheduleEveryYear(task: repeats["task"], id: repeats["id"]);
    }
  } //the callback for our alarm
}
