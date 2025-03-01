import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/providers/agent_provider.dart';
import 'package:icarus/widgets/mouse_watch.dart';

class AgentWidget extends ConsumerWidget {
  const AgentWidget({
    super.key,
    required this.agent,
    this.index,
  });

  final int? index;

  final AgentData agent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coordinateSystem = CoordinateSystem.instance;
    return MouseWatch(
      onDeleteKeyPressed: () {
        if (index == null) return;
        ref.read(agentProvider.notifier).removeAgent(index!);
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(3.0)),
        child: Container(
          color: const Color(0xFF1B1B1B),
          width: coordinateSystem.scale(30),
          child: Image.asset(agent.iconPath),
        ),
      ),
    );
  }
}
