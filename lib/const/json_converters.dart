// Create a reusable converter
import 'package:flutter/material.dart';
import 'package:icarus/const/agents.dart';
import 'package:json_annotation/json_annotation.dart';

class OffsetConverter implements JsonConverter<Offset, Map<String, dynamic>> {
  const OffsetConverter();

  @override
  Offset fromJson(Map<String, dynamic> json) {
    return Offset(json['dx'] as double, json['dy'] as double);
  }

  @override
  Map<String, dynamic> toJson(Offset offset) {
    return {'dx': offset.dx, 'dy': offset.dy};
  }
}

class AbilityInfoConverter
    implements JsonConverter<AbilityInfo, Map<String, dynamic>> {
  const AbilityInfoConverter();

  @override
  AbilityInfo fromJson(Map<String, dynamic> json) {
    return AgentData
        .agents[json["type"] as AgentType]!.abilities[json["index"] as int];
  }

  @override
  Map<String, dynamic> toJson(AbilityInfo abilityInfo) {
    return {'type': abilityInfo.type, 'index': abilityInfo.index};
  }
}

class OffsetListConverter
    implements JsonConverter<List<Offset>, List<dynamic>> {
  const OffsetListConverter();
  final _offsetConverter = const OffsetConverter();

  @override
  List<Offset> fromJson(List<dynamic> json) {
    return json
        .map((pointJson) =>
            _offsetConverter.fromJson(pointJson as Map<String, dynamic>))
        .toList();
  }

  @override
  List<dynamic> toJson(List<Offset> offsets) {
    return offsets.map(_offsetConverter.toJson).toList();
  }
}
