import 'package:flutter/material.dart';
import 'package:icarus/widgets/ability_widgets.dart';
import 'package:icarus/const/coordinate_system.dart';

enum AgentType {
  jett,
  raze,
  pheonix,
  astra,
  // clove,
  breach,
  // iso,
  viper,
  // deadlock,
  yoru,
  sova,
  skye,
  kayo,
  killjoy,
  brimstone,
  cypher,
  chamber,
  fade,
  // gekko,
  // harbor,
  neon,
  omen,
  reyna,
  sage
  // vyse,
}

enum AgentRole { controller, duelist, initiator, sentinel }

abstract class DraggableData {}

class AbilityInfo implements DraggableData {
  final String name;
  final bool hasSpecialInteraction;
  final String iconPath;
  Widget Function(CoordinateSystem)? abilityWidgetBuilder;
  String? imagePath;
  double? width;

  AbilityInfo(
      {required this.name,
      required this.hasSpecialInteraction,
      required this.iconPath,
      this.imagePath,
      this.abilityWidgetBuilder,
      required this.width});
}

class AgentData implements DraggableData {
  final AgentType type;
  final AgentRole role;
  List<AbilityInfo> abilities;
  final String name;
  late final String iconPath;

  AgentData({
    required this.type,
    required this.role,
    required this.name,
  })  : iconPath = 'assets/agents/$name/icon.png',
        abilities = List.generate(
          4,
          (index) => AbilityInfo(
            name: 'Ability ${index + 1}', // You can override this later
            hasSpecialInteraction: false, // Default value, override as needed
            iconPath: 'assets/agents/$name/${index + 1}.png',
            imagePath: null,
            width: null,
          ),
        );

  static Map<AgentType, AgentData> agents = {
    AgentType.jett: AgentData(
      type: AgentType.jett,
      role: AgentRole.duelist,
      name: "Jett",
    )..abilities[0] =
          // Override the default abilities
          AbilityInfo(
        name: "Cloudburst",
        hasSpecialInteraction: false,
        iconPath: 'assets/agents/Jett/1.png',
        imagePath: 'assets/agents/Jett/Smoke.png', // Custom image for smoke
        width: 30,
      ),
    AgentType.raze: AgentData(
      type: AgentType.raze,
      role: AgentRole.duelist,
      name: "Raze",
    ),
    AgentType.pheonix: AgentData(
      type: AgentType.pheonix,
      role: AgentRole.duelist,
      name: "Phoenix",
    ),
    AgentType.astra: AgentData(
      type: AgentType.astra,
      role: AgentRole.controller,
      name: "Astra",
    ),
    AgentType.breach: AgentData(
      type: AgentType.breach,
      role: AgentRole.initiator,
      name: "Breach",
    ),
    AgentType.viper: AgentData(
      type: AgentType.viper,
      role: AgentRole.controller,
      name: "Viper",
    ),
    AgentType.yoru: AgentData(
      type: AgentType.yoru,
      role: AgentRole.duelist,
      name: "Yoru",
    ),
    AgentType.sova: AgentData(
      type: AgentType.sova,
      role: AgentRole.initiator,
      name: "Sova",
    )..abilities[2].abilityWidgetBuilder = AbilityWidgets.customCircleAbility(
        247,
        const Color.fromARGB(255, 1, 131, 237),
        const Color.fromARGB(255, 1, 131, 237),
        true),
    AgentType.skye: AgentData(
      type: AgentType.skye,
      role: AgentRole.initiator,
      name: "Skye",
    ),
    AgentType.kayo: AgentData(
      type: AgentType.kayo,
      role: AgentRole.initiator,
      name: "Kayo",
    ),
    AgentType.killjoy: AgentData(
      type: AgentType.killjoy,
      role: AgentRole.sentinel,
      name: "Killjoy",
    ),
    AgentType.brimstone: AgentData(
      type: AgentType.brimstone,
      role: AgentRole.controller,
      name: "Brimstone",
    )..abilities[3].abilityWidgetBuilder = AbilityWidgets.customCircleAbility(
        67, Colors.red, Colors.red, false, 135),
    AgentType.cypher: AgentData(
      type: AgentType.cypher,
      role: AgentRole.sentinel,
      name: "Cypher",
    ),
    AgentType.chamber: AgentData(
      type: AgentType.chamber,
      role: AgentRole.sentinel,
      name: "Chamber",
    ),
    AgentType.fade: AgentData(
      type: AgentType.fade,
      role: AgentRole.initiator,
      name: "Fade",
    ),
    AgentType.neon: AgentData(
      type: AgentType.neon,
      role: AgentRole.duelist,
      name: "Neon",
    ),
    AgentType.omen: AgentData(
      type: AgentType.omen,
      role: AgentRole.controller,
      name: "Omen",
    ),
    AgentType.reyna: AgentData(
      type: AgentType.reyna,
      role: AgentRole.duelist,
      name: "Reyna",
    ),
    AgentType.sage: AgentData(
      type: AgentType.sage,
      role: AgentRole.sentinel,
      name: "Sage",
    ),
  };
}

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

  PlacedAbility({required this.data, required super.position});
}
