import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:task_manager2/manageTask/taskForm.dart';
import 'package:task_manager2/popover.dart';

import 'Body.dart';
import 'controller/Controller.dart';

class Myhomepage extends StatelessWidget {
  Myhomepage({Key? key, this.payload}) : super(key: key);
  final String? payload;
  Controller controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.theme.backgroundColor,
        body: Body(),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0),
          // this is ignored if animatedIcon is non null
          // child: Icon(Icons.add),
          visible: true,
          curve: Curves.bounceIn,
          activeBackgroundColor: Colors.purple,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          tooltip: 'Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: Get.isDarkMode
              ? Color.fromRGBO(0, 180, 180, 10)
              : HexColor("#00ca90"),
          foregroundColor: Colors.black,
          elevation: 8.0,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
              child: Icon(Icons.settings),
              backgroundColor: Colors.blue,
              label: 'Setting',
              labelBackgroundColor: Colors.black.withOpacity(0.5),
              labelStyle: TextStyle(fontSize: 20),
              onTap: () => _modelSheetOfTask(context),
            ),
            SpeedDialChild(
                child: Icon(Icons.add),
                backgroundColor: Colors.green,
                label: 'Add task',
                labelBackgroundColor: Colors.black.withOpacity(0.5),
                labelStyle: TextStyle(fontSize: 20),
                onTap: () {
                  Get.to(() => TaskForm(),
                      fullscreenDialog: true,
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: 600));
                }),
          ],
        ),
      ),
    );
  }

  _modelSheetOfTask(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Popover(
            child: GetBuilder<Controller>(
                init: Controller(),
                builder: (controlle) {
                  return Column(
                    children: [
                      _buildListItem(context,
                          title: Text('All Task'),
                          leading: Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                          ),
                          trailing: SizedBox(
                            width: 80,
                            child: FormBuilderSwitch(
                              name: "all task",
                              title: Text(""),
                              initialValue: controlle.taskchange["all task"],
                              onChanged: (value) =>
                                  controlle.setTaskChange("all task", value),
                              decoration: InputDecoration.collapsed(
                                  hintText: "", border: InputBorder.none),
                            ),
                          )),
                      _buildListItem(context,
                          title: Text('Completed Task'),
                          leading: Icon(
                            Icons.check_circle,
                            color: Colors.red,
                          ),
                          trailing: SizedBox(
                            width: 80,
                            child: FormBuilderSwitch(
                                name: "completed task",
                                title: Text(""),
                                initialValue:
                                    controlle.taskchange["completed task"],
                                onChanged: (value) => controlle.setTaskChange(
                                    "completed task", value),
                                enabled:
                                    controlle.taskchange["all task"] == true
                                        ? false
                                        : true,
                                decoration: InputDecoration.collapsed(
                                    hintText: "", border: InputBorder.none)),
                          )),
                      _buildListItem(context,
                          title: Text('Today Task'),
                          leading: Icon(
                            Icons.today,
                            color: Colors.blue,
                          ),
                          trailing: SizedBox(
                            width: 80,
                            child: FormBuilderSwitch(
                                name: "today task",
                                title: Text(""),
                                enabled:
                                    controlle.taskchange["all task"] == true
                                        ? false
                                        : true,
                                initialValue:
                                    controlle.taskchange["today task"],
                                onChanged: (value) => controlle.setTaskChange(
                                    "today task", value),
                                decoration: InputDecoration.collapsed(
                                    hintText: "", border: InputBorder.none)),
                          ))
                    ],
                  );
                }),
          );
        });
  }
}

Widget _buildListItem(
  BuildContext context, {
  Widget? title,
  Widget? leading,
  Widget? trailing,
}) {
  final theme = Theme.of(context);
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 24.0,
      vertical: 16.0,
    ),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: theme.dividerColor,
          width: 0.5,
        ),
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (leading != null) leading,
        if (title != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: DefaultTextStyle(
              child: title,
              style: theme.textTheme.headline6!,
            ),
          ),
        Spacer(),
        if (trailing != null) trailing,
      ],
    ),
  );
}
