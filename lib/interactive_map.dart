import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    double height = MediaQuery.of(context).size.height -
        60.0; // -60 adjusts for app bar height. I'm not sure if app bar will be included so this would be modified accordingly
    Size playAreaSize = Size(height * 1.2, height);

    CoordinateSystem coordinateSystem =
        CoordinateSystem(playAreaSize: playAreaSize);

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
                            return Stack(children: [
                              ...List.generate(
                                abilityProvider.placedAbilities.length,
                                (index) {
                                  final ability =
                                      abilityProvider.placedAbilities[index];

                                  return Positioned(
                                    left: coordinateSystem
                                        .coordinateToScreen(ability.position)
                                        .dx,
                                    top: coordinateSystem
                                        .coordinateToScreen(ability.position)
                                        .dy,
                                    child: Draggable(
                                      feedback:
                                          AbilityWidgets.defaultAbilityWidget(
                                              ability.data, coordinateSystem),
                                      childWhenDragging:
                                          const SizedBox.shrink(),
                                      onDragEnd: (details) {
                                        RenderBox renderBox = context
                                            .findRenderObject() as RenderBox;
                                        Offset localOffset = renderBox
                                            .globalToLocal(details.offset);
                                        // Updating info

                                        ability.updatePosition(coordinateSystem
                                            .screenToCoordinate(localOffset));

                                        // ability.bringFoward(index);
                                        dev.log(coordinateSystem.playAreaSize
                                            .toString());
                                      },
                                      child:
                                          AbilityWidgets.defaultAbilityWidget(
                                              ability.data, coordinateSystem),
                                    ),
                                  );
                                },
                              ),
                              ...List.generate(
                                agentProvider.placedAgents.length,
                                (index) {
                                  final agent =
                                      agentProvider.placedAgents[index];

                                  return Positioned(
                                    left: coordinateSystem
                                        .coordinateToScreen(agent.position)
                                        .dx,
                                    top: coordinateSystem
                                        .coordinateToScreen(agent.position)
                                        .dy,
                                    child: Draggable(
                                      feedback: AbilityWidgets.agentWidget(
                                          agent.data, coordinateSystem),
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
                                      child: AbilityWidgets.agentWidget(
                                          agent.data, coordinateSystem),
                                    ),
                                  );
                                },
                              ),
                            ]);
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
