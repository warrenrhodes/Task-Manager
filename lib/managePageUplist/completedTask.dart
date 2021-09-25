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
    // _payload = widget.payload;
    // if (_payload != null) {
    //   controller = Get.put(Controller());
    // }
    controller = Get.find<Controller>();
  }

  @override
  Widget build(BuildContext context) {
    // changeStatusOfPayload();
    final taskcompleted =
        controller.listTask.where((element) => element.status == true).toList();
    return Scaffold(
        appBar: AppBar(
          title: Text("Completed task"),
        ),
        body: TodoListWidget(
          taskList: taskcompleted,
          page: "",
        ));
  }
}
// Future<void> changeStatusOfPayload() async {
//   print("$_payload 44444444444444444444444");
//   if (_payload != null) {
//     print("payload hstatus have be change ggggggggggggggggggggggggggg");
//     await controller.changeStatus(controller.listTask
//         .indexWhere((element) => element.task == _payload));
//   }
// }
