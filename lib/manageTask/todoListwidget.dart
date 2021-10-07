import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';
import 'package:task_manager2/controller/Controller.dart';
import 'package:task_manager2/manageTask/taskForm.dart';
import 'package:task_manager2/model/todo_Task.dart';

class TodoListWidget extends StatefulWidget {
  final List<TodoTask>? taskList;
  String? page;

  TodoListWidget({Key? key, this.taskList, this.page}) : super(key: key);

  @override
  _TodoListWidgetState createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget>
    with TickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  GlobalKey<AnimatedListState>? listKey;
  RiveAnimationController? _controller;
  Artboard? _artboard;
  double init = 0;
  int? state;
  int? reinit;
  Widget? containerChange;
  double? test;
  Icon? presentIcon;

  /// the first items that will be displays in a list is index to be
  @override
  void initState() {
    // TODO: implement initState
    _loadRiveFile();
    // listKey = GlobalKey<AnimatedListState>(debugLabel: "${widget.page}");
    super.initState();
  }

  // @override
  // Future<void> didUpdateWidget(covariant TodoListWidget oldWidget)  {
  //   // TODO: implement didUpdateWidget
  //        if(widget.taskList.length > 0){
  //          Future.delayed(Duration(milliseconds: 500), () {
  //         listKey.currentState.insertItem(widget.taskList.length-1);
  //       });
  //        }
  //   super.didUpdateWidget(oldWidget);
  // }
  void _loadRiveFile() async {
    final bytes = await rootBundle.load("assets/checkbox.riv");
    final file = RiveFile.import(bytes);
    setState(() {
      _artboard = file.mainArtboard;
    });
  }

  void _lauch() {
    _artboard!.addController(_controller = SimpleAnimation("circleToCheck"));
  }

  void _fall() {
    _artboard!.addController(_controller = SimpleAnimation("checkToCircle"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        controller: scrollController,
        itemCount: widget.taskList!.length,
        itemBuilder: (context, index) {
          if (index >= widget.taskList!.length) {}
          return slideIt(index: index);
        },
      ),
    );
  }

