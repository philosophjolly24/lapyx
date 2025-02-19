import 'package:flutter/material.dart';
import 'package:icarus/const/coordinate_system.dart';

class CustomSquareWidget extends StatelessWidget {
  //I want to be able to to pass the rotation to the CustomSquareWidget
  //Rotation is stored in the PlacedAbility widget which is stored within the AbilityProvider
  //Issue is that how do I access the right abilityProvider to get the correct rotation info

  //Could a key be the issue?
  const CustomSquareWidget({
    super.key,
    required this.color,
    required this.width,
    required this.height,
    this.distanceBetweenAOE,
    this.rotation,
    required this.iconPath,
  });

  final Color color;
  final double width;
  final double height;
  final String iconPath;
  final double? distanceBetweenAOE;
  final double? rotation;

  @override
  Widget build(BuildContext context) {
    final coordinateSystem = CoordinateSystem.instance;

    return Transform.rotate(
      angle: rotation ?? 0,
      child: Column(
        children: [
          IgnorePointer(
            child: Container(
              width: coordinateSystem.scale(width),
              height: coordinateSystem.scale(height),
              color: color.withAlpha(100),
            ),
          ),
          IgnorePointer(
            child: SizedBox(
              height: coordinateSystem.scale(distanceBetweenAOE ?? 0),
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
                iconPath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
