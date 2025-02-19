import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/coordinate_system.dart';

class AbiilityBar extends ConsumerWidget {
  const AbiilityBar(this.activeAgentProvider, {super.key});
  final StateProvider<AgentData?> activeAgentProvider;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(activeAgentProvider) == null) //
      return const SizedBox.shrink();

    AgentData activeAgent = ref.watch(activeAgentProvider)!;
    return Container(
      width: 90,
      height: 350,
      decoration: const BoxDecoration(
        color: Color(0xFF100D10),
        borderRadius: BorderRadius.horizontal(left: Radius.circular(24)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Agent bar
          ...List.generate(
            activeAgent.abilities.length,
            (index) {
              return Draggable<AbilityInfo>(
                data: activeAgent.abilities[index],
                dragAnchorStrategy: (draggable, context, position) {
                  final info = draggable.data as AbilityInfo;

                  double scaleFactor = CoordinateSystem.instance.scaleFactor;
                  return info.abilityData
                      .getAnchorPoint()
                      .scale(scaleFactor, scaleFactor);
                },
                feedback:
                    activeAgent.abilities[index].abilityData.createWidget(),

                // dragAnchorStrategy: centerDragStrategy,
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 55,
                      width: 55,
                      child: Image.asset(activeAgent.abilities[index].iconPath),
                    ),
                  ),
                ),
                onDraggableCanceled: (velocity, offset) {
                  // log("I oops");
                },
              );
            },
          )
        ],
      ),
    );
  }
}
