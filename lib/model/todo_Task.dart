import 'package:hive/hive.dart';

part 'todo_Task.g.dart';

@HiveType(typeId: 1)
class TodoTask extends HiveObject {
  @HiveField(0)
  String task = "";
  @HiveField(1)
  bool status = false;
  @HiveField(2)
  int? id;
  @HiveField(3)
  String? time;
  @HiveField(4)
  DateTime? date;
  @HiveField(5)
  String? taskTitle;
  @HiveField(6)
  int? color;
  @HiveField(7)
  Map? repeat;
  @HiveField(8)
  String? description;

  TodoTask({
    required this.task,
    required this.id,
    required this.status,
    this.color,
    this.description,
    this.date,
    this.time,
    this.taskTitle,
    this.repeat,
  });
}
