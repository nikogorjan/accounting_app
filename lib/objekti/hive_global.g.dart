// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_global.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveGlobalAdapter extends TypeAdapter<HiveGlobal> {
  @override
  final int typeId = 1;

  @override
  HiveGlobal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveGlobal(
      email: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveGlobal obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveGlobalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
