import 'package:flutter/material.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/coordinate_system.dart';

class AgentWidget extends StatelessWidget {
  const AgentWidget({
    super.key,
    required this.agent,
    required this.coordinateSystem,
  });

  final AgentData agent;
  final CoordinateSystem coordinateSystem;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      child: Container(
        color: const Color.fromARGB(255, 56, 56, 56),
        width: coordinateSystem.scale(30),
        child: Image.asset(agent.iconPath),
      ),
    );
  }
}
