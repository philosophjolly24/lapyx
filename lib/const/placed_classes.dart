import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @JsonKey(includeToJson: false, includeFromJson: false)
  List<Offset> positionHistory = [];

  @JsonKey(includeToJson: false, includeFromJson: false)
  List<Offset> poppedPosition = [];

  @OffsetConverter()
  Offset position;

  void updatePosition(Offset newPosition) {
    positionHistory.add(position);
    position = newPosition;

    log(positionHistory.toString());
  }

  void undoPosition() {
    if (positionHistory.isEmpty) return;

    poppedPosition.add(position);
    position = positionHistory.last;
    positionHistory.removeLast();
  }

  void redoPosition() {
    if (poppedPosition.isEmpty) return;

    positionHistory.add(position);
    position = poppedPosition.last;
    poppedPosition.removeLast();
  }

  factory PlacedWidget.fromJson(Map<String, dynamic> json) =>
      _$PlacedWidgetFromJson(json);
  Map<String, dynamic> toJson() => _$PlacedWidgetToJson(this);

  static int getIndexByID(String id, List<PlacedWidget> elements) {
    return elements.indexWhere(
      (element) => element.id == id,
    );
  }
}

@JsonSerializable()
class PlacedText extends PlacedWidget {
  PlacedText({required super.position, required super.id});

  String text = "";
  double? size;

  factory PlacedText.fromJson(Map<String, dynamic> json) =>
      _$PlacedTextFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PlacedTextToJson(this);
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
