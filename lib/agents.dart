import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum AgentType {
  jett,
  // raze,
  // pheonix,
  // astra,
  // clove,
  // breach,
  // iso,
  // viper,
  // deadlock,
  // yoru,
  // sova,
  // skye,
  // vyse,
  // kayo,
  // killjoy,
  // brimstone,
  // cypher,
  // chamber,
  // fade,
  // gekko,
  // harbor,
  // neon,
  // omen,
  // reyna,
  // sage
}

enum AgentRole { controller, duelist, initiator, sentinel }

class AbilityInfo {
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

class AgentData {
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
  };
}

class PlacedAgent {
  final AgentData data;
  Offset position;

  PlacedAgent({required this.data, required this.position});

  void updatePosition(Offset newPosition) {
    position = newPosition;
  }
}
