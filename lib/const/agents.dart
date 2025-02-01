import 'package:flutter/material.dart';
import 'package:icarus/widgets/ability/custom_circle_widget.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/widgets/ability/custom_square_widget.dart';

enum AgentType {
  jett,
  raze,
  pheonix,
  astra,
  clove,
  breach,
  iso,
  viper,
  deadlock,
  yoru,
  sova,
  skye,
  kayo,
  killjoy,
  brimstone,
  cypher,
  chamber,
  fade,
  gekko,
  harbor,
  neon,
  omen,
  reyna,
  sage,
  vyse,
  tejo,
}

enum AgentRole { controller, duelist, initiator, sentinel }

abstract class DraggableData {}

// Virtual distance to valorant distance is valmeters * 4.952941176470588 = vitual distance
class AbilityInfo implements DraggableData {
  final String name;
  final String iconPath;
  Widget Function([double rotation])? abilityWidget;
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
    Widget Function([double rotation])? abilityWidget,
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
    AgentType.astra: (() {
      final agent = AgentData(
        type: AgentType.astra,
        role: AgentRole.controller,
        name: "Astra",
      )..abilities[2] = AbilityInfo(
          name: "Nebula",
          iconPath: 'assets/agents/Astra/1.png',
          imagePath: 'assets/agents/Astra/Smoke.png', // Custom image for smoke
          width: 4.75 * inGameMetersDiameter,
        );

      agent.abilities.first.abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities.first,
                size: 4.75 * inGameMetersDiameter,
                outlineColor: Colors.purple,
                hasCenterDot: true,
                isDouble: false,
              );
      agent.abilities[1].abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities[1],
                size: 4.75 * inGameMetersDiameter,
                outlineColor: Colors.purple,
                hasCenterDot: true,
                isDouble: false,
              );

