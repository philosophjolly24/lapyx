import 'package:flutter/material.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/settings.dart';

class AbilityWidget extends StatelessWidget {
  const AbilityWidget({
    super.key,
    required this.iconPath,
  });

  final String iconPath;

  @override
  Widget build(BuildContext context) {
    final coordinateSystem = CoordinateSystem.instance;

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(3)),
      child: Container(
        width: coordinateSystem.scale(Settings.abilitySize),
        height: coordinateSystem.scale(Settings.abilitySize),
        padding: EdgeInsets.all(coordinateSystem.scale(3)),
        decoration: const BoxDecoration(
          color: Settings.abilityBGColor,
        ),
        child: Image.asset(
          iconPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
