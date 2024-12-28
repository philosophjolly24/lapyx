import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:icarus/const/agents.dart';

import '../const/coordinate_system.dart';

class AbilityWidgets {
  static Widget agentWidget(
      AgentData agent, CoordinateSystem coordinateSystem) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      child: Container(
        color: const Color.fromARGB(255, 56, 56, 56),
        width: coordinateSystem.scale(30),
        child: Image.asset(agent.iconPath),
      ),
    );
  }

  static Widget defaultAbilityWidget(
      AbilityInfo ability, CoordinateSystem coordinateSystem) {
    if (ability.abilityWidgetBuilder != null) {
      return ability.abilityWidgetBuilder!(coordinateSystem, ability);
    }
    if (ability.imagePath != null) {
      return SizedBox(
        width: coordinateSystem.scale(ability.width!),
        height: coordinateSystem.scale(ability.width!),
        child: Image.asset(ability.imagePath!),
      );
    }
    ability.updateCenterPoint(
        Offset(coordinateSystem.scale(30) / 2, coordinateSystem.scale(30) / 2));
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      child: Container(
        color: const Color.fromARGB(255, 56, 56, 56),
        width: coordinateSystem.scale(30),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Image.asset(ability.imagePath ?? ability.iconPath),
        ),
      ),
    );
  }

  static Widget scaledContainer(
      Widget widget, CoordinateSystem coordinateSystem) {
    return SizedBox(
      width:
          coordinateSystem.scale(30), // Set a consistent size for placed agents
      height: coordinateSystem.scale(30),
      child: widget,
    );
  }

  static Widget Function(CoordinateSystem, AbilityInfo) customCircleAbility(
      double size, Color innerColor, Color outlineColor, bool hasCenterDot,
      [int? opactiy]) {
    return (CoordinateSystem coordinateSystem, AbilityInfo abilityInfo) {
      double scaleSize = coordinateSystem.scale(size - 5);

      abilityInfo.updateCenterPoint(Offset(scaleSize / 2, scaleSize / 2));
      if (hasCenterDot) {
        return Container(
          width: scaleSize,
          height: scaleSize,
          decoration: BoxDecoration(
              color: Color.fromARGB(opactiy ?? 70, innerColor.red,
                  innerColor.green, innerColor.blue),
              shape: BoxShape.circle,
              border: Border.all(
                  color: outlineColor, width: coordinateSystem.scale(5))),
          child: Center(
            child: Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
            ),
          ),
        );
      }

      return Container(
        width: scaleSize,
        height: scaleSize,
        decoration: BoxDecoration(
            color: Color.fromARGB(
                135, innerColor.red, innerColor.green, innerColor.blue),
            shape: BoxShape.circle,
            border: Border.all(
                color: outlineColor, width: coordinateSystem.scale(5))),
      );
    };
  }
}
