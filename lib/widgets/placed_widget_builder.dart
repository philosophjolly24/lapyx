import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/placed_classes.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/providers/ability_provider.dart';
import 'package:icarus/providers/agent_provider.dart';
import 'package:icarus/providers/text_provider.dart';
import 'package:icarus/widgets/ability/agent_widget.dart';
import 'package:icarus/widgets/delete_area.dart';
import 'package:icarus/widgets/placed_ability_widget.dart';
import 'package:icarus/widgets/text_widget.dart';
import 'package:uuid/uuid.dart';

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
                const Align(
                  alignment: Alignment.topRight,
                  child: DeleteArea(),
                ),
                for (PlacedAbility ability in ref.watch(abilityProvider))
                  PlacedAbilityWidget(
                    data: ability,
                    ability: ability,
                    id: ability.id,
                    onDragEnd: (details) {
                      RenderBox renderBox =
                          context.findRenderObject() as RenderBox;
                      Offset localOffset =
                          renderBox.globalToLocal(details.offset);
                      // Updating info

                      Offset virtualOffset =
                          coordinateSystem.screenToCoordinate(localOffset);
                      Offset safeArea =
                          ability.data.abilityData.getAnchorPoint();

                      if (coordinateSystem.isOutOfBounds(
                          virtualOffset.translate(safeArea.dx, safeArea.dy))) {
                        ref
                            .read(abilityProvider.notifier)
                            .removeAbility(ability.id);
                        return;
                      }

                      log(renderBox.size.toString());

                      ability.updatePosition(
                        coordinateSystem.screenToCoordinate(localOffset),
                      );
                      ref
                          .read(abilityProvider.notifier)
                          .bringFoward(ability.id);
                    },
                  ),
                for (PlacedAgent agent in ref.watch(agentProvider))
                  Positioned(
                    left:
                        coordinateSystem.coordinateToScreen(agent.position).dx,
                    top: coordinateSystem.coordinateToScreen(agent.position).dy,
                    child: Draggable<PlacedWidget>(
                      data: agent,
                      feedback: AgentWidget(
                        id: "",
                        agent: AgentData.agents[agent.type]!,
                      ),
                      childWhenDragging: const SizedBox.shrink(),
                      onDragEnd: (details) {
                        RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        Offset localOffset =
                            renderBox.globalToLocal(details.offset);

                        //Basically makes sure that if more than half is of the screen it gets deleted
                        Offset virtualOffset =
                            coordinateSystem.screenToCoordinate(localOffset);
                        double safeArea = Settings.agentSize / 2;

                        if (coordinateSystem.isOutOfBounds(
                            virtualOffset.translate(safeArea, safeArea))) {
                          ref
                              .read(agentProvider.notifier)
                              .removeAgent(agent.id);
                          return;
                        }

                        agent.updatePosition(
                          virtualOffset,
                        );
                        ref.read(agentProvider.notifier).bringFoward(agent.id);
                      },
                      child: AgentWidget(
                        id: agent.id,
                        agent: AgentData.agents[agent.type]!,
                      ),
                    ),
                  ),
                for (final (index, placedText)
                    in ref.watch(textProvider).indexed)
                  Positioned(
                    left: coordinateSystem
                        .coordinateToScreen(placedText.position)
                        .dx,
                    top: coordinateSystem
                        .coordinateToScreen(placedText.position)
                        .dy,
                    child: Draggable<PlacedWidget>(
                      data: placedText,
                      feedback: TextWidget(
                        id: placedText.id,
                        text: placedText.text,
                        isDragged: true,
                      ),
                      childWhenDragging: const SizedBox.shrink(),
                      onDragEnd: (details) {
                        RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        Offset localOffset =
                            renderBox.globalToLocal(details.offset);

                        //Basically makes sure that if more than half is of the screen it gets deleted
                        Offset virtualOffset =
                            coordinateSystem.screenToCoordinate(localOffset);
                        double safeArea = Settings.agentSize / 2;

                        if (coordinateSystem.isOutOfBounds(
                            virtualOffset.translate(safeArea, safeArea))) {
                          ref
                              .read(textProvider.notifier)
                              .removeText(placedText.id);
                          return;
                        }

                        placedText.updatePosition(
                          virtualOffset,
                        );
                        ref
                            .read(textProvider.notifier)
                            .bringFoward(placedText.id);
                      },
                      child: TextWidget(
                        text: placedText.text,
                        id: placedText.id,
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
            const uuid = Uuid();
            if (details.data is AgentData) {
              PlacedAgent placedAgent = PlacedAgent(
                id: uuid.v4(),
                type: (details.data as AgentData).type,
                position: normalizedPosition,
              );

              ref.read(agentProvider.notifier).addAgent(placedAgent);
            } else if (details.data is AbilityInfo) {
              PlacedAbility placedAbility = PlacedAbility(
                id: uuid.v4(),
                data: details.data as AbilityInfo,
                position: normalizedPosition,
              );

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
