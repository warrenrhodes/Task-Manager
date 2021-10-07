import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:task_manager2/model/modelTitle.dart';
import 'package:url_launcher/url_launcher.dart';

import 'controller/Controller.dart';
import 'managePageUplist/generatePage.dart';
import 'manageTask/generateTitleTaskPage.dart';
import 'manageTask/todoListwidget.dart';
import 'model/todo_Task.dart';

class Body extends StatelessWidget {
  List menuitems = [
    "Task list",
    "Task Completed",
    "Share",
    "Send suggestion",
    "Setting"
  ];
  Controller controller = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: "webanalyse237@gmail.com",
      query: encodeQueryParameters(<String, String>{
        'subject': "Suggestion",
      }),
    );

    final listTitle = controller.listTitle;
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ///header
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: context.theme.appBarTheme.backgroundColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                SizedBox(
                  width: 80,
                  child: ImageIcon(AssetImage("assets/logo.png"),
                      size: 50,
                      color: Get.isDarkMode
                          ? Color.fromRGBO(0, 183, 183, 10)
                          : HexColor("#00005a")),
                ),
                Container(
                  child: Row(
                    children: [
                      PopupMenuButton(
                        initialValue: "Task list",
                        icon: Icon(
                          Icons.segment,
                          color: Get.isDarkMode
                              ? Colors.white70
                              : HexColor("#00005a"),
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
                        color:
                            context.theme.popupMenuTheme.color!.withOpacity(1),
                        onSelected: (value) {
                          if (value == "Task Completed" &&
                              controller.listTask
                                      .where(
                                          (element) => element.status == true)
                                      .toList()
                                      .length ==
                                  0) {
                          } else if (value == "Share") {
                            Share.share("Please visite https://google.com");
                          } else if (value == "Send suggestion") {
                            launch(emailLaunchUri.toString());
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
          ),

          /// contruction of container title
          Container(
            padding: EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 20),
            width: double.infinity,
            child: Text("Categories :",
                style: TextStyle(
                    color: context.theme.primaryTextTheme.bodyText1!.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
          ),
          GetBuilder<Controller>(
              init: Controller(),
              builder: (controller) {
                return Container(
                    padding: EdgeInsets.only(
                      left: 15,
                    ),
                    height: 130,
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
                                    ? buildContainer(listTitle[index])
                                    : Dismissible(
                                        key: Key(
                                            'item ${listTitle[index].title}'),
                                        direction: DismissDirection.up,
                                        confirmDismiss:
                                            (DismissDirection direction) async {
                                          return await Get.defaultDialog(
                                              title: 'Delete Confirmation',
                                              content: Text(
                                                  "Are you sure you want to delete  ${listTitle[index].title}? \nall potentiel tasks associated at ${listTitle[index].title} will be delete"),
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
                                        child:
                                            buildContainer(listTitle[index]))),
                          );
                        }));
              }),

          ///....................... container to add edit and delete task...............
          GetBuilder<Controller>(builder: (_) {
            return Container(
                padding:
                    EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 20),
                width: double.infinity,
                child: controller.taskchange["all task"] == true
                    ? Text("ALL'S TASKS :",
                        style: TextStyle(
                            color:
                                context.theme.primaryTextTheme.bodyText1!.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 18))
                    : controller.taskchange["today task"] == true &&
                            controller.taskchange["completed task"] == true
                        ? Text("COMPLETED'S TASKS and TODAY' TASKS:",
                            style: TextStyle(
                                color: context
                                    .theme.primaryTextTheme.bodyText1!.color,
                                fontWeight: FontWeight.bold,
                                fontSize: 18))
                        : controller.taskchange["completed task"] == true
                            ? Text("COMPLETED'S TASKS :",
                                style: TextStyle(
                                    color: context.theme.primaryTextTheme
                                        .bodyText1!.color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))
                            : Text("TODAY'S TASKS :",
                                style: TextStyle(
                                    color: context.theme.primaryTextTheme
                                        .bodyText1!.color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)));
          }),
          GetBuilder<Controller>(
              init: Controller(),
              builder: (initController) {
                final listTask = initController.listTask;
                if (listTask == null || listTask.isEmpty) {
                  return Expanded(
                    child: Container(
                        padding: EdgeInsets.only(
                          left: 15,
                        ),
                        decoration: BoxDecoration(
                            image: Get.isDarkMode
                                ? DecorationImage(
                                    // fit: BoxFit.contain,
                                    colorFilter: new ColorFilter.mode(
                                        Colors.red.withOpacity(0.2),
                                        BlendMode.dstIn),
                                    image: AssetImage(
                                      "assets/1.png",
                                    ))
                                : DecorationImage(
                                    fit: BoxFit.contain,
                                    colorFilter: new ColorFilter.mode(
                                        Colors.white.withOpacity(0.4),
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
                            Text(
                              "Data not found ",
                              style: TextStyle(
                                  color: context
                                      .theme.primaryTextTheme.bodyText1!.color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )
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
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              image: Get.isDarkMode
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
                                          Colors.white.withOpacity(0.7),
                                          BlendMode.dstATop),
                                      image: AssetImage(
                                        "assets/4.png",
                                      ))),
                          height: Get.size.height / 2,
                        ),
                        Text(
                            "Congratulation \nAll today's tasks, have been accomplished ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: context
                                    .theme.primaryTextTheme.bodyText1!.color,
                                fontWeight: FontWeight.bold,
                                fontSize: 25)),
                      ],
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
                              taskList: listTask
                                  .where((element) => element.status == false)
                                  .toList(),
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
  buildContainer(TodoTitle _listtitle) {
    BuildContext context = Get.context!;
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
      margin: EdgeInsets.only(right: 12),
      width: 80,
      decoration: BoxDecoration(
        color: context.theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Text("${_listtitle.title}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: context.theme.primaryTextTheme.bodyText1!.color,
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
                    style: TextStyle(
                      fontSize: 7,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  circularStrokeCap: CircularStrokeCap.butt,
                  backgroundColor: Get.isDarkMode ? Colors.grey : Colors.white,
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
                    "${allTaskOfSpecificTitle} \nTask(s)",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    )),
                circularStrokeCap: CircularStrokeCap.butt,
                backgroundColor: Get.isDarkMode ? Colors.grey : Colors.white,
                progressColor: Color(_listtitle.color!),
              );
            }),
          )
        ],
      ),
    );
  }
}
