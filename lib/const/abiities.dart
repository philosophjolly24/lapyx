import 'package:flutter/widgets.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/widgets/ability/custom_circle_widget.dart';

abstract class Ability {
  Offset getAnchorPoint();
  Widget createWidget();
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
    CoordinateSystem.instance;
    return Offset(size / 2, size / 2);
  }

  Widget createWidget() {
    return CustomCircleWidget(
      iconPath: iconPath,
      size: size,
      outlineColor: outlineColor,
      hasCenterDot: hasCenterDot ?? true,
      hasPerimeter: hasPerimeter ?? false,
    );
  }
}

class SquareAbility extends Ability {
  final double width;
  final double height;
  final String iconPath;
  final Color color;

  final double? distanceBetweenAOE;
  final double? rotation;

  SquareAbility({
    required this.width,
    required this.height,
    required this.iconPath,
    required this.color,
    this.distanceBetweenAOE,
    this.rotation,
  });

  @override
  Offset getAnchorPoint() {
    // TODO: implement getAnchorPoint
    throw UnimplementedError();
  }

  @override
  Widget createWidget() {
    // TODO: implement createWidget
    throw UnimplementedError();
  }
}
