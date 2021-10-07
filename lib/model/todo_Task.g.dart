// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_Task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoTaskAdapter extends TypeAdapter<TodoTask> {
  @override
  final int typeId = 1;

  @override
  TodoTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoTask(
      task: fields[0] as String,
      id: fields[2] as int?,
      status: fields[1] as bool,
      color: fields[6] as int?,
      description: fields[8] as String?,
      date: fields[4] as DateTime?,
      time: fields[3] as String?,
      taskTitle: fields[5] as String?,
      repeat: (fields[7] as Map?)?.cast<dynamic, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, TodoTask obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.task)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.taskTitle)
      ..writeByte(6)
      ..write(obj.color)
      ..writeByte(7)
      ..write(obj.repeat)
      ..writeByte(8)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
