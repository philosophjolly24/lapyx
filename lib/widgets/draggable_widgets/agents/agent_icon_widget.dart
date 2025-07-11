import 'package:flutter/material.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/widgets/mouse_watch.dart';

class AgentIconWidget extends StatelessWidget {
  const AgentIconWidget(
      {super.key, required this.imagePath, required this.size, this.index});
  final double size;
  final String imagePath;
  final int? index;

  @override
  Widget build(BuildContext context) {
    final coordinateSystem = CoordinateSystem.instance;

    return SizedBox(
      width: coordinateSystem.scale(size),
      height: coordinateSystem.scale(size),
      child: Image.asset(imagePath),
    );
  }
}
