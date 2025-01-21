import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/providers/ability_provider.dart';
import 'package:icarus/providers/agent_provider.dart';
import 'package:icarus/widgets/ability/agent_widget.dart';
import 'package:icarus/widgets/placed_ability_widget.dart';

class PlacedWidgetBuilder extends ConsumerStatefulWidget {
  const PlacedWidgetBuilder({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PlacedWidgetBuilderState();
}

class _PlacedWidgetBuilderState extends ConsumerState<PlacedWidgetBuilder> {
  @override
  Widget build(BuildContext context) {
    final coordinateSystem = CoordinateSystem.instance;
    return LayoutBuilder(
      builder: (context, constraints) {
        return DragTarget<DraggableData>(
          builder: (context, candidateData, rejectedData) {
            return Stack(
              children: [
                for (final ability in ref.watch(abilityProvider))
                  PlacedAbilityWidget(
                    ability: ability,
                    onDragEnd: (details) {
                      RenderBox renderBox =
                          context.findRenderObject() as RenderBox;
                      Offset localOffset =
                          renderBox.globalToLocal(details.offset);
                      // Updating info

                      log(coordinateSystem
                          .screenToCoordinate(localOffset)
                          .toString());

                      ability.updatePosition(
                        coordinateSystem.screenToCoordinate(localOffset),
                      );
                    },
                  ),
                for (final (index, agent) in ref.watch(agentProvider).indexed)
                  Positioned(
                    left:
                        coordinateSystem.coordinateToScreen(agent.position).dx,
                    top: coordinateSystem.coordinateToScreen(agent.position).dy,
                    child: Draggable(
                      feedback: AgentWidget(
                        agent: agent.data,
                      ),
                      childWhenDragging: const SizedBox.shrink(),
                      onDragEnd: (details) {
                        RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        Offset localOffset =
                            renderBox.globalToLocal(details.offset);
                        // Updating info

                        agent.updatePosition(
                          coordinateSystem.screenToCoordinate(localOffset),
                        );
                        ref.read(agentProvider.notifier).bringFoward(index);
                      },
                      child: AgentWidget(
                        agent: agent.data,
                      ),
                    ),
                  ),
              ],
            );
          },
          onAcceptWithDetails: (details) {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            Offset localOffset = renderBox.globalToLocal(details.offset);
            Offset normalizedPosition =
                coordinateSystem.screenToCoordinate(localOffset);

            if (details.data is AgentData) {
              PlacedAgent placedAgent = PlacedAgent(
                data: details.data as AgentData,
                position: normalizedPosition,
              );

              ref.read(agentProvider.notifier).addAgent(placedAgent);
            } else if (details.data is AbilityInfo) {
              PlacedAbility placedAbility = PlacedAbility(
                  data: details.data as AbilityInfo,
                  position: normalizedPosition);

              ref.read(abilityProvider.notifier).addAbility(placedAbility);
            }
          },
          onLeave: (data) {
            log("I have left");
          },
        );
      },
    );
  }
}
