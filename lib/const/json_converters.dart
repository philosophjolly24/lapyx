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

/// A JsonConverter that converts between Color and String hex representation
class ColorConverter implements JsonConverter<Color, String> {
  const ColorConverter();

  @override
  Color fromJson(String json) {
    // Handle null or empty string

    // Remove the hash if it exists
    final hexColor = json.startsWith('#') ? json.substring(1) : json;

    // Parse the hex string to an integer
    final intColor = int.parse(hexColor, radix: 16);

    // If the hex is 6 digits (RRGGBB), add the alpha channel
    if (hexColor.length == 6) {
      return Color.fromARGB(
        255,
        (intColor >> 16) & 0xFF,
        (intColor >> 8) & 0xFF,
        intColor & 0xFF,
      );
    }

    // If the hex is 8 digits (AARRGGBB)
    return Color.fromARGB(
      (intColor >> 24) & 0xFF,
      (intColor >> 16) & 0xFF,
      (intColor >> 8) & 0xFF,
      intColor & 0xFF,
    );
  }

  @override
  String toJson(Color color) {
    // Handle null color

    // Convert to hex string using component accessors
    return '#${color.a.toRadixString(16).padLeft(2, '0')}'
        '${color.red.toRadixString(16).padLeft(2, '0')}'
        '${color.green.toRadixString(16).padLeft(2, '0')}'
        '${color.blue.toRadixString(16).padLeft(2, '0')}';

    // Alternative: if you want to exclude alpha channel:
    // return '#${color.red.toRadixString(16).padLeft(2, '0')}'
    //        '${color.green.toRadixString(16).padLeft(2, '0')}'
    //        '${color.blue.toRadixString(16).padLeft(2, '0')}';
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
