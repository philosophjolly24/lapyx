import 'package:flutter/material.dart';
import 'package:icarus/const/agents.dart';

class PlacedWidget {
  Offset position;

  PlacedWidget({required this.position});

  void updatePosition(Offset newPosition) {
    position = newPosition;
  }
}

class PlacedAgent extends PlacedWidget {
  final AgentData data;

  PlacedAgent({required this.data, required super.position});
}

class PlacedAbility extends PlacedWidget {
  final AbilityInfo data;
  double rotaion = 0;
  PlacedAbility({required this.data, required super.position});
}
