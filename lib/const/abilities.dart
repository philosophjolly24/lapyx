import 'package:flutter/widgets.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/widgets/ability/ability_widget.dart';
import 'package:icarus/widgets/ability/custom_circle_widget.dart';
import 'package:icarus/widgets/ability/custom_square_widget.dart';
import 'package:icarus/widgets/ability/agent_icon_widget.dart';

abstract class Ability {
  Offset getAnchorPoint();
  Widget createWidget(String? id, [double? rotation]);
}

class BaseAbility extends Ability {
  final String iconPath;

  BaseAbility({required this.iconPath});

  @override
  Widget createWidget(String? id, [double? rotation]) {
    return AbilityWidget(
      iconPath: iconPath,
      id: id,
    );
  }

  @override
  Offset getAnchorPoint() {
    return const Offset(Settings.abilitySize / 2, Settings.abilitySize / 2);
  }
}

class ImageAbility extends Ability {
  final String imagePath;
  final double size;

  ImageAbility({required this.imagePath, required this.size});
  @override
  Widget createWidget(String? id, [double? rotation]) {
    return AgentIconWidget(imagePath: imagePath, size: size);
  }

  @override
  Offset getAnchorPoint() {
    return Offset(size / 2, size / 2);
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
  Offset getAnchorPoint() {
    return Offset(size / 2, size / 2);
  }

  @override
  Widget createWidget(String? id, [double? rotation]) {
    return CustomCircleWidget(
      iconPath: iconPath,
      size: size,
      outlineColor: outlineColor,
      hasCenterDot: hasCenterDot ?? true,
      hasPerimeter: hasPerimeter ?? false,
      opacity: opacity,
      fillColor: fillColor,
      innerSize: perimeterSize,
      id: id,
    );
  }
}

class SquareAbility extends Ability {
  final double width;
  final double height;
  final String iconPath;
  final Color color;

  final double? distanceBetweenAOE;

  SquareAbility({
    required this.width,
    required this.height,
    required this.iconPath,
    required this.color,
    this.distanceBetweenAOE,
  });

  @override
  Offset getAnchorPoint() {
    return Offset(
      width / 2,
      height + (distanceBetweenAOE ?? 0) + (Settings.abilitySize / 2),
    );
  }

  @override
  Widget createWidget(String? id, [double? rotation]) {
    return CustomSquareWidget(
      color: color,
      width: width,
      height: height,
      iconPath: iconPath,
      distanceBetweenAOE: distanceBetweenAOE,
      rotation: rotation,
      origin: getAnchorPoint(),
      id: id,
    );
  }
}
