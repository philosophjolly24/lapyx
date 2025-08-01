import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/widgets/draggable_widgets/ability/ability_widget.dart';
import 'package:icarus/widgets/draggable_widgets/ability/custom_circle_widget.dart';
import 'package:icarus/widgets/draggable_widgets/ability/custom_square_widget.dart';
import 'package:icarus/widgets/draggable_widgets/agents/agent_icon_widget.dart';

abstract class Ability {
  Offset getAnchorPoint([double? mapScale]);
  Widget createWidget(String? id, bool isAlly, double mapScale,
      [double? rotation]);
}

class BaseAbility extends Ability {
  final String iconPath;

  BaseAbility({required this.iconPath});

  @override
  Widget createWidget(String? id, bool isAlly, double mapScale,
      [double? rotation]) {
    return AbilityWidget(
      isAlly: isAlly,
      iconPath: iconPath,
      id: id,
    );
  }

  @override
  Offset getAnchorPoint([double? mapScale]) {
    return const Offset(Settings.abilitySize / 2, Settings.abilitySize / 2);
  }
}

class ImageAbility extends Ability {
  final String imagePath;
  final double size;

  ImageAbility({required this.imagePath, required this.size});
  @override
  Widget createWidget(String? id, bool isAlly, double mapScale,
      [double? rotation]) {
    return AgentIconWidget(imagePath: imagePath, size: size * mapScale);
  }

  //TODO: Add mapscale
  @override
  Offset getAnchorPoint([double? mapScale]) {
    return Offset(size * mapScale! / 2, size * mapScale / 2);
  }
}

class CircleAbility extends Ability {
  CircleAbility({
    required this.iconPath,
    required size,
    required this.outlineColor,
    this.hasCenterDot,
    this.hasPerimeter,
    this.fillColor,
    this.opacity,
    this.perimeterSize,
  }) : size = size * AgentData.inGameMetersDiameter;

  final double size;
  final Color outlineColor;
  final String iconPath;

  final bool? hasPerimeter;
  final bool? hasCenterDot;
  final Color? fillColor;
  final int? opacity;
  final double? perimeterSize;

  @override
  Offset getAnchorPoint([double? mapScale]) {
    return Offset((size * mapScale!) / 2, (size * mapScale) / 2);
  }

  @override
  Widget createWidget(String? id, bool isAlly, double mapScale,
      [double? rotation]) {
    return CustomCircleWidget(
      iconPath: iconPath,
      size: size * mapScale,
      outlineColor: outlineColor,
      hasCenterDot: hasCenterDot ?? true,
      hasPerimeter: hasPerimeter ?? false,
      opacity: opacity,
      fillColor: fillColor,
      innerSize: perimeterSize != null ? perimeterSize! * mapScale : null,
      id: id,
      isAlly: isAlly,
    );
  }
}

class SquareAbility extends Ability {
  final double width;
  final double height;
  final String iconPath;
  final Color color;

  final double distanceBetweenAOE;
  final bool isWall;
  final bool hasTopborder;
  final bool hasSideBorders;
  final bool isTransparent;
  SquareAbility({
    required this.width,
    required this.height,
    required this.iconPath,
    required this.color,
    this.distanceBetweenAOE = 0,
    this.isWall = false,
    this.hasTopborder = false,
    this.hasSideBorders = false,
    this.isTransparent = false,
  });

  @override
  Offset getAnchorPoint([double? mapScale]) {
    return Offset(
      (width * mapScale!) / 2,
      (height * mapScale) +
          (distanceBetweenAOE * mapScale) +
          (Settings.abilitySize / 2),
    );
  }

  @override
  Widget createWidget(String? id, bool isAlly, double mapScale,
      [double? rotation]) {
    log("Map scale: $mapScale");
    return CustomSquareWidget(
      color: color,
      width: width * mapScale,
      height: height * mapScale,
      iconPath: iconPath,
      distanceBetweenAOE: distanceBetweenAOE * mapScale,
      rotation: rotation,
      origin: getAnchorPoint(mapScale),
      id: id,
      isAlly: isAlly,
      hasTopborder: hasTopborder,
      hasSideBorders: hasSideBorders,
      isWall: isWall,
      isTransparent: isTransparent,
    );
  }
}
