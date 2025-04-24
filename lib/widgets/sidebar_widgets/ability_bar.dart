import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/providers/ability_bar_provider.dart';
import 'package:icarus/providers/interaction_state_provider.dart';
import 'package:icarus/providers/team_provider.dart';

class AbiilityBar extends ConsumerWidget {
  const AbiilityBar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(abilityBarProvider) == null) //
      return const SizedBox.shrink();

    AgentData activeAgent = ref.watch(abilityBarProvider)!;
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
                onDragStarted: () {
                  ref
                      .read(interactionStateProvider.notifier)
                      .update(InteractionState.navigation);
                },
                dragAnchorStrategy: (draggable, context, position) {
                  final info = draggable.data as AbilityInfo;

                  double scaleFactor = CoordinateSystem.instance.scaleFactor;
                  log("Center point dragging value${info.abilityData!.getAnchorPoint().scale(scaleFactor, scaleFactor).toString()}");
                  return info.abilityData!
                      .getAnchorPoint()
                      .scale(scaleFactor, scaleFactor);
                },
                feedback:
                    activeAgent.abilities[index].abilityData!.createWidget(
                  null,
                  ref.watch(teamProvider),
                ),

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
