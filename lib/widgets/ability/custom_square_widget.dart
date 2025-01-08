import 'package:flutter/material.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/coordinate_system.dart';

class CustomSquareWidget extends StatelessWidget {
  const CustomSquareWidget(
      {super.key,
      required this.color,
      required this.abilityInfo,
      required this.width,
      required this.height});

  final Color color;
  final double width;
  final double height;
  final AbilityInfo abilityInfo;

  @override
  Widget build(BuildContext context) {
    final coordinateSystem = CoordinateSystem.instance;

    return Column(
      children: [
        IgnorePointer(
          child: Container(
            width: coordinateSystem.scale(width),
            height: coordinateSystem.scale(height),
            color: color,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: coordinateSystem.scale(25),
            height: coordinateSystem.scale(25),
            padding: EdgeInsets.all(coordinateSystem.scale(3)),
            decoration: const BoxDecoration(
              color: Color(0xFF1B1B1B),
            ),
            child: Image.asset(
              abilityInfo.iconPath,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
