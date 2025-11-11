// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssignmentModelAdapter extends TypeAdapter<AssignmentModel> {
  @override
  final int typeId = 4;

  @override
  AssignmentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssignmentModel(
      id: fields[0] as String,
      killerId: fields[1] as String,
      victimId: fields[2] as String,
      weaponId: fields[3] as String?,
      locationId: fields[4] as String?,
      isRevealed: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AssignmentModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.killerId)
      ..writeByte(2)
      ..write(obj.victimId)
      ..writeByte(3)
      ..write(obj.weaponId)
      ..writeByte(4)
      ..write(obj.locationId)
      ..writeByte(5)
      ..write(obj.isRevealed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssignmentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
