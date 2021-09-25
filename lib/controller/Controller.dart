import 'dart:convert';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import "package:get/get.dart";
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager2/manageTask/createNotification.dart';
import 'package:task_manager2/manageTask/taskForm.dart';
import 'package:task_manager2/model/modelTitle.dart';
import 'package:task_manager2/model/todo_Task.dart';

class Controller extends GetxController {
  List<TodoTitle> _title = [];
  List<TodoTask> _task = [];
  Box<TodoTitle> titleBox = Hive.box<TodoTitle>("title");
  Box<TodoTask> taskBox = Hive.box<TodoTask>("task");
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  List<TodoTitle> get listTitle => _title;

  List<TodoTask> get listTask => _task;

  GlobalKey<AnimatedListState> get listKey => _listKey;

  Controller() {
    _task = [];
    _title = [];
  }

  Map taskchange = {
    "all task": false,
    "today task": true,
    "completed task": false
  };

  ValueNotifier<double> topContainer = ValueNotifier(0);
  double _heightOfContainer = 130;

  double get heightOfContainer => _heightOfContainer;
  int _alertDateAndTime = 0;

  int get alert => _alertDateAndTime;

  setHeightOfContainer(double offset, double maxposition) {
    if (offset == maxposition) {
      _heightOfContainer = 0;
    } else if (_heightOfContainer > 0) {
      double i = maxposition / offset;
      _heightOfContainer = _heightOfContainer - _heightOfContainer / i;
      if (_heightOfContainer < 0) _heightOfContainer = 0;
    }
    update();
  }

  addHeightOfContainer(double offset, double maxposition) {
    if (offset == 0) {
      _heightOfContainer = 130;
    } else if (_heightOfContainer < 130) {
      _heightOfContainer = _heightOfContainer + 1;
    }
    update();
  }

  setalert(int value) {
    _alertDateAndTime = value;
    update();
  }

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await titleBox.clear();
    await taskBox.clear();
    titleBox.add(TodoTitle(title: "Default", id: 1, color: Colors.green.value));
    for (int i = 0; i < titleBox.values.length; i++) {
      _title.add(titleBox.getAt(i)!);
      update();
    }
    for (int i = 0; i < taskBox.values.length; i++) {
      _task.add(taskBox.getAt(i)!);
    }
    // _title.add(TodoTitle(title: "Default", id: 1, color: Colors.green.value));
    AndroidAlarmManager.initialize();
    prefs = await SharedPreferences.getInstance();
    if (!prefs!.containsKey("repeatMapKey")) {
      await prefs!.setString("repeatMapKey", json.encode({}));
    }
    _reload();
  }

  @override
  void onClose() {
    // called just before the Controller is deleted from memory
    super.onClose();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  void setTaskChange(key, value) {
    taskchange[key] = value;
    update();
  }

  insertTitle(TodoTitle title) {
    _title.add(title);
    titleBox.add(title);
    update();
  }

  // rebuilds any GetBuilder<Controller> widget
  deleteTitle(TodoTitle title) async {
    List<TodoTask> titleTask =
        _task.where((element) => element.taskTitle == title.title).toList();
    if (titleTask.length > 0)
      titleTask.forEach((element) {
        deleteTask(element);
      });
    int index = _title.indexOf(title);
    titleBox.deleteAt(index);
    _title.removeAt(index);
    update();
  }

  updateTitle(String titleName, TodoTitle oldtitle) {
    int index = _title.indexOf(oldtitle);
    List<TodoTask> titleTask =
        _task.where((element) => element.taskTitle == oldtitle.title).toList();
    titleTask.forEach((element) {
      updateTask(
          oldtasks: element,
          task: element.task,
          color: element.color,
          title: titleName,
          date: element.date,
          time: element.time,
          repeat: element.repeat);
    });
    _title[index].title = titleName;
    _title[index].save();
    //titleBox.putAt(index, _title[index]);
    update();
  }

  insertTask(TodoTask task) async {
    taskBox.add(task);
    _task.add(task);
    // insertItem(listTask, bodykey);
    update();
    CreateNotification().createNotification(task);
  }

  deleteTask(TodoTask task) {
    CreateNotification().deleteNotification(task.id!);
    int index = _task.indexOf(task);
    taskBox.delete(index);
    _task.removeWhere((element) => element.id == task.id);
    update();
  }

  updateTask(
      {TodoTask? oldtasks,
      String task = "",
      int? color,
      DateTime? date,
      String? time,
      String? title,
      Map? repeat}) {
    CreateNotification().deleteNotification(oldtasks!.id!);
    int index = _task.indexOf(oldtasks);
    _task[index].task = task;
    _task[index].taskTitle = title;
    _task[index].time = time;
    _task[index].date = date;
    _task[index].color = color;
    _task[index].repeat = repeat;

    ///we can use save as we have extend to HiveObject
    _task[index].save();
    // taskBox.putAt(index, _task[index]);
    update();

    CreateNotification().createNotification(
        _task.where((element) => element.task == task).toList().first);
  }

  changeStatus(int index) {
    _task[index].status = !_task[index].status;
    //_task[index].save();
    taskBox.putAt(index, _task[index]);
    print("status has be change");
    update();
  }

  _reload() async {
    await prefs!.reload();
  }

  formatTimeOfDay(TimeOfDay createTime) {
    final now = new DateTime.now();
    final dt = DateTime(
        now.year, now.month, now.day, createTime.hour, createTime.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }
}
