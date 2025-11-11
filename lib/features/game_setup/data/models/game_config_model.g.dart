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
    );
  }

  @override
  void write(BinaryWriter writer, GameConfigModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.playerModels)
      ..writeByte(1)
      ..write(obj.createdAt);
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
