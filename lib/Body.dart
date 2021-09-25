import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:task_manager2/manageTask/createNotification.dart';
import 'package:task_manager2/model/modelTitle.dart';
import 'package:task_manager2/provider/dartThemePorvider.dart';

import 'controller/Controller.dart';
import 'main.dart';
import 'managePageUplist/generatePage.dart';
import 'manageTask/generateTitleTaskPage.dart';
import 'manageTask/todoListwidget.dart';
import 'model/todo_Task.dart';

class Body extends StatelessWidget {
  final Size? size;

  Body({
    Key? key,
    this.size,
  }) : super(key: key);

  List menuitems = [
    "Task list",
    "Task Completed",
    "Share",
    "Send suggestion",
    "Setting"
  ];
  Controller controller = Get.find();

  // void _lauch() {
  //   _artboard.addController(_controller = SimpleAnimation("clip"));
  // }
  @override
  Widget build(BuildContext context) {
    // _artboard = controller.artboard;
    GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    final listTitle = controller.listTitle;
    return Container(
      height: size?.height,
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ///header
          SafeArea(
              child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: themeProvider.darkTheme
                  ? Color.fromRGBO(0, 65, 65, 10)
                  : Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                SizedBox(
                  width: 80,
                  child: ImageIcon(AssetImage("assets/logo.png"),
                      size: 50, color: Color.fromRGBO(0, 183, 183, 10)),
                ),
                Container(
                  child: Row(
                    children: [
                      PopupMenuButton(
                        initialValue: "Task list",
                        icon: Icon(
                          Icons.segment,
                          color: Colors.white70,
                        ),
                        itemBuilder: (BuildContext context) {
                          return menuitems.map((test) {
                            return PopupMenuItem(
                              child: ListTile(
                                title: Text(
                                  test,
                                ),
                                leading: test == "Task list"
                                    ? Icon(Icons.playlist_add_check)
                                    : test == "Task Completed"
                                        ? Icon(Icons.check_circle_outline)
                                        : test == "Share"
                                            ? Icon(Icons.share)
                                            : test == "Send suggestion"
                                                ? Icon(Icons.mail_outline)
                                                : Icon(Icons.settings),
                                trailing: test == "Task Completed"
                                    ? GetBuilder<Controller>(
                                        init: Controller(),
                                        builder: (controller) {
                                          final listTask = controller.listTask;
                                          return Text(
                                              "(${listTask.where((element) => element.status == true).toList().length})");
                                        })
                                    : Text(''),
                              ),
                              value: test,
                            );
                          }).toList();
                        },
                        color: themeProvider.darkTheme
                            ? Color.fromRGBO(0, 25, 25, 10)
                            : Colors.white,
                        onSelected: (value) {
                          print(value);
                          if (value == "Task Completed" &&
                              controller.listTask
                                      .where(
                                          (element) => element.status == true)
                                      .toList()
                                      .length ==
                                  0) {
                          } else {
                            Get.to(
                              () => GeneratePage(
                                title: value,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),

          /// contruction of container title
          Container(
            padding: EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 20),
            width: double.infinity,
            child: Text("Categories :",
                style: TextStyle(color: Colors.white70, fontSize: 18)),
          ),
          GetBuilder<Controller>(
              init: Controller(),
              builder: (controller) {
                final listTask = controller.listTask;
                return Container(
                    width: Get.size.width,
                    padding: EdgeInsets.only(
                      left: 15,
                    ),
                    height: controller.heightOfContainer,
                    // Use ListView.builder
                    child: ListView.builder(
                        itemCount: listTitle.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return FittedBox(
                            fit: BoxFit.fill,
                            alignment: Alignment.topCenter,
                            child: GestureDetector(
                                onTap: controller.listTask
                                            .where((element) =>
                                                element.taskTitle ==
                                                listTitle[index].title)
                                            .toList()
                                            .length ==
                                        0
                                    ? () {}
                                    : () => Get.to(
                                        () => TitleTaskPage(
                                            title: listTitle[index]),
                                        fullscreenDialog: true,
                                        transition: Transition.rightToLeft,
                                        duration: Duration(milliseconds: 600)),
                                child: listTitle[index].title == "Default"
                                    ? buildContainer(
                                        themeProvider, listTitle[index])
                                    : Dismissible(
                                        key: Key(
                                            'item ${listTitle[index].title}'),
                                        direction: DismissDirection.up,
                                        confirmDismiss:
                                            (DismissDirection direction) async {
                                          return await Get.defaultDialog(
                                              title: 'Delete Confirmation',
                                              content: Text(
                                                  "Are you sure you want to delete this ${listTitle[index].title}? \n all potentiel tasks associated with this title will be delete"),
                                              textCancel: "Cancel",
                                              textConfirm: "Delete",
                                              barrierDismissible: false,
                                              onCancel: () {},
                                              onConfirm: () async {
                                                controller.deleteTitle(
                                                    listTitle[index]);
                                                Get.back();
                                              });
                                        },
                                        background: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Column(
                                              children: [
                                                Icon(Icons.delete,
                                                    color: Colors.white),
                                                Text('Move to trash',
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        child: buildContainer(
                                            themeProvider, listTitle[index]))),
                          );
                        }));
              }),
          TextButton(
            child: Text('Get active notifications'),
            onPressed: () async {
              await _getActiveNotifications(context);
            },
          ),

          ///....................... container to add edit and delete task...............
          GetBuilder<Controller>(builder: (_) {
            return Container(
                padding:
                    EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 20),
                width: double.infinity,
                child: controller.taskchange["all task"] == true
                    ? Text("ALL'S TASKS :",
                        style: TextStyle(color: Colors.white70, fontSize: 10))
                    : controller.taskchange["completed task"] == true &&
                            controller.taskchange["today task"] == true
                        ? Text("COMPLETED'S TASKS and TODAY' TASKS:",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 10))
                        : controller.taskchange["completed task"] == true
                            ? Text("COMPLETED'S TASKS :",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 10))
                            : controller.taskchange["today task"] == true
                                ? Text("TODAY'S TASKS :",
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 10))
                                : Text(" TASKS :",
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 10)));
          }),
          GetBuilder<Controller>(
              init: Controller(),
              builder: (initController) {
                final listTask = initController.listTask;
                print("${listTask.length}");
                if (listTask == null || listTask.isEmpty) {
                  return Expanded(
                    child: Container(
                        padding: EdgeInsets.only(
                          left: 15,
                        ),
                        decoration: BoxDecoration(
                            image: themeProvider.darkTheme
                                ? DecorationImage(
                                    fit: BoxFit.contain,
                                    colorFilter: new ColorFilter.mode(
                                        Colors.white.withOpacity(0.2),
                                        BlendMode.dstIn),
                                    image: AssetImage(
                                      "assets/1.png",
                                    ))
                                : DecorationImage(
                                    fit: BoxFit.contain,
                                    colorFilter: new ColorFilter.mode(
                                        Colors.black.withOpacity(0.5),
                                        BlendMode.dstATop),
                                    image: AssetImage(
                                      "assets/1.png",
                                    ))),
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 40,
                            ),
                            Text("Data not found ")
                          ],
                        ))),
                  );
                } else if (controller.taskchange["today task"] == true &&
                    controller.taskchange["all task"] == false &&
                    controller.taskchange["completed task"] == false &&
                    Get.find<Controller>()
                            .listTask
                            .where((element) =>
                                element.status == false &&
                                (element.date!.year == DateTime.now().year &&
                                    element.date!.month ==
                                        DateTime.now().month &&
                                    element.date!.day == DateTime.now().day))
                            .toList()
                            .length ==
                        0) {
                  return Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          image: themeProvider.darkTheme
                              ? DecorationImage(
                                  fit: BoxFit.contain,
                                  colorFilter: new ColorFilter.mode(
                                      Colors.white.withOpacity(0.2),
                                      BlendMode.dstIn),
                                  image: AssetImage(
                                    "assets/4.png",
                                  ))
                              : DecorationImage(
                                  fit: BoxFit.contain,
                                  colorFilter: new ColorFilter.mode(
                                      Colors.black.withOpacity(0.5),
                                      BlendMode.dstATop),
                                  image: AssetImage(
                                    "assets/4.png",
                                  ))),
                      child: Center(
                        child: Text(
                            "Congratulation \nAll today's tasks, have been accomplished ",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 30, color: Colors.white38)),
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: Container(
                      padding: EdgeInsets.only(
                        left: 15,
                      ),
                      child: controller.taskchange["all task"] == true
                          ? TodoListWidget(
                              // listKey: listKey,
                              taskList: listTask,
                              page: "body",
                            )
                          : controller.taskchange["completed task"] == true &&
                                  controller.taskchange["today task"] == true
                              ? TodoListWidget(
                                  // listKey: listKey,
                                  taskList: listTask
                                      .where((TodoTask task) =>
                                          task.status == true ||
                                          (task.date!.year ==
                                                  DateTime.now().year &&
                                              task.date!.month ==
                                                  DateTime.now().month &&
                                              task.date!.day ==
                                                  DateTime.now().day))
                                      .toList(),
                                  page: "body",
                                )
                              : controller.taskchange["completed task"] == true
                                  ? TodoListWidget(
                                      //listKey: listKey,
                                      taskList: listTask
                                          .where((element) =>
                                              element.status == true)
                                          .toList(),
                                      page: "body",
                                    )
                                  : TodoListWidget(
                                      //listKey: listKey,
                                      taskList: Get.find<Controller>()
                                          .listTask
                                          .where((element) =>
                                              element.status == false &&
                                              (element.date!.year ==
                                                      DateTime.now().year &&
                                                  element.date!.month ==
                                                      DateTime.now().month &&
                                                  element.date!.day ==
                                                      DateTime.now().day))
                                          .toList(),
                                      page: "body",
                                    )),
                );
              }),
        ],
      ),
    );
  }

  ///build title of task
  buildContainer(DarkThemeProvider themeProvider, TodoTitle _listtitle) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
      margin: EdgeInsets.only(right: 12),
      //width: 100,
      decoration: BoxDecoration(
        color: themeProvider.darkTheme
            ? Color.fromRGBO(0, 65, 65, 10)
            : Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Container(
                child: Text("${_listtitle.title}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15))),
          ),
          Center(
            child: GetBuilder<Controller>(builder: (_) {
              if (controller.listTask
                      .where((element) => element.taskTitle == _listtitle.title)
                      .length ==
                  0) {
                return CircularPercentIndicator(
                  radius: 50.0,
                  lineWidth: 7.0,
                  center: Text(
                    "  No \n Task",
                    style: TextStyle(fontSize: 7),
                    textAlign: TextAlign.center,
                  ),
                  circularStrokeCap: CircularStrokeCap.butt,
                  backgroundColor: Colors.grey,
                  progressColor: Color(_listtitle.color!),
                );
              }
              var taskCom = controller.listTask
                  .where((element) =>
                      element.taskTitle == _listtitle.title &&
                      element.status == true)
                  .length;
              var allTaskOfSpecificTitle = controller.listTask
                  .where((element) => element.taskTitle == _listtitle.title)
                  .length;
              return CircularPercentIndicator(
                radius: 70.0,
                lineWidth: 7.0,
                percent: allTaskOfSpecificTitle != 0
                    ? taskCom / allTaskOfSpecificTitle
                    : 0,
                center: Text(
                    "${taskCom} of "
                    "${allTaskOfSpecificTitle} \nTask",
                    style: TextStyle(fontSize: 10)),
                circularStrokeCap: CircularStrokeCap.butt,
                backgroundColor: Colors.grey,
                progressColor: Color(_listtitle.color!),
              );
            }),
          )
        ],
      ),
    );
  }

  Future<void> _getActiveNotifications(BuildContext context) async {
    final Widget activeNotificationsDialogContent =
        await _getActiveNotificationsDialogContent();
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: activeNotificationsDialogContent,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<Widget> _getActiveNotificationsDialogContent() async {
    try {
      final List<ActiveNotification>? activeNotifications =
          await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()!
              .getActiveNotifications();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Active Notifications',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '${CreateNotification().getListOfPendingNotificationRequest()}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Divider(color: Colors.black),
          if (activeNotifications!.isEmpty)
            const Text('No active notifications'),
          if (activeNotifications.isNotEmpty)
            for (ActiveNotification activeNotification in activeNotifications)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'id: ${activeNotification.id}\n'
                    'channelId: ${activeNotification.channelId}\n'
                    'title: ${activeNotification.title}\n'
                    'body: ${activeNotification.body}',
                  ),
                  const Divider(color: Colors.black),
                ],
              ),
        ],
      );
    } on PlatformException catch (error) {
      return Text(
        'Error calling "getActiveNotifications"\n'
        'code: ${error.code}\n'
        'message: ${error.message}',
      );
    }
  }
}
