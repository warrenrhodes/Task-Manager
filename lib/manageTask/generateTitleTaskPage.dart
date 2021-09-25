import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:task_manager2/controller/Controller.dart';
import 'package:task_manager2/manageTask/todoListwidget.dart';
import 'package:task_manager2/model/modelTitle.dart';
import 'package:task_manager2/myhomepage.dart';

class TitleTaskPage extends StatelessWidget {
  TodoTitle? title;

  TitleTaskPage({@required this.title});

  Controller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    String titreSelectionner = title!.title;
    return Scaffold(
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
                    Alert(
                        type: AlertType.warning,
                        context: context,
                        title: "Are you sure?",
                        style: buildalertStyle(),
                        content: Text(
                          "All the task of $title  will be delete",
                          style: TextStyle(fontSize: 15),
                        ),
                        buttons: [
                          builCancelButton(context),
                          builddeletebutton()
                        ]).show();
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

  builCancelButton(context) => DialogButton(
        child: Text(
          "Cancel",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Get.off(Myhomepage(),
            fullscreenDialog: true,
            transition: Transition.rightToLeft,
            duration: Duration(milliseconds: 600)),
        color: Color.fromRGBO(0, 179, 134, 1.0),
      );

  builddeletebutton() => DialogButton(
        child: Text(
          "Delete",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () async {
          controller.deleteTitle(title!);
          Get.off(() => Myhomepage(),
              transition: Transition.rightToLeft,
              duration: Duration(milliseconds: 600));
        },
        gradient: LinearGradient(colors: [
          Color.fromRGBO(116, 116, 191, 1.0),
          Color.fromRGBO(52, 138, 199, 1.0)
        ]),
      );

  AlertStyle buildalertStyle() {
    return AlertStyle(
      animationType: AnimationType.grow,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      descTextAlign: TextAlign.start,
      animationDuration: Duration(milliseconds: 600),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.red,
      ),
      alertAlignment: Alignment.center,
    );
  }
}
