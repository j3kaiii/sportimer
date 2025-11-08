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
    );
  }

  @override
  void write(BinaryWriter writer, Sequence obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
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
