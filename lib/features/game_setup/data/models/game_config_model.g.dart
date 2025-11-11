// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_config_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameConfigModelAdapter extends TypeAdapter<GameConfigModel> {
  @override
  final int typeId = 3;

  @override
  GameConfigModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameConfigModel(
      playerModels: (fields[0] as List).cast<PlayerModel>(),
      createdAt: fields[1] as DateTime,
      requireWeapon: fields[2] as bool,
      requireLocation: fields[3] as bool,
      customWeapons: (fields[4] as List?)?.cast<String>(),
      customLocations: (fields[5] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, GameConfigModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.playerModels)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.requireWeapon)
      ..writeByte(3)
      ..write(obj.requireLocation)
      ..writeByte(4)
      ..write(obj.customWeapons)
      ..writeByte(5)
      ..write(obj.customLocations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameConfigModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
