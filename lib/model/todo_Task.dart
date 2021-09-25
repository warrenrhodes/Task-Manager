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

  TodoTask({
    required this.task,
    required this.id,
    required this.status,
    this.color,
    this.date,
    this.time,
    this.taskTitle,
    this.repeat,
  });
}
// TodoTask.withId({this.id,
//   this.status,
//   this.task,
//   this.time,
//   this.date,
//   this.taskTitle,
//   this.color,
//   this.repeat});
//
// // Used when inserting a row into the db, including the id field
// Map<String, dynamic> toJson(){
//   final Json = Map<String, dynamic>();
//
//   if(id != null){
//     Json['id'] = id;
//   }
//   Json['status'] = status;
//   Json['task'] = task;
//   Json['date'] = date.toIso8601String();
//   Json['time'] = time;
//   Json['taskTitle'] = taskTitle;
//   Json['color'] = color;
//   Json['repeat'] = json.encode(repeat);
//
//   return Json;
// }
//
// // Used when returning a row from the DB and converting into an object
// factory TodoTask.fromJson( Map<String, dynamic> Json){
//   return TodoTask.withId(
//       id : Json['id'],
//       task: Json['task'],
//       status : Json['status'] ,
//       time: Json['time'],
//       date: DateTime.parse(Json['date']),
//       taskTitle: Json['taskTitle'],
//       color: Json['color'] ,
//       repeat: json.decode(Json['repeat'])   ,
//   );
// }
//
// formatTimeOfDay(TimeOfDay createTime) {
//   final now = new DateTime.now();
//   final dt = DateTime(
//       now.year, now.month, now.day, createTime.hour, createTime.minute);
//   final format = DateFormat.jm(); //"6:00 AM"
//   return format.format(dt);
// }
//
