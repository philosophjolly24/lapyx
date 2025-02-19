import 'package:flutter/material.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/coordinate_system.dart';

class AbilityWidget extends StatelessWidget {
  const AbilityWidget({
    super.key,
    required this.ability,
  });

  final AbilityInfo ability;

  @override
  Widget build(BuildContext context) {
    final coordinateSystem = CoordinateSystem.instance;
    if (ability.abilityData != null) {
      return ability.abilityData!.createWidget();
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
      borderRadius: const BorderRadius.all(Radius.circular(3)),
      child: Container(
        width: coordinateSystem.scale(30),
        height: coordinateSystem.scale(30),
        padding: EdgeInsets.all(coordinateSystem.scale(3)),
        decoration: const BoxDecoration(
          color: Color(0xFF1B1B1B),
        ),
        child: Image.asset(
          ability.iconPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
