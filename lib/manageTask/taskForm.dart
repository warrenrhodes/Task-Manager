import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager2/controller/Controller.dart';
import 'package:task_manager2/model/modelTitle.dart';

import '../model/todo_Task.dart';
import 'AddTodoTimeAndDate.dart';

/// Global [SharedPreferences] object.
SharedPreferences? prefs;

class TaskForm extends StatelessWidget {
  final TodoTask? oldtask;
  TaskForm({
    this.oldtask,
  });
  final tasks = "".obs;
  final title = "Default".obs;
  final status = false.obs;
  final keyform = GlobalKey<FormBuilderState>();
  DateTime? date;
  String? time;
  @override
  Widget build(BuildContext context) {
    Controller controller = Get.find<Controller>();
    if (oldtask != null) {
      date = oldtask!.date;
      time = oldtask!.time;
      tasks.value = oldtask!.task;
      title.value = oldtask!.taskTitle!;
      status.value = oldtask!.status;
    }
    final titleList = controller.listTitle;
    repeats = {};
    dateAndtime = {};
    // print(
    //     "${Provider.of<TodosProvider>(context, listen: false).taskList} instance of task ");
    return Scaffold(
      appBar: AppBar(
        title: Text(' Task '),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
        child: FormBuilder(
            key: keyform,
            child: SingleChildScrollView(
                child: Container(
              height: 200,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                FormBuilderTextField(
                    name: "",
                    initialValue: tasks.value,
                    decoration: InputDecoration(
                      labelText: oldtask != null ? "Update Task" : "New Task",
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    // ignore: missing_return,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return "Empty value";
                      }
                    },
                    onChanged: (value) => tasks.value = value!),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.event_available),
                        onPressed: () {
                          defineDateTimeAndRepeat(context);
                        }),
                    Container(
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: FormBuilderDropdown(
                          name: "listetitle",
                          items: titleList.map((TodoTitle title) {
                            print("-----------------------$title");
                            return DropdownMenuItem(
                                value: title.title,
                                child: Row(children: [
                                  Icon(
                                    Icons.radio_button_checked,
                                    color: Color(title.color!),
                                  ),
                                  Expanded(
                                    child: Text(
                                      " ${title.title}",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ]));
                          }).toList(),
                          enabled: true,
                          initialValue: title.value,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.1),
                                width: 2.0,
                              ),
                            ),
                          ),
                          onChanged: (value) => title.value = value.toString()),
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                          child: Text("Save",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          onPressed: () async {
                            final isvalid = keyform.currentState!.validate();
                            if (!isvalid) {
                              return;
                            } else {
                              TodoTask taske = TodoTask(
                                  task: tasks.string,
                                  taskTitle: title.string,
                                  status: status.value,
                                  id: Random().nextInt(pow(2, 31).toInt()));
                              taske.color = titleList
                                  .where((TodoTitle titles) =>
                                      titles.title == title.value)
                                  .first
                                  .color;
                              taske.date = dateAndtime.values.isNotEmpty
                                  ? dateAndtime["day"]
                                  : DateTime.now();
                              taske.time = dateAndtime.values.isNotEmpty
                                  ? formatTimeOfDay(dateAndtime["time"])
                                  : formatTimeOfDay(
                                      TimeOfDay.fromDateTime(DateTime.now()));
                              taske.repeat =
                                  dateAndtime.values.isNotEmpty ? {} : repeats;
                              if (oldtask != null) {
                                ///  updated the task
                                print("\n\n\n\n");
                                controller.updateTask(
                                  oldtasks: oldtask!,
                                  task: tasks.value,
                                  date: dateAndtime.values.isNotEmpty
                                      ? dateAndtime["day"]
                                      : date,
                                  time: dateAndtime.values.isNotEmpty
                                      ? formatTimeOfDay(dateAndtime["time"])
                                      : time,
                                  title: title.value,
                                  color: titleList
                                      .where((TodoTitle? titles) =>
                                          titles!.title == title.value)
                                      .first
                                      .color!,
                                  repeat: dateAndtime.values.isNotEmpty
                                      ? {}
                                      : repeats,
                                );
                              } else {
                                /// add the task
                                print("\n rrrr  \n  ");
                                controller.insertTask(taske);
                              }
                              Get.back();
                            }
                          })),
                )
              ]),
            ))),
      ),
    );
  }

  defineDateTimeAndRepeat(BuildContext context) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (_, a1, a2, widget) {
          return FractionalTranslation(
            translation: Offset(0, 1 - a1.value),
            child: Opacity(
              opacity: a1.value,
              child: AddTodoTimeAndDateDialogueWidget(oldtasks: oldtask),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 500),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Transform.rotate(angle: animation1.value);
        });
  }

  static formatTimeOfDay(TimeOfDay createTime) {
    final now = new DateTime.now();
    final dt = DateTime(
        now.year, now.month, now.day, createTime.hour, createTime.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  static TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  static int month(String month) {
    int i = 0;
    switch (month) {
      case "january":
        i = 1;
        break;
      case "february":
        i = 2;
        break;
      case "march":
        i = 3;
        break;
      case "april":
        i = 4;
        break;
      case "may":
        i = 5;
        break;
      case "june":
        i = 6;
        break;
      case "july":
        i = 7;
        break;
      case "august":
        i = 8;
        break;
      case "september":
        i = 9;
        break;
      case "october":
        i = 10;
        break;
      case "november":
        i = 11;
        break;
      default:
        i = 12;
    }
    return i;
  }
}
