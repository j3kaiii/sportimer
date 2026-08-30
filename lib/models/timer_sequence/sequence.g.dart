// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sequence.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SequenceAdapter extends TypeAdapter<Sequence> {
  @override
  final int typeId = 1;

  @override
  Sequence read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sequence(
      fields[0] as String,
      fields[1] as String,
      fields[2] as int,
      repeats: fields[3] as int? ?? 1,
    );
  }

  @override
  void write(BinaryWriter writer, Sequence obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.position)
      ..writeByte(3)
      ..write(obj.repeats);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SequenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
