import 'package:flutter/material.dart';
import "package:get/get.dart";
import 'package:task_manager2/controller/Controller.dart';
import 'package:task_manager2/manageTask/todoListwidget.dart';

class CompletedTask extends StatefulWidget {
  // final String payload;
  // const CompletedTask({Key key, this.payload}) : super(key: key);
  @override
  State<CompletedTask> createState() => _CompletedTaskState();
}

class _CompletedTaskState extends State<CompletedTask> {
  // String _payload;
  Controller controller = Controller();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.find<Controller>();
  }

  @override
  Widget build(BuildContext context) {
    // changeStatusOfPayload();

    return Scaffold(
        backgroundColor: context.theme.backgroundColor,
        appBar: AppBar(
          title: Text("Completed task"),
        ),
        body: GetBuilder<Controller>(builder: (controller) {
          final taskcompleted = controller.listTask
              .where((element) => element.status == true)
              .toList();
          return Container(
              margin: EdgeInsets.only(top: 10),
              child: TodoListWidget(
                taskList: taskcompleted,
                page: "",
              ));
        }));
  }
}
