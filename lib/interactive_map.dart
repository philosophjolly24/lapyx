import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icarus/agents.dart';
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
      mainAxisAlignment: MainAxisAlignment.center,
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
                                      feedback: defaultAbilityWidget(
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
                                      child: defaultAbilityWidget(
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
                                      feedback: agentWidget(
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
                                      child: agentWidget(
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

class CoordinateSystem {
  // System parameters

  final Size playAreaSize;

  CoordinateSystem({required this.playAreaSize});

  // The normalized coordinate space will maintain this aspect ratio
  final double normalizedHeight = 1000.0;
  late final double normalizedWidth = normalizedHeight * 1.24;

  Offset screenToCoordinate(Offset screenPoint) {
    // Convert screen points to the normalized space while maintaining aspect ratio
    double normalizedX =
        (screenPoint.dx / playAreaSize.width) * normalizedWidth;
    double normalizedY =
        (screenPoint.dy / playAreaSize.height) * normalizedHeight;

    //   dev.log('''
    // Screen to Coordinate:
    // Input Screen Positon: ${screenPoint.dx}, ${screenPoint.dy}
    // PlayAreaSize: ${playAreaSize.width}, ${playAreaSize.height}
    // Output screen pos: $normalizedX, $normalizedY
    // ''');
    return Offset(normalizedX, normalizedY);
  }

  Offset coordinateToScreen(Offset coordinates) {
    // Convert from normalized space back to screen space while maintaining aspect ratio
    double screenX = (coordinates.dx / normalizedWidth) * playAreaSize.width;
    double screenY = (coordinates.dy / normalizedHeight) * playAreaSize.height;

    //   dev.log('''
    // Coordinate to Screen:
    // Input coordinates: ${coordinates.dx}, ${coordinates.dy}
    // PlayAreaSize: ${playAreaSize.width}, ${playAreaSize.height}
    // Output screen pos: $screenX, $screenY
    // ''');
    return Offset(screenX, screenY);
  }

  double _baseHeight = 831.0;
  // Get the scale factor based on screen height
  double get scaleFactor => playAreaSize.height / _baseHeight;

  // Scale any dimension based on height
  double scale(double size) => size * scaleFactor;

  // Scale a size maintaining aspect ratio
  Size scaleSize(Size size) => Size(
        size.width * scaleFactor,
        size.height * scaleFactor,
      );

  // Convenience method to wrap a widget with scaled dimensions
  Widget scaleWidget({
    required Widget child,
    required Size originalSize,
  }) {
    Size scaledSize = scaleSize(originalSize);
    return SizedBox(
      width: scaledSize.width,
      height: scaledSize.height,
      child: child,
    );
  }
}
