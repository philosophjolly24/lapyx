import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/providers/interaction_state_provider.dart';
import 'package:icarus/widgets/ability/agent_widget.dart';

class AgentDragable extends ConsumerWidget {
  const AgentDragable(
      {super.key, required this.agent, required this.activeAgentProvider});
  final AgentData agent;
  final StateProvider<AgentData?> activeAgentProvider;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Center(
        child: SizedBox(
          child: Draggable(
            data: agent,
            onDragStarted: () {
              ref
                  .read(interactionStateProvider.notifier)
                  .update(InteractionState.drag);
            },
            onDragCompleted: () {
              ref
                  .read(interactionStateProvider.notifier)
                  .update(InteractionState.navigation);
            },
            feedback: RepaintBoundary(
              child: AgentWidget(
                id: null,
                agent: agent,
              ),
            ),
            dragAnchorStrategy: (draggable, context, position) => const Offset(
              Settings.agentSize / 2,
              Settings.agentSize / 2,
            ),
            child: RepaintBoundary(
              child: InkWell(
                onTap: () {
                  ref.read(activeAgentProvider.notifier).state = agent;
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    agent.iconPath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
