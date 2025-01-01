import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icarus/widgets/ability/ability_widget.dart';
import 'package:icarus/widgets/ability/agent_widget.dart';
import 'package:icarus/widgets/ability_widgets.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'dart:developer' as dev;

import 'package:icarus/drawing_painter.dart';
import 'package:icarus/providers/ability_provider.dart';
import 'package:icarus/providers/agent_provider.dart';
import 'package:provider/provider.dart';

class InteractiveMap extends StatefulWidget {
  const InteractiveMap({super.key});

  @override
  State<InteractiveMap> createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap> {
  String assetName = 'assets/maps/ascent_map.svg';

  TransformationController transformationController =
      TransformationController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height - kToolbarHeight;
    final Size playAreaSize = Size(height * 1.2, height);

    final coordinateSystem = CoordinateSystem(playAreaSize: playAreaSize);

    return Row(
      children: [
        Container(
          width: playAreaSize.width,
          height: height,
          color: const Color(0xFF1B1B1B),
          child: InteractiveViewer(
            scaleEnabled: true,
            transformationController: transformationController,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SvgPicture.asset(
                    assetName,
                    semanticsLabel: 'Map',
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned.fill(
                  child: InteractivePainter(playAreaSize: playAreaSize),
                ),
                Positioned.fill(
                  child: LayoutBuilder(builder: (context, constraints) {
                    return DragTarget<DraggableData>(
                      builder: (context, candidateData, rejectedData) {
                        return Consumer2<AgentProvider, AbilityProvider>(
                          builder:
                              (context, agentProvider, abilityProvider, child) {
                            return Stack(
                              children: [
                                ...[
                                  for (final ability
                                      in abilityProvider.placedAbilities)
                                    Positioned(
                                      left: coordinateSystem
                                          .coordinateToScreen(ability.position)
                                          .dx,
                                      top: coordinateSystem
                                          .coordinateToScreen(ability.position)
                                          .dy,
                                      child: Draggable(
                                        feedback: AbilityWidget(
                                            ability: ability.data,
                                            coordinateSystem: coordinateSystem),
                                        childWhenDragging:
                                            const SizedBox.shrink(),
                                        onDragEnd: (details) {
                                          RenderBox renderBox = context
                                              .findRenderObject() as RenderBox;
                                          Offset localOffset = renderBox
                                              .globalToLocal(details.offset);
                                          // Updating info

                                          ability.updatePosition(
                                              coordinateSystem
                                                  .screenToCoordinate(
                                                      localOffset));

                                          // ability.bringFoward(index);
                                          dev.log(coordinateSystem.playAreaSize
                                              .toString());
                                        },
                                        child: AbilityWidget(
                                            ability: ability.data,
                                            coordinateSystem: coordinateSystem),
                                      ),
                                    )
                                ],
                                ...[
                                  for (final (index, agent)
                                      in agentProvider.placedAgents.indexed)
                                    Positioned(
                                      left: coordinateSystem
                                          .coordinateToScreen(agent.position)
                                          .dx,
                                      top: coordinateSystem
                                          .coordinateToScreen(agent.position)
                                          .dy,
                                      child: Draggable(
                                        feedback: AgentWidget(
                                            agent: agent.data,
                                            coordinateSystem: coordinateSystem),
                                        childWhenDragging:
                                            const SizedBox.shrink(),
                                        onDragEnd: (details) {
                                          RenderBox renderBox = context
                                              .findRenderObject() as RenderBox;
                                          Offset localOffset = renderBox
                                              .globalToLocal(details.offset);
                                          // Updating info

                                          agent.updatePosition(coordinateSystem
                                              .screenToCoordinate(localOffset));

                                          agentProvider.bringAgentFoward(index);
                                          dev.log(coordinateSystem.playAreaSize
                                              .toString());
                                        },
                                        child: AgentWidget(
                                            agent: agent.data,
                                            coordinateSystem: coordinateSystem),
                                      ),
                                    )
                                ],
                              ],
                            );
                          },
                        );
                      },
                      onAcceptWithDetails: (details) {
                        RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        Offset localOffset =
                            renderBox.globalToLocal(details.offset);
                        Offset normalizedPosition =
                            coordinateSystem.screenToCoordinate(localOffset);

                        if (details.data is AgentData) {
                          PlacedAgent placedAgent = PlacedAgent(
                            data: details.data as AgentData,
                            position: normalizedPosition,
                          );

                          AgentProvider agentProvider =
                              Provider.of<AgentProvider>(
                                  listen: false, context);
                          agentProvider.addAgent(placedAgent);
                        } else if (details.data is AbilityInfo) {
                          PlacedAbility placedAbility = PlacedAbility(
                              data: details.data as AbilityInfo,
                              position: normalizedPosition);
                          AbilityProvider abilityProvider =
                              Provider.of<AbilityProvider>(
                                  listen: false, context);

                          abilityProvider.addAbility(placedAbility);
                        }
                      },
                      onLeave: (data) {
                        dev.log("I have left");
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
