import 'package:hive/hive.dart';

part 'modelTitle.g.dart';

@HiveType(typeId: 0)
class TodoTitle extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String title = "";
  @HiveField(2)
  int? color;

  TodoTitle({required this.title, this.color, this.id});
}
