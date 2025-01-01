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

// Virtual distance to valorant distance is valmeters * 4.952941176470588 = vitual distance
class AbilityInfo implements DraggableData {
  final String name;
  final String iconPath;
  Widget Function(CoordinateSystem, AbilityInfo)? abilityWidgetBuilder;
  final String? imagePath;
  final double? width;
  Offset? centerPoint;

  AbilityInfo({
    required this.name,
    required this.iconPath,
    this.imagePath,
    this.abilityWidgetBuilder,
    this.centerPoint,
    this.width,
  });

  AbilityInfo copyWith({
    String? name,
    bool? hasSpecialInteraction,
    String? iconPath,
    Widget Function(CoordinateSystem, AbilityInfo)? abilityWidgetBuilder,
    String? imagePath,
    double? width,
    Offset? centerPoint,
  }) {
    return AbilityInfo(
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      imagePath: imagePath ?? this.imagePath,
      abilityWidgetBuilder: abilityWidgetBuilder ?? this.abilityWidgetBuilder,
      centerPoint: centerPoint ?? this.centerPoint,
      width: width ?? this.width,
    );
  }

  void updateCenterPoint(Offset centerPoint) {
    this.centerPoint = centerPoint;
  }
}

class AgentData implements DraggableData {
  final AgentType type;
  final AgentRole role;
  List<AbilityInfo> abilities;
  final String name;
  final String iconPath;

  AgentData({
    required this.type,
    required this.role,
    required this.name,
  })  : iconPath = 'assets/agents/$name/icon.png',
        abilities = List.generate(
          4,
          (index) => AbilityInfo(
            name: 'Ability ${index + 1}', // You can override this later
            iconPath: 'assets/agents/$name/${index + 1}.png',
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
        297.17,
        const Color.fromARGB(255, 1, 131, 237),
        true,
        false,
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
    )
      ..abilities[3].abilityWidgetBuilder = AbilityWidgets.customCircleAbility(
          421, const Color.fromARGB(255, 140, 6, 163), true, false)
      ..abilities[2].abilityWidgetBuilder = AbilityWidgets.customCircleAbility(
          148.59, const Color.fromARGB(255, 106, 14, 182), true, false),
    AgentType.killjoy: AgentData(
      type: AgentType.killjoy,
      role: AgentRole.sentinel,
      name: "Killjoy",
    )..abilities[3].abilityWidgetBuilder = AbilityWidgets.customCircleAbility(
        321.94, const Color.fromARGB(255, 106, 14, 182), true, false),
    AgentType.brimstone: AgentData(
      type: AgentType.brimstone,
      role: AgentRole.controller,
      name: "Brimstone",
    )..abilities[3].abilityWidgetBuilder =
        AbilityWidgets.customCircleAbility(72, Colors.red, false, false, 135),
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
