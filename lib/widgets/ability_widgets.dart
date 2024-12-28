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
      return ability.abilityWidgetBuilder!(coordinateSystem);
    }
    if (ability.imagePath != null) {
      return SizedBox(
        width: coordinateSystem.scale(ability.width!),
        height: coordinateSystem.scale(ability.width!),
        child: Image.asset(ability.imagePath!),
      );
    }
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

  static Widget Function(CoordinateSystem) brimstoneAbility4Builder() {
    return (CoordinateSystem coordinateSystem) {
      double size = coordinateSystem.scale(80);
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            color: const Color.fromARGB(135, 244, 67, 54),
            shape: BoxShape.circle,
            border: Border.all(
                color: Colors.red, width: coordinateSystem.scale(2))),
      );
    };
  }

  static Widget Function(CoordinateSystem) customCircleAbility(
      double size, Color innerColor, Color outlineColor, bool hasCenterDot,
      [int? opactiy]) {
    return (CoordinateSystem coordinateSystem) {
      double scaleSize = coordinateSystem.scale(size);

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
                color: outlineColor, width: coordinateSystem.scale(2))),
      );
    };
  }
}
