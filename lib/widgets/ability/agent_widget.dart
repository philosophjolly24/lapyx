import 'package:flutter/material.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/coordinate_system.dart';

class AgentWidget extends StatelessWidget {
  const AgentWidget({
    super.key,
    required this.agent,
  });

  final AgentData agent;

  @override
  Widget build(BuildContext context) {
    final coordinateSystem = CoordinateSystem.instance;
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(3.0)),
      child: Container(
        color: const Color(0xFF1B1B1B),
        width: coordinateSystem.scale(30),
        child: Image.asset(agent.iconPath),
      ),
    );
  }
}
