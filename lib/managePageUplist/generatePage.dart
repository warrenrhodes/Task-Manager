import 'package:flutter/material.dart';

import 'completedTask.dart';
import 'setting.dart';
import 'tasklist.dart';

class GeneratePage extends StatelessWidget {
  final Object? title;

  // final String payload;
  static const String routeName = '/completedTask';

  const GeneratePage({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if (payload != null)
    //   return CompletedTask(
    //     payload: payload,
    //   );
    switch (title) {
      case "Task list":
        return TaskList();
      case "Task Completed":
        return CompletedTask();
      case "Setting":
        return Setting();
      default:
        return SizedBox.shrink();
    }
  }
}