  Widget slideIt({int? index, animation}) {
    final task = widget.taskList![index!];
    return Dismissible(
        key: Key('item $task'),
        direction: DismissDirection.startToEnd,
        confirmDismiss: (DismissDirection direction) async {
          return await Get.defaultDialog(
              title: 'Delete Confirmation',
              content: const Text("Are you sure you want to delete this task?"),
              textCancel: "Cancel",
              textConfirm: "Delete",
              barrierDismissible: false,
              onCancel: () {},
              onConfirm: () {
                Get.find<Controller>().deleteTask(task);
                Get.back();
              });
        },
        background: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              Text('Move to trash', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        child: builContainer(index, task));
  }

  Widget builContainer(int index, TodoTask task) {
    state = task.status == true ? 1 : 0;
    reinit = 0;
    containerChange = task.status == true
        ? Icon(
            Icons.check_circle,
            color: Colors.red,
          )
        : Icon(
            Icons.radio_button_off,
            color: Color(task.color!),
          );
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          FittedBox(
            fit: BoxFit.fill,
            alignment: Alignment.topCenter,
            child: StatefulBuilder(builder: (context, StateSetter reload) {
              return GestureDetector(
                  key: Key("$index"),
                  child: Container(
                      child: state == 0 && reinit == 0
                          ? Container(
                              height: 40, width: 40, child: containerChange)
                          : task.status == true && state == 1
                              ? Container(
                                  height: 40, width: 40, child: containerChange)
                              : Container(
                                  height: 40,
                                  width: 40,
                                  child: _artboard != null
                                      ? Rive(
                                          artboard: _artboard!,
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(Icons.play_circle_fill_sharp))),
                  onTap: () {
                    if (state == 0) {
                      _lauch();
                      reload(() {
                        state = 1;
                      });
                      Future.delayed(
                          Duration(milliseconds: 900),
                          () => Get.find<Controller>().changeStatus(
                              Get.find<Controller>().listTask.indexOf(task)));
                      Get.snackbar("${task.task} completed", "",
                          snackPosition: SnackPosition.BOTTOM,
                          snackStyle: SnackStyle.FLOATING,
                          duration: Duration(seconds: 2),
                          animationDuration: Duration(seconds: 2),
                          backgroundColor: Colors.blue.withOpacity(1));
                      // CreateNotification().deleteNotification(task.id!);
                      AndroidAlarmManager.cancel(task.id!);
                    } else {
                      _fall();
                      reload(() {
                        state = 0;
                        reinit = 1;
                      });
                      Future.delayed(
                          Duration(milliseconds: 901),
                          () => Get.find<Controller>().changeStatus(
                              Get.find<Controller>().listTask.indexOf(task)));
                    }
                  });
            }),
          ),
          SizedBox(
            width: 30,
          ),
          OpenContainer(
              transitionDuration: Duration(milliseconds: 500),
              openBuilder: (context, closedContainer) {
                return TaskForm(oldtask: widget.taskList![index]);
              },
              openColor: Colors.black38.withOpacity(0),
              closedElevation: 0,
              closedColor: Colors.white.withOpacity(0),
              closedBuilder: (context, openContainer) {
                return InkWell(
                    onTap: widget.taskList![index].status == false
                        ? openContainer
                        : () => {},
                    child: FittedBox(
                      fit: BoxFit.fill,
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 100,
                        padding: EdgeInsets.only(left: 13, top: 3, bottom: 5),
                        decoration: BoxDecoration(
                          color: Get.isDarkMode
                              ? Colors.white.withOpacity(0.2)
                              : Colors.lightBlueAccent.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("Name: "),
                                Text(task.task,
                                    style: task.status == true
                                        ? TextStyle(
                                            color: Colors.red,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)
                                        : TextStyle(
                                            color: changecolor(
                                                Color(task.color!),
                                                Colors.red,
                                                task),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                              ],
                            ),
                            task.repeat!.length != 0
                                ? Container(
                                    child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.repeat,
                                            color: Colors.green,
                                          ),
                                          (task.repeat!.containsKey("Day"))
                                              ? task.repeat!["Day"][0] == 1
                                                  ? Text("Repeat Every Day")
                                                  : Text(
                                                      "Repeat Every ${task.repeat!["Day"][0]}  Day")
                                              : (task.repeat!
                                                      .containsKey("Week"))
                                                  ? task.repeat!["Week"][0] == 1
                                                      ? Text(
                                                          "Repeat Every Week")
                                                      : Text(
                                                          "Repeat Every ${task.repeat!["Week"][0]} Week")
                                                  : (task.repeat!
                                                          .containsKey("Month"))
                                                      ? task.repeat!["Month"]
                                                                  [0] ==
                                                              1
                                                          ? Text(
                                                              "Repeat Every Month")
                                                          : Text(
                                                              "Repeat Every ${task.repeat!["Month"][0]} Month")
                                                      : task.repeat!["Years"]
                                                                  [0] ==
                                                              1
                                                          ? Text(
                                                              "Repeat Every Years")
                                                          : Text(
                                                              "Repeat Every ${task.repeat!["Years"][0]} Years")
                                        ],
                                      ),
                                      (task.repeat!.containsKey("Day"))
                                          ? Text(
                                              "Start:  ${typeOfDay(task.repeat!["Day"][1])} , ${task.repeat!["Day"][2]} ")
                                          : (task.repeat!.containsKey("Week"))
                                              ? Text(
                                                  "Start:  ${typeOfDay(task.repeat!["Week"][2])} , ${task.repeat!["Week"][3]} ")
                                              : (task.repeat!
                                                      .containsKey("Month"))
                                                  ? Text(
                                                      "Start :  ${typeOfDay(DateTime.now().add(Duration(days: 1)))} , ${task.repeat!["Month"][3]} ")
                                                  : Text(
                                                      "Start :  ${typeOfDay(task.repeat!["Years"][1])} , ${task.repeat!["Years"][2]} ")
                                    ],
                                  ))
                                : Container(
                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                    child: Row(
                                      children: [
                                        Text("Date & Time:"),
                                        Text(
                                          typeOfDay(task.date!),
                                          style: TextStyle(
                                              color: changecolor(
                                                  Color(task.color!),
                                                  Colors.red,
                                                  task),
                                              fontStyle: FontStyle.italic,
                                              fontSize: 15),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          task.time!,
                                          style: TextStyle(
                                              color: changecolor(
                                                  Color(task.color!),
                                                  Colors.red,
                                                  task),
                                              fontStyle: FontStyle.italic,
                                              fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ),
                            if (task.taskTitle != "Default" &&
                                task.status == false)
                              Text(
                                "Title :${task.taskTitle!}",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 15),
                              ),
                            Text("Description: ${task.description!}",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 15))
                          ],
                        ),
                      ),
                    ));
              }),
        ],
      ),
    );
  }

  Color changecolor(Color colorFrom, Color colorTo, TodoTask task) {
    if (task.date!.month == DateTime.now().month) {
      if (task.date!.day == DateTime.now().day) {
        ///compare the time of input user time which DateTime.now()
        if (stringToTimeOfDay(task.time).hour == DateTime.now().hour) {
          if (stringToTimeOfDay(task.time).minute >= DateTime.now().minute) {
            return colorFrom;
          } else {
            return colorTo;
          }
        } else if (stringToTimeOfDay(task.time).hour > DateTime.now().hour) {
          return colorFrom;
        } else {
          return colorTo;
        }
      } else if (task.date!.day > DateTime.now().day) {
        return colorFrom;
      } else {
        return colorTo;
      }
    } else if (task.date!.month > DateTime.now().month) {
      return colorFrom;
    } else {
      return colorTo;
    }
  }

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  String typeOfDay(DateTime date) {
    if (calculateDifference(date) == 0) {
      return "Today";
    } else if (calculateDifference(date) == -1) {
      return "Yesterday";
    } else if (calculateDifference(date) == 1) {
      return "Tomorrow";
    }
    return DateFormat("EE, d MMM yyyy").format(date);
  }

  formatTimeOfDay(TimeOfDay createTime) {
    final now = new DateTime.now();
    final dt = DateTime(
        now.year, now.month, now.day, createTime.hour, createTime.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  TimeOfDay stringToTimeOfDay(String? tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod!));
  }
}
