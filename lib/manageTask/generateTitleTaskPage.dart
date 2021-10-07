import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager2/controller/Controller.dart';
import 'package:task_manager2/manageTask/todoListwidget.dart';
import 'package:task_manager2/model/modelTitle.dart';

class TitleTaskPage extends StatelessWidget {
  TodoTitle? title;

  TitleTaskPage({@required this.title});

  Controller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    String titreSelectionner = title!.title;
    return Scaffold(
        backgroundColor: context.theme.backgroundColor,
        appBar: AppBar(
          title: Text(titreSelectionner),
          actions: [
            if (title!.title != "Default")
              IconButton(
                  icon: Icon(
                    Icons.delete_sweep_outlined,
                    color: Colors.blue,
                    semanticLabel: "delete title",
                  ),
                  iconSize: 35,
                  color: Colors.white70,
                  onPressed: () {
                    Get.defaultDialog(
                        title: 'Delete Confirmation',
                        content: Text(
                          "All the task of ${title!.title}  will be delete",
                          style: TextStyle(fontSize: 15),
                        ),
                        textCancel: "Cancel",
                        textConfirm: "Delete",
                        barrierDismissible: false,
                        onCancel: () {},
                        onConfirm: () async {
                          controller.deleteTitle(title!);
                          Get.back();
                        });
                  })
          ],
        ),
        body: GetBuilder<Controller>(builder: (_) {
          final taskOfpage = controller.listTask
              .where((element) =>
                  element.taskTitle == titreSelectionner &&
                  element.status == false)
              .toList();
          return taskOfpage.length == 0
              ? Container(
                  child: Center(
                    child: Text(
                        "All task of $titreSelectionner, have been accomplished ",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30, color: Colors.white38)),
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TodoListWidget(taskList: taskOfpage, page: ""),
                );
        }));
  }
}
