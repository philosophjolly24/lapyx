import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/drawing_provider.dart';
import 'package:icarus/providers/interaction_state_provider.dart';

class BottomActionbar extends ConsumerWidget {
  const BottomActionbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentInteractionState = ref.watch(interactionStateProvider);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 55,
        width: 300,
        margin: const EdgeInsets.only(
          bottom: 16,
        ), // Add some margin from bottom
        child: Card(
          color: const Color(0xFF242126),
          elevation: 8, // Add some elevation for floating effect
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  icon: const Icon(Icons.delete))
            ],
          ),
        ),
      ),
    );
  }
}
