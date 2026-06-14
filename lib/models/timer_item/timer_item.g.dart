// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimerItemAdapter extends TypeAdapter<TimerItem> {
  @override
  final int typeId = 0;

  @override
  TimerItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimerItem(
      id: fields[0] as String,
      seconds: fields[1] as int,
      position: fields[2] as int,
      sequenceId: fields[3] as String,
      isRest: fields[4] as bool,
    ).._difficultyIndex = fields[5] as int?;
  }

  @override
  void write(BinaryWriter writer, TimerItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.seconds)
      ..writeByte(2)
      ..write(obj.position)
      ..writeByte(3)
      ..write(obj.sequenceId)
      ..writeByte(4)
      ..write(obj.isRest)
      ..writeByte(5)
      ..write(obj._difficultyIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
