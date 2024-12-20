import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icarus/interactive_map.dart';

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
  final Widget abilityWidget;

  AbilityInfo({
    required this.name,
    required this.hasSpecialInteraction,
    required this.iconPath,
    required this.abilityWidget,
  });
}

class AbilityWidgets {
  static Widget defaultWidget(String iconPath) {
    return Container(
      color: Colors.black,
      child: Image.asset(iconPath),
    );
  }
}

class AgentData implements DraggableData {
  final AgentType type;
  final AgentRole role;
  final List<AbilityInfo> abilities;
  final String name;
  late final String iconPath;

  //TODO:Abilities should be widgets as they are far more complicated than initially thought

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
            abilityWidget: AbilityWidgets.defaultWidget(
                'assets/agents/$name/${index + 1}.png'),
          ),
        );

  static Map<AgentType, AgentData> agents = {
    AgentType.jett: AgentData(
      type: AgentType.jett,
      role: AgentRole.duelist,
      name: "Jett",
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
    ),
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
    ),
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

Widget agentWidget(AgentData agent, CoordinateSystem coordinateSystem) {
  return ClipRRect(
    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
    child: Container(
      color: const Color.fromARGB(255, 56, 56, 56),
      width: coordinateSystem.scale(30),
      child: Image.asset(agent.iconPath),
    ),
  );
}

Widget defaultAbilityWidget(
    AbilityInfo ability, CoordinateSystem coordinateSystem) {
  return ClipRRect(
    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
    child: Container(
      color: const Color.fromARGB(255, 56, 56, 56),
      width: coordinateSystem.scale(30),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Image.asset(ability.iconPath),
      ),
    ),
  );
}

Widget scaledContainer(Widget widget, CoordinateSystem coordinateSystem) {
  return SizedBox(
    width:
        coordinateSystem.scale(30), // Set a consistent size for placed agents
    height: coordinateSystem.scale(30),
    child: widget,
  );
}
