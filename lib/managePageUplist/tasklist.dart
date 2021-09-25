import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import "package:get/get.dart";
import 'package:provider/provider.dart';
import 'package:task_manager2/controller/Controller.dart';
import 'package:task_manager2/model/modelTitle.dart';
import 'package:task_manager2/provider/dartThemePorvider.dart';

class TaskList extends StatelessWidget {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    final listTitle = Get.find<Controller>().listTitle;
    return Scaffold(
        appBar: AppBar(
          title: Text("Title list"),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.add,
                  size: 30,
                ),
                tooltip: 'Add  title',
                onPressed: () => buildEditTaskTitle(listTitle: listTitle))
          ],
        ),
        body: GetBuilder<Controller>(builder: (controller) {
          return Container(
              margin: EdgeInsets.only(top: 15, left: 15, right: 15),
              child: AnimatedList(
                key: listKey,
                initialItemCount: listTitle.length,
                itemBuilder: (context, index, animation) {
                  return slideIt(
                      index: index,
                      animation: animation,
                      listTitle: listTitle,
                      themeProvider: themeProvider); // Refer step 3
                },
                physics: BouncingScrollPhysics(),
              ));
        }));
  }

  Widget slideIt({int? index, animation, listTitle, themeProvider}) {
    return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset(0, 0),
        ).animate(animation),
        child:
            buildBuildListView(themeProvider, listTitle, index, themeProvider));
  }

  buildBuildListView(
    DarkThemeProvider theme,
    listTitle,
    index,
    themeProvider,
  ) {
    final title = listTitle[index];
    return Container(
      height: 70,
      padding: EdgeInsets.only(left: 25),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.darkTheme
            ? Colors.white.withOpacity(0.3)
            : Colors.lightBlueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          Expanded(
              child: Text(
            title.title,
          )),
          if (title.title != "Default")
            IconButton(
              icon: Icon(Icons.edit),
              iconSize: 35,
              color: Colors.blue,
              onPressed: () =>
                  buildEditTaskTitle(oldtitle: title, listTitle: listTitle),
            ),
          if (title.title != "Default")
            IconButton(
                icon: Icon(Icons.delete),
                iconSize: 35,
                color: Colors.red,
                onPressed: () {
                  Get.defaultDialog(
                      title: "Are you sure?",
                      content: Text(
                        "All the tasks of ${title.title}  will be deleted",
                        style: TextStyle(fontSize: 15),
                      ),
                      textCancel: "Cancel",
                      textConfirm: "Delete",
                      onCancel: () {},
                      onConfirm: () async {
                        listKey.currentState!.removeItem(
                            index,
                            (_, animation) => slideIt(
                                index: index,
                                animation: animation,
                                listTitle: listTitle,
                                themeProvider: theme),
                            duration: const Duration(milliseconds: 400));
                        Future.delayed(Duration(milliseconds: 400),
                            () => Get.find<Controller>().deleteTitle(title));
                        Get.back();
                      });
                }),
        ],
      ),
    );
  }

  buildEditTaskTitle({TodoTitle? oldtitle, List<TodoTitle>? listTitle}) {
    List<Color> color = [
      Color(0XFF3B7A57),
      Color(0XFFFFBF00),
    ];
    int colors;
    String title = "";
    if (oldtitle != null) {
      colors = oldtitle.color!;
      title = oldtitle.title;
    } else {
      colors = color[Random().nextInt(color.length)].value;
    }
    TextEditingController titlecController = TextEditingController(text: title);
    var _formkeydialogue = GlobalKey<FormBuilderState>();
    return Get.defaultDialog(
        title: title.isEmpty ? 'Create A New  title' : "Update the title",
        content: FormBuilder(
          key: _formkeydialogue = GlobalKey<FormBuilderState>(),
          child: FormBuilderTextField(
            controller: titlecController,
            name: "titre",
            decoration: InputDecoration(
              icon: Icon(Icons.add),
              labelText: title.isEmpty ? 'Add a title' : "Update the title",
            ),
            // ignore: missing_return
            validator: (value) {
              if (value!.trim().isEmpty) {
                return "Empty value";
              } else if (Get.find<Controller>()
                  .listTitle
                  .where((element) => element.title == value.trim())
                  .isNotEmpty) {
                return "Already exists";
              }
            },
            keyboardType: TextInputType.text,
          ),
        ),
        textCancel: "Cancel",
        textConfirm: title.isEmpty ? "Save" : "Update",
        barrierDismissible: false,
        onCancel: () {},
        onConfirm: () {
          final isvalid = _formkeydialogue.currentState!.validate();
          if (isvalid) {
            final TodoTitle titleA = TodoTitle(
                title: titlecController.text.trim(),
                color: colors,
                id: Random().nextInt(pow(2, 31).toInt()));

            ///past the title if she  already exist
            if (oldtitle != null) {
              Get.find<Controller>()
                  .updateTitle(titlecController.text.trim(), oldtitle);
            } else {
              listKey.currentState!.insertItem(listTitle!.length,
                  duration: const Duration(milliseconds: 400));
              Get.find<Controller>().insertTitle(titleA);
            }
            Get.back();
          }
        });
  }
}
