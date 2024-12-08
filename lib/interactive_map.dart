import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icarus/agents.dart';
import 'package:icarus/agents.dart';
import 'dart:developer' as dev;

import 'package:icarus/drawing_painter.dart';
import 'package:icarus/main.dart';
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
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 55.0, top: 8),
                    child: SvgPicture.asset(
                      assetName,
                      semanticsLabel: 'Map',
                      fit: BoxFit.contain,
                    ),
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
                            ...agentProvider.placedAgents.map(
                              (agent) => Positioned(
                                left: coordinateSystem
                                    .coordinateToScreen(agent.position)
                                    .dx,
                                top: coordinateSystem
                                    .coordinateToScreen(agent.position)
                                    .dy,
                                child: SizedBox(
                                  // Container helps us control the image size and add visual feedback
                                  width:
                                      60, // Set a consistent size for placed agents
                                  height: 60,
                                  child: Image.asset(
                                    agent.data
                                        .iconPath, // Use the path from agent data
                                    fit: BoxFit
                                        .contain, // Make sure image fits in container
                                  ),
                                ),
                              ),
                            ),
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
                          data: details.data as AgentData,
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
                    feedback: SizedBox(
                      width: 60,
                      child: Image.asset(
                        AgentData.agents[AgentType.values[index]]!.iconPath,
                      ),
                    ),
                    dragAnchorStrategy: childDragAnchorStrategy,
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

  // Methods
  Offset screenToCoordinate(Offset screenPoint) {
    // Get current scale from transformation matrix

    // Normalize coordinates
    double normalizedX = (screenPoint.dx / playAreaSize.width) * 1000;
    double normalizedY = (screenPoint.dy / playAreaSize.height) * 1000;
    // dev.log("Normalized X $normalizedX \n Normalized Y $normalizedY");
    return Offset(normalizedX, normalizedY);
  }

  Offset coordinateToScreen(Offset coordinates) {
    double screenX = (coordinates.dx / 1000) * playAreaSize.width;
    double screenY = (coordinates.dy / 1000) * playAreaSize.height;

    // dev.log("Raw X $screenX \n Raw Y $screenY");
    return Offset(screenX, screenY);
  }
}
