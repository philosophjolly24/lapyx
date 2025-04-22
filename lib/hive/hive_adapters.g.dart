// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class StrategyDataAdapter extends TypeAdapter<StrategyData> {
  @override
  final int typeId = 0;

  @override
  StrategyData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StrategyData(
      drawingData: (fields[1] as List).cast<DrawingElement>(),
      agentData: (fields[2] as List).cast<PlacedAgent>(),
      abilityData: (fields[3] as List).cast<PlacedAbility>(),
      textData: (fields[4] as List).cast<PlacedText>(),
      imageData: (fields[5] as List).cast<PlacedImage>(),
      mapData: fields[6] as MapValue,
      versionNumber: (fields[0] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, StrategyData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.versionNumber)
      ..writeByte(1)
      ..write(obj.drawingData)
      ..writeByte(2)
      ..write(obj.agentData)
      ..writeByte(3)
      ..write(obj.abilityData)
      ..writeByte(4)
      ..write(obj.textData)
      ..writeByte(5)
      ..write(obj.imageData)
      ..writeByte(6)
      ..write(obj.mapData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StrategyDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
