// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weapon_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeaponModelAdapter extends TypeAdapter<WeaponModel> {
  @override
  final int typeId = 0;

  @override
  WeaponModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeaponModel(
      id: fields[0] as String,
      name: fields[1] as String,
      isCustom: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WeaponModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.isCustom);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeaponModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
