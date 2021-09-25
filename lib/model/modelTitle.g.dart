// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modelTitle.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoTitleAdapter extends TypeAdapter<TodoTitle> {
  @override
  final int typeId = 0;

  @override
  TodoTitle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoTitle(
      title: fields[1] as String,
      color: fields[2] as int?,
      id: fields[0] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, TodoTitle obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoTitleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
