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

  @JsonKey(includeToJson: false, includeFromJson: false)
  List<WidgetAction> actionHistory = [];

  @JsonKey(includeToJson: false, includeFromJson: false)
  List<WidgetAction> poppedAction = [];

  @OffsetConverter()
  Offset position;

  void updatePosition(Offset newPosition) {
    final action = PositionAction(position: position);
    actionHistory.add(action);
    position = newPosition;
  }

  void undoAction() {
    if (actionHistory.isEmpty) return;

    if (actionHistory.last is PositionAction) {
      _undoPosition();
    }
  }

  void _undoPosition() {
    final action = PositionAction(position: position);

    poppedAction.add(action);
    position = (actionHistory.last as PositionAction).position;
    actionHistory.removeLast();
  }

  void redoAction() {
    if (poppedAction.isEmpty) return;

    if (poppedAction.last is PositionAction) {
      _redoPosition();
    }
  }

  void _redoPosition() {
    final action = PositionAction(position: position);

    actionHistory.add(action);
    position = (poppedAction.last as PositionAction).position;
    poppedAction.removeLast();
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

class PlacedImage extends PlacedWidget {
  PlacedImage(
      {required super.position, required super.id, required this.image});

  Image image;
  String text = "";

  void updateText(String newText) {
    text = newText;
  }
}

@JsonSerializable()
class PlacedAgent extends PlacedWidget {
  final AgentType type;
  @JsonKey(defaultValue: true)
  final bool isAlly;

  PlacedAgent({
    required this.type,
    required super.position,
    required super.id,
    this.isAlly = true, // Default parameter value
  });

  factory PlacedAgent.fromJson(Map<String, dynamic> json) =>
      _$PlacedAgentFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PlacedAgentToJson(this);
}

@JsonSerializable()
class PlacedAbility extends PlacedWidget {
  @AbilityInfoConverter()
  final AbilityInfo data;

  @JsonKey(defaultValue: true)
  final bool isAlly;

  double rotation = 0;

  void updateRotation(double newRotation) {
    rotation = newRotation;
  }

  void updateRotationHistory() {
    final action = RotationAction(rotation: rotation);
    actionHistory.add(action);
  }

  @override
  void undoAction() {
    if (actionHistory.isEmpty) return;

    if (actionHistory.last is PositionAction) {
      _undoPosition();
    } else if (actionHistory.last is RotationAction) {
      _undoRotation();
    }
  }

  @override
  void redoAction() {
    if (poppedAction.isEmpty) return;

    if (poppedAction.last is PositionAction) {
      _redoPosition();
    } else if (poppedAction.last is RotationAction) {
      _redoRotation();
    }
  }

  void _undoRotation() {
    final action = RotationAction(rotation: rotation);

    poppedAction.add(action);
    rotation = (actionHistory.last as RotationAction).rotation;
    actionHistory.removeLast();
  }

  void _redoRotation() {
    if (poppedAction.isEmpty) return;

    final action = RotationAction(rotation: rotation);

    actionHistory.add(action);
    rotation = (poppedAction.last as RotationAction).rotation;
    poppedAction.removeLast();
  }

  PlacedAbility(
      {required this.data,
      required super.position,
      required super.id,
      this.isAlly = true});

  factory PlacedAbility.fromJson(Map<String, dynamic> json) =>
      _$PlacedAbilityFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PlacedAbilityToJson(this);
}

abstract class WidgetAction {}

class RotationAction extends WidgetAction {
  final double rotation;

  RotationAction({required this.rotation});
}

class PositionAction extends WidgetAction {
  final Offset position;

  PositionAction({required this.position});
}
