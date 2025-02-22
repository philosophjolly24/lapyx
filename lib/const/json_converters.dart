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

const _agentTypeEnumMap = {
  AgentType.jett: 'jett',
  AgentType.raze: 'raze',
  AgentType.pheonix: 'pheonix',
  AgentType.astra: 'astra',
  AgentType.clove: 'clove',
  AgentType.breach: 'breach',
  AgentType.iso: 'iso',
  AgentType.viper: 'viper',
  AgentType.deadlock: 'deadlock',
  AgentType.yoru: 'yoru',
  AgentType.sova: 'sova',
  AgentType.skye: 'skye',
  AgentType.kayo: 'kayo',
  AgentType.killjoy: 'killjoy',
  AgentType.brimstone: 'brimstone',
  AgentType.cypher: 'cypher',
  AgentType.chamber: 'chamber',
  AgentType.fade: 'fade',
  AgentType.gekko: 'gekko',
  AgentType.harbor: 'harbor',
  AgentType.neon: 'neon',
  AgentType.omen: 'omen',
  AgentType.reyna: 'reyna',
  AgentType.sage: 'sage',
  AgentType.vyse: 'vyse',
  AgentType.tejo: 'tejo',
};

class AbilityInfoConverter
    implements JsonConverter<AbilityInfo, Map<String, dynamic>> {
  const AbilityInfoConverter();

  @override
  AbilityInfo fromJson(Map<String, dynamic> json) {
    final info = AgentData.agents[$enumDecode(_agentTypeEnumMap, json["type"])]!
        .abilities[json["index"] as int];
    return info;
  }

  @override
  Map<String, dynamic> toJson(AbilityInfo abilityInfo) {
    return {
      'type': _agentTypeEnumMap[abilityInfo.type],
      'index': abilityInfo.index
    };
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
