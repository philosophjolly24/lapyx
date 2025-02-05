import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/drawing_provider.dart';
import 'package:icarus/providers/interaction_state_provider.dart';

class ToolGrid extends ConsumerWidget {
  const ToolGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentInteractionState = ref.watch(interactionStateProvider);

    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: const Text(
          "Tools",
          style: TextStyle(fontSize: 20),
        ),
        initiallyExpanded: true,
        children: [
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 5,
            children: [
              IconButton(
                onPressed: () {
                  switch (currentInteractionState) {
                    case InteractionState.drawFreeLine:
                      ref
                          .read(interactionStateProvider.notifier)
                          .update(InteractionState.navigation);
                    default:
                      ref
                          .read(interactionStateProvider.notifier)
                          .update(InteractionState.drawFreeLine);
                  }
                },
                icon: const Icon(Icons.draw),
                isSelected:
                    currentInteractionState == InteractionState.drawFreeLine,
              ),
              IconButton(
                onPressed: () {
                  ref.read(drawingProvider.notifier).clearAll();
                },
                icon: const Icon(Icons.delete),
              )
            ],
          )
        ],
      ),
    );
  }
}
