import 'package:flutter/material.dart';
import 'package:icarus/widgets/ability/ability_widget.dart';
import 'package:icarus/widgets/ability/custom_circle_widget.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/widgets/ability/custom_square_widget.dart';

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
  Widget Function()? abilityWidget;
  final String? imagePath;
  final double? width;
  bool isTransformable = false;
  Offset? centerPoint;

  AbilityInfo({
    required this.name,
    required this.iconPath,
    this.imagePath,
    this.abilityWidget,
    this.width,
  });

  AbilityInfo copyWith({
    String? name,
    bool? hasSpecialInteraction,
    String? iconPath,
    Widget Function()? abilityWidget,
    String? imagePath,
    double? width,
    Offset? centerPoint,
  }) {
    return AbilityInfo(
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      imagePath: imagePath ?? this.imagePath,
      abilityWidget: abilityWidget ?? this.abilityWidget,
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

  static const double inGameMeters = 4.952941176470588;
  static const double inGameMetersDiameter = inGameMeters * 2;
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
    AgentType.sova: (() {
      final coordinateSystem = CoordinateSystem.instance;
      AgentData agent = AgentData(
        type: AgentType.sova,
        role: AgentRole.initiator,
        name: "Sova",
      );

      const double size = 30 * inGameMetersDiameter;

      agent.abilities[2].abilityWidget = () {
        double scaleSize = coordinateSystem.scale(size);
        Offset centerPoint = Offset(scaleSize / 2, scaleSize / 2);

        agent.abilities[2].centerPoint = centerPoint;

        return CustomCircleWidget(
          abilityInfo: agent.abilities[2],
          size: size,
          outlineColor: const Color.fromARGB(255, 1, 131, 237),
          hasCenterDot: true,
          isDouble: false,
        );
      };
      return agent;
    })(),

    // CustomCircleWidget(
    //     297.17,
    //     const Color.fromARGB(255, 1, 131, 237),
    //     true,
    //     false,
    //   ),
    AgentType.skye: AgentData(
      type: AgentType.skye,
      role: AgentRole.initiator,
      name: "Skye",
    ),
    AgentType.kayo: (() {
      AgentData agent = AgentData(
        type: AgentType.kayo,
        role: AgentRole.initiator,
        name: "Kayo",
      );

      //Ultimate
      agent.abilities[3].abilityWidget = () => CustomCircleWidget(
            abilityInfo: agent.abilities[3],
            size: 42.5 * inGameMetersDiameter,
            outlineColor: const Color.fromARGB(255, 140, 6, 163),
            hasCenterDot: true,
            isDouble: false,
          );

      agent.abilities[2].abilityWidget = () => CustomCircleWidget(
            abilityInfo: agent.abilities[2],
            size: 15 * inGameMetersDiameter,
            outlineColor: const Color.fromARGB(255, 106, 14, 182),
            hasCenterDot: true,
            isDouble: false,
          );

      // CustomCircleWidget(
      //     148.59, const Color.fromARGB(255, 106, 14, 182), true, false);
      return agent;
    })(),

    AgentType.killjoy: (() {
      AgentData agent = AgentData(
        type: AgentType.killjoy,
        role: AgentRole.sentinel,
        name: "Killjoy",
      );

      //Ultimate
      agent.abilities[3].abilityWidget = () => CustomCircleWidget(
            abilityInfo: agent.abilities[3],
            size: 32.5 * inGameMetersDiameter,
            outlineColor: const Color.fromARGB(255, 106, 14, 182),
            hasCenterDot: true,
            isDouble: false,
          );

      //(40*2) * inGameMeters
      //Alarmbot
      agent.abilities[1].abilityWidget = () => CustomCircleWidget(
            abilityInfo: agent.abilities[1],
            size: 40 * inGameMetersDiameter,
            outlineColor: Colors.white,
            hasCenterDot: true,
            isDouble: true,
            innerSize: 54.48,
            innerColor: const Color.fromARGB(255, 106, 14, 182),
          );
      return agent;
    })(),

    AgentType.brimstone: (() {
      final agent = AgentData(
        type: AgentType.brimstone,
        role: AgentRole.controller,
        name: "Brimstone",
      );

      //Ultimate
      agent.abilities[3].abilityWidget = () => CustomCircleWidget(
            abilityInfo: agent.abilities[3],
            size: 9 * inGameMetersDiameter,
            outlineColor: Colors.red,
            hasCenterDot: false,
            isDouble: false,
          );

      //Stim Beacon
      agent.abilities[0].abilityWidget = () => CustomCircleWidget(
            abilityInfo: agent.abilities[0],
            size: 6 * inGameMetersDiameter,
            outlineColor: const Color.fromARGB(255, 97, 253, 131),
            hasCenterDot: false,
            isDouble: false,
          );
      return agent;
    })(),

    AgentType.cypher: (() {
      final agent = AgentData(
        type: AgentType.cypher,
        role: AgentRole.sentinel,
        name: "Cypher",
      );

      agent.abilities[1].abilityWidget = () => CustomCircleWidget(
            abilityInfo: agent.abilities[1],
            size: 3.72 * inGameMetersDiameter,
            outlineColor: Colors.white,
            hasCenterDot: false,
            isDouble: false,
          );
      return agent;
    })(),
    AgentType.chamber: (() {
      final agent = AgentData(
        type: AgentType.fade,
        role: AgentRole.initiator,
        name: "Chamber",
      );

      agent.abilities[0].abilityWidget = () => CustomCircleWidget(
            abilityInfo: agent.abilities[0],
            size: 50 * inGameMetersDiameter,
            outlineColor: Colors.white,
            hasCenterDot: true,
            isDouble: true,
            innerSize: 10 * inGameMetersDiameter,
            innerColor: Colors.amber,
          );

      agent.abilities[1].isTransformable = true;
      agent.abilities[1].abilityWidget = () => CustomSquareWidget(
            color: Colors.white,
            abilityInfo: agent.abilities[1],
          );

      agent.abilities[2].abilityWidget = () => CustomCircleWidget(
            abilityInfo: agent.abilities[2],
            size: 18 * inGameMetersDiameter,
            outlineColor: Colors.amber,
            hasCenterDot: true,
            isDouble: false,
          );
      return agent;
    })(),
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