      return agent;
    })(),
    AgentType.breach: (() {
      final agent = AgentData(
        type: AgentType.breach,
        role: AgentRole.initiator,
        name: "Breach",
      );

      agent.abilities.first.isTransformable = true;
      agent.abilities.first.abilityWidget =
          ([double? rotation]) => CustomSquareWidget(
                color: Colors.orangeAccent,
                abilityInfo: agent.abilities.first,
                width: 3 * inGameMetersDiameter,
                height: 10 * inGameMeters,
                rotation: rotation,
              );

      agent.abilities.last.isTransformable = true;
      agent.abilities.last.abilityWidget =
          ([double? rotation]) => CustomSquareWidget(
                color: Colors.orangeAccent,
                abilityInfo: agent.abilities.last,
                width: 23 * inGameMeters,
                height: 32 * inGameMeters,
                distanceBetweenAOE: 8 * inGameMeters,
              );

      return agent;
    })(),
    AgentType.viper: (() {
      final agent = AgentData(
        type: AgentType.viper,
        role: AgentRole.controller,
        name: "Viper",
      )..abilities[1] =
            // Override the default abilities
            AbilityInfo(
          name: "Sky Smoke",
          iconPath: 'assets/agents/Viper/2.png',
          imagePath: 'assets/agents/Viper/Smoke.png', // Custom image for smoke
          width: 4.5 * inGameMetersDiameter,
        );

      agent.abilities.first.abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities.first,
                size: 4.5 * inGameMetersDiameter,
                outlineColor: Colors.greenAccent,
                hasCenterDot: true,
                isDouble: false,
              );
      return agent;
    })(),
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

      agent.abilities[2].abilityWidget = ([double? rotation]) {
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

      agent.abilities.last.isTransformable = true;
      agent.abilities.last.abilityWidget =
          ([double? rotation]) => CustomSquareWidget(
                color: const Color.fromARGB(255, 1, 131, 237),
                abilityInfo: agent.abilities.last,
                width: 1.76 * inGameMetersDiameter,
                height: 66 * inGameMeters,
              );
      return agent;
    })(),
    AgentType.skye: (() {
      final agent = AgentData(
        type: AgentType.skye,
        role: AgentRole.initiator,
        name: "Skye",
      );

      //Heal
      agent.abilities.first.abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities.first,
                size: 18 * inGameMetersDiameter,
                outlineColor: Colors.green,
                hasCenterDot: true,
                isDouble: false,
              );

      return agent;
    })(),
    AgentType.kayo: (() {
      AgentData agent = AgentData(
        type: AgentType.kayo,
        role: AgentRole.initiator,
        name: "Kayo",
      );

      agent.abilities.first.abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities.first,
                size: 5 * inGameMetersDiameter,
                outlineColor: const Color(0xFF8C06A3),
                hasCenterDot: true,
                isDouble: false,
              );
      //Ultimate
      agent.abilities[3].abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities[3],
                size: 42.5 * inGameMetersDiameter,
                outlineColor: const Color(0xFF8C06A3),
                hasCenterDot: true,
                isDouble: false,
              );

      agent.abilities[2].abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
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

      agent.abilities.first.abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities.first,
                size: 4.5 * inGameMetersDiameter,
                outlineColor: const Color(0xFF6A0EB6),
                hasCenterDot: true,
                isDouble: false,
              );
      //Ultimate
      agent.abilities[3].abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities[3],
                size: 32.5 * inGameMetersDiameter,
                outlineColor: const Color(0xFF6A0EB6),
                hasCenterDot: true,
                isDouble: false,
              );

      //(40*2) * inGameMeters
      //Alarmbot
      agent.abilities[1].abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
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
      )..abilities[2] =
            // Override the default abilities
            AbilityInfo(
          name: "Sky Smoke",
          iconPath: 'assets/agents/Brimstone/3.png',
          imagePath:
              'assets/agents/Brimstone/Smoke.png', // Custom image for smoke
          width: 4.15 * inGameMetersDiameter,
        );

      agent.abilities[1].abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities[1],
                size: 4.5 * inGameMetersDiameter,
                outlineColor: Colors.red,
                hasCenterDot: true,
                isDouble: false,
              );
      //Ultimate
      agent.abilities.last.abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities[3],
                size: 9 * inGameMetersDiameter,
                outlineColor: Colors.red,
                hasCenterDot: true,
                isDouble: false,
              );

      //Stim Beacon
      agent.abilities.first.abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities[0],
                size: 6 * inGameMetersDiameter,
                outlineColor: const Color.fromARGB(255, 97, 253, 131),
                hasCenterDot: true,
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

      agent.abilities[1].abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
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
        type: AgentType.chamber,
        role: AgentRole.initiator,
        name: "Chamber",
      );

      agent.abilities[0].abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities[0],
                size: 50 * inGameMetersDiameter,
                outlineColor: Colors.white,
                hasCenterDot: true,
                isDouble: true,
                innerSize: 10 * inGameMetersDiameter,
                innerColor: Colors.amber,
              );

      agent.abilities[2].abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities[2],
                size: 18 * inGameMetersDiameter,
                outlineColor: Colors.amber,
                hasCenterDot: true,
                isDouble: false,
              );
      return agent;
    })(),
    AgentType.fade: (() {
      final agent = AgentData(
        type: AgentType.fade,
        role: AgentRole.initiator,
        name: "Fade",
      );

      agent.abilities[1].abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities[1],
                size: 6.58 * inGameMetersDiameter,
                outlineColor: const Color(0xFF680A79),
                hasCenterDot: true,
                isDouble: false,
              );

      agent.abilities[2].abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities[2],
                size: 30 * inGameMetersDiameter,
                outlineColor: const Color(0xFF680A79),
                hasCenterDot: true,
                isDouble: false,
                opacity: 0,
              );

      agent.abilities.last.isTransformable = true;
      agent.abilities.last.abilityWidget =
          ([double? rotation]) => CustomSquareWidget(
                color: const Color(0xFF680A79),
                abilityInfo: agent.abilities.last,
                height: 40 * inGameMeters,
                width: 24 * inGameMeters,
              );
      return agent;
    })(),
    AgentType.neon: (() {
      final agent = AgentData(
        type: AgentType.neon,
        role: AgentRole.duelist,
        name: "Neon",
      );

      agent.abilities[1].abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities[1],
                size: 5 * inGameMetersDiameter,
                outlineColor: Colors.blue,
                hasCenterDot: true,
                isDouble: false,
              );
      return agent;
    })(),
    AgentType.omen: (() {
      final agent = AgentData(
        type: AgentType.omen,
        role: AgentRole.controller,
        name: "Omen",
      )..abilities[2] =
            // Override the default abilities
            AbilityInfo(
          name: "Smoke",
          iconPath: 'assets/agents/Omen/3.png',
          imagePath: 'assets/agents/Omen/Smoke.png', // Custom image for smoke
          width: 4.1 * inGameMetersDiameter,
        );
      //Blind
      agent.abilities[1].isTransformable = true;
      agent.abilities[1].abilityWidget =
          ([double? rotation]) => CustomSquareWidget(
                color: Colors.deepPurple,
                abilityInfo: agent.abilities[1],
                width: 4.3 * inGameMetersDiameter,
                height: 32.5 * inGameMeters,
              );

      return agent;
    })(),
    AgentType.reyna: (() {
      final agent = AgentData(
        type: AgentType.reyna,
        role: AgentRole.duelist,
        name: "Reyna",
      );

      return agent;
    })(),
    AgentType.sage: AgentData(
      type: AgentType.sage,
      role: AgentRole.sentinel,
      name: "Sage",
    ),
    AgentType.clove: (() {
      final agent = AgentData(
        type: AgentType.clove,
        role: AgentRole.controller,
        name: "Clove",
      );

      agent.abilities[1].abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities[1],
                size: 6 * inGameMetersDiameter,
                outlineColor: const Color.fromARGB(255, 251, 106, 154),
                hasCenterDot: true,
                isDouble: false,
              );

      return agent;
    })(),
    AgentType.iso: (() {
      final agent = AgentData(
        type: AgentType.iso,
        role: AgentRole.duelist,
        name: "Iso",
      );

      agent.abilities.first.isTransformable = true;
      agent.abilities.first.abilityWidget =
          ([double? rotation]) => CustomSquareWidget(
                color: Colors.indigo,
                abilityInfo: agent.abilities.first,
                width: 4.5 * inGameMeters,
                height: 27.5 * inGameMeters,
                distanceBetweenAOE: 5 * inGameMeters,
              );

      agent.abilities[1].isTransformable = true;
      agent.abilities[1].abilityWidget =
          ([double? rotation]) => CustomSquareWidget(
                color: Colors.indigo,
                abilityInfo: agent.abilities[1],
                width: 3 * inGameMetersDiameter,
                height: 34.875 * inGameMeters,
              );

      agent.abilities[3].isTransformable = true;
      agent.abilities[3].abilityWidget =
          ([double? rotation]) => CustomSquareWidget(
                color: Colors.indigo,
                abilityInfo: agent.abilities[3],
                width: 15 * inGameMeters,
                height: 48 * inGameMeters,
              );

      return agent;
    })(),
    AgentType.deadlock: (() {
      final agent = AgentData(
        type: AgentType.deadlock,
        role: AgentRole.duelist,
        name: "Deadlock",
      );

      //TODO: Two custom widgets for her wall and ult

      agent.abilities.first.abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities.first,
                size: 8 * inGameMetersDiameter,
                outlineColor: Colors.blue,
                hasCenterDot: true,
                isDouble: false,
              );

      agent.abilities[1].isTransformable = true;
      agent.abilities[1].abilityWidget =
          ([double? rotation]) => CustomSquareWidget(
                color: Colors.blue,
                abilityInfo: agent.abilities[1],
                width: 8 * inGameMeters,
                height: 9 * inGameMeters,
              );

      return agent;
    })(),
    AgentType.gekko: (() {
      final agent = AgentData(
        type: AgentType.gekko,
        role: AgentRole.initiator,
        name: "Gekko",
      );

      agent.abilities.first.abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities.first,
                size: 6.2 * inGameMetersDiameter,
                outlineColor: Colors.greenAccent,
                hasCenterDot: true,
                isDouble: false,
              );

      return agent;
    })(),
    AgentType.harbor: (() {
      final agent = AgentData(
        type: AgentType.harbor,
        role: AgentRole.controller,
        name: "Harbor",
      );

      agent.abilities.first.isTransformable = true;
      agent.abilities.first.abilityWidget =
          ([double? rotation]) => CustomSquareWidget(
                color: Colors.lightBlue,
                abilityInfo: agent.abilities.first,
                width: 9.75 * inGameMeters,
                height: 35 * inGameMeters,
              );
      agent.abilities.last.abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities.last,
                size: 21.25 * inGameMetersDiameter,
                outlineColor: Colors.lightBlue,
                hasCenterDot: true,
                isDouble: false,
              );

      return agent;
    })(),
    AgentType.vyse: (() {
      final agent = AgentData(
        type: AgentType.vyse,
        role: AgentRole.sentinel,
        name: "Vyse",
      );

      agent.abilities.first.isTransformable = true;
      agent.abilities.first.abilityWidget =
          ([double? rotation]) => CustomSquareWidget(
                color: Colors.deepPurple,
                abilityInfo: agent.abilities.first,
                width: 1 * inGameMeters,
                height: 12 * inGameMeters,
              );

      agent.abilities[1].abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities[1],
                size: 6.25 * inGameMetersDiameter,
                outlineColor: Colors.deepPurple,
                hasCenterDot: true,
                isDouble: false,
              );

      agent.abilities.last.abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities.last,
                size: 32.5 * inGameMetersDiameter,
                outlineColor: Colors.deepPurple,
                hasCenterDot: true,
                isDouble: false,
              );

      return agent;
    })(),
    AgentType.tejo: (() {
      final agent = AgentData(
        type: AgentType.tejo,
        role: AgentRole.initiator,
        name: "Tejo",
      );

      agent.abilities.first.abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities.first,
                size: 30 * inGameMetersDiameter,
                outlineColor: Colors.orangeAccent,
                hasCenterDot: true,
                isDouble: false,
              );
      agent.abilities[1].abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities[1],
                size: 5.25 * inGameMetersDiameter,
                outlineColor: Colors.orangeAccent,
                hasCenterDot: true,
                isDouble: false,
              );

      agent.abilities[2].abilityWidget =
          ([double? rotation]) => CustomCircleWidget(
                abilityInfo: agent.abilities[2],
                size: 4.5 * inGameMetersDiameter,
                outlineColor: Colors.orangeAccent,
                hasCenterDot: true,
                isDouble: false,
              );

      agent.abilities.last.isTransformable = true;
      agent.abilities.last.abilityWidget =
          ([double? rotation]) => CustomSquareWidget(
                color: Colors.orangeAccent,
                abilityInfo: agent.abilities.last,
                width: 10 * inGameMeters,
                height: 32 * inGameMeters,
              );
      return agent;
    })()
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
  double rotaion = 0;
  PlacedAbility({required this.data, required super.position});
}
