import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/interaction_state_provider.dart';
import 'package:icarus/widgets/color_buttons.dart';

class DrawingTools extends ConsumerWidget {
  const DrawingTools({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded =
        ref.watch(interactionStateProvider) == InteractionState.drawing;
    // if (!isExpanded) return const SizedBox.shrink();
    return ClipRect(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isExpanded ? 200 : 0, // Change height based on state
        curve: Curves.easeInOut,
        child: !isExpanded
            ? const SizedBox.shrink()
            : const SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Color"),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          ColorButtons(
                            color: Colors.red,
                            isSelected: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ), // Return null when not expanded
      ),
    );
  }
}
