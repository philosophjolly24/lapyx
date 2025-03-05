import 'package:flutter/material.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/json_converters.dart';
import 'package:json_annotation/json_annotation.dart';

part "placed_classes.g.dart";

@JsonSerializable()
class PlacedWidget {
  PlacedWidget({
    required this.position,
    required this.id,
  });
  final String id;
  @OffsetConverter()
  Offset position;

  void updatePosition(Offset newPosition) {
    position = newPosition;
  }

  factory PlacedWidget.fromJson(Map<String, dynamic> json) =>
      _$PlacedWidgetFromJson(json);
  Map<String, dynamic> toJson() => _$PlacedWidgetToJson(this);
}

//TODO: Make this build runner compatable
class PlacedText extends PlacedWidget {
  PlacedText({required super.position, required super.id});

  String text = "";
}

@JsonSerializable()
class PlacedAgent extends PlacedWidget {
  final AgentType type;

  PlacedAgent({required this.type, required super.position, required super.id});

  factory PlacedAgent.fromJson(Map<String, dynamic> json) =>
      _$PlacedAgentFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PlacedAgentToJson(this);
}

@JsonSerializable()
class PlacedAbility extends PlacedWidget {
  @AbilityInfoConverter()
  final AbilityInfo data;

  double rotation = 0;

  PlacedAbility(
      {required this.data, required super.position, required super.id});

  factory PlacedAbility.fromJson(Map<String, dynamic> json) =>
      _$PlacedAbilityFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PlacedAbilityToJson(this);
}
