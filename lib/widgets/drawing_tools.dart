import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/interaction_state_provider.dart';

class DrawingTools extends ConsumerWidget {
  const DrawingTools({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded =
        ref.watch(interactionStateProvider) == InteractionState.drawing;
    // if (!isExpanded) return const SizedBox.shrink();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isExpanded ? 200 : 0, // Change height based on state
      curve: Curves.easeInOut,
      child: isExpanded
          ? Container(
              color: Colors.red,
              child: const Column(),
            )
          : null, // Return null when not expanded
    );
  }
}
