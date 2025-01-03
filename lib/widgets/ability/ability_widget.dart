import 'package:flutter/material.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/coordinate_system.dart';

class AbilityWidget extends StatelessWidget {
  const AbilityWidget({
    super.key,
    required this.ability,
    required this.coordinateSystem,
  });

  final AbilityInfo ability;
  final CoordinateSystem coordinateSystem;

  @override
  Widget build(BuildContext context) {
    if (ability.abilityWidget != null) {
      return ability.abilityWidget!();
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
}
