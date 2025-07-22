import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/providers/ability_bar_provider.dart';
import 'package:icarus/providers/interaction_state_provider.dart';
import 'package:icarus/providers/screen_zoom_provider.dart';
import 'package:icarus/widgets/draggable_widgets/agents/agent_feedback_widget.dart';
import 'package:icarus/widgets/draggable_widgets/zoom_transform.dart';

class AgentDragable extends ConsumerWidget {
  const AgentDragable({
    super.key,
    required this.agent,
  });
  final AgentData agent;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Center(
        child: SizedBox(
          child: IgnorePointer(
            ignoring:
                ref.watch(interactionStateProvider) == InteractionState.drag,
            child: Draggable(
              data: agent,
              onDragStarted: () {
                ref
                    .read(interactionStateProvider.notifier)
                    .update(InteractionState.drag);
              },
              onDraggableCanceled: (velocity, offset) {
                ref
                    .read(interactionStateProvider.notifier)
                    .update(InteractionState.navigation);
              },
              onDragCompleted: () {
                ref
                    .read(interactionStateProvider.notifier)
                    .update(InteractionState.navigation);
              },
              feedback: Opacity(
                opacity: Settings.feedbackOpacity,
                child: ZoomTransform(child: AgentFeedback(agent: agent)),
              ),
              dragAnchorStrategy: (draggable, context, position) =>
                  const Offset(
                (Settings.agentSize / 2),
                (Settings.agentSize / 2),
              ).scale(ref.read(screenZoomProvider),
                      ref.read(screenZoomProvider)),
              child: RepaintBoundary(
                child: InkWell(
                  onTap: () {
                    ref.read(abilityBarProvider.notifier).updateData(agent);
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
      ),
    );
  }
}
