import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icarus/agents.dart';
import 'dart:developer' as dev;

import 'package:icarus/drawing_painter.dart';
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
    Size playAreaSize = Size(height * 1.24, height);
    AgentProvider agentProvider = context.watch<AgentProvider>();

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
                    return DragTarget<AgentData>(
                      builder: (context, candidateData, rejectedData) {
                        return Stack(
                          children: [
                            ...List.generate(agentProvider.placedAgents.length,
                                (index) {
                              final agent = agentProvider.placedAgents[index];
                              return Positioned(
                                  left: coordinateSystem
                                      .coordinateToScreen(agent.position)
                                      .dx,
                                  top: coordinateSystem
                                      .coordinateToScreen(agent.position)
                                      .dy,
                                  child: draggableAgentWidget(
                                      Draggable(
                                        feedback: agentWidget(
                                            agent.data, coordinateSystem),
                                        childWhenDragging:
                                            const SizedBox.shrink(),
                                        onDragEnd: (details) {
                                          //TODO: Account for out of bounds acceptance
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
                                      coordinateSystem));
                            }),
                          ],
                        );
                      },
                      onAcceptWithDetails: (details) {
                        RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        Offset localOffset =
                            renderBox.globalToLocal(details.offset);
                        Offset normalizedPosition =
                            coordinateSystem.screenToCoordinate(localOffset);

                        PlacedAgent placedAgent = PlacedAgent(
                          data: details.data,
                          position: normalizedPosition,
                        );

                        agentProvider.addAgent(placedAgent);
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.grey,
          height: height,
          width: 120,
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: AgentType.values.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 60,
                  child: Draggable(
                    data: AgentData.agents[AgentType.values[index]],
                    feedback: agentWidget(
                        AgentData.agents[AgentType.values[index]]!,
                        coordinateSystem),
                    dragAnchorStrategy: pointerDragAnchorStrategy,
                    child: SizedBox(
                      width: 60,
                      child: Image.asset(
                        AgentData.agents[AgentType.values[index]]!.iconPath,
                      ),
                    ),
                  ),
                );
              }),
        )
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
