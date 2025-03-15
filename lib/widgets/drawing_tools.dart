import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/interaction_state_provider.dart';
import 'package:icarus/providers/pen_provider.dart';
import 'package:icarus/widgets/color_buttons.dart';

class DrawingTools extends ConsumerStatefulWidget {
  const DrawingTools({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DrawingToolsState();
}

class _DrawingToolsState extends ConsumerState<DrawingTools> {
  @override
  Widget build(BuildContext context) {
    final isExpanded =
        ref.watch(interactionStateProvider) == InteractionState.drawing;
    // if (!isExpanded) return const SizedBox.shrink();
    return ClipRect(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isExpanded ? 120 : 0, // Change height based on state
        curve: Curves.easeInOut,
        child: !isExpanded
            ? const SizedBox.shrink()
            : SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Color"),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          for (final (index, colorOption) in ref
                              .watch(penProvider.select(
                                (state) => state.listOfColors,
                              ))
                              .indexed)
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ColorButtons(
                                color: colorOption.color,
                                isSelected: colorOption.isSelected,
                                onTap: () {
                                  ref
                                      .read(penProvider.notifier)
                                      .setColor(index);
                                },
                              ),
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
