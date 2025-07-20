import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/providers/agent_provider.dart';
import 'package:icarus/widgets/mouse_watch.dart';

class AgentWidget extends ConsumerWidget {
  const AgentWidget({
    super.key,
    required this.agent,
    required this.id,
    required this.isAlly,
  });

  final String? id;
  final bool isAlly;
  final AgentData agent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coordinateSystem = CoordinateSystem.instance;
    return Container(
      decoration: BoxDecoration(
        // color: const Color(0xFF1B1B1B),
        color: isAlly ? Settings.allyBGColor : Settings.enemyBGColor,

        border: Border.all(
          color:
              isAlly ? Settings.allyOutlineColor : Settings.enemyOutlineColor,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(3),
        ),
      ),
      width: coordinateSystem.scale(Settings.agentSize),
      height: coordinateSystem.scale(Settings.agentSize),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(3.0)),
        child: Image.asset(agent.iconPath),
      ),
    );
  }
}
