import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icarus/widgets/ability/ability_widget.dart';
import 'package:icarus/widgets/ability/agent_widget.dart';
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
                                      child: !ability.data.isTransformable
                                          ? Draggable(
                                              feedback: AbilityWidget(
                                                ability: ability.data,
                                              ),
                                              childWhenDragging:
                                                  const SizedBox.shrink(),
                                              onDragEnd: (details) {
                                                RenderBox renderBox =
                                                    context.findRenderObject()
                                                        as RenderBox;
                                                Offset localOffset =
                                                    renderBox.globalToLocal(
                                                        details.offset);
                                                // Updating info

                                                ability.updatePosition(
                                                    coordinateSystem
                                                        .screenToCoordinate(
                                                            localOffset));

                                                // ability.bringFoward(index);
                                                dev.log(coordinateSystem
                                                    .playAreaSize
                                                    .toString());
                                              },
                                              child: AbilityWidget(
                                                ability: ability.data,
                                              ),
                                            )
                                          : RotatableWidget(
                                              child: Positioned(
                                                child: Draggable(
                                                  feedback: AbilityWidget(
                                                    ability: ability.data,
                                                  ),
                                                  childWhenDragging:
                                                      const SizedBox.shrink(),
                                                  onDragEnd: (details) {
                                                    RenderBox renderBox = context
                                                            .findRenderObject()
                                                        as RenderBox;
                                                    Offset localOffset =
                                                        renderBox.globalToLocal(
                                                            details.offset);
                                                    // Updating info

                                                    ability.updatePosition(
                                                        coordinateSystem
                                                            .screenToCoordinate(
                                                                localOffset));

                                                    // ability.bringFoward(index);
                                                    dev.log(coordinateSystem
                                                        .playAreaSize
                                                        .toString());
                                                  },
                                                  child: AbilityWidget(
                                                    ability: ability.data,
                                                  ),
                                                ),
                                              ),
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
                                          coordinateSystem: coordinateSystem,
                                        ),
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

class RotatableWidget extends StatefulWidget {
  final Widget child;

  const RotatableWidget({
    super.key,
    required this.child,
  });

  @override
  State<RotatableWidget> createState() => _RotatableWidgetState();
}

//TODO: Will fix this mess later
class _RotatableWidgetState extends State<RotatableWidget> {
  double _rotation = 0.0;
  Offset _rotationOrigin = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.rotationZ(_rotation),
      alignment: Alignment.bottomCenter,
      child: Stack(
        children: [
          widget.child,
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                onPanStart: (details) {
                  final box = context.findRenderObject() as RenderBox;
                  final bottomCenter =
                      Offset(box.size.width / 2, box.size.height);

                  _rotationOrigin = box.localToGlobal(bottomCenter);
                },
                onPanUpdate: (details) {
                  if (_rotationOrigin == Offset.zero) return;

                  final currentPosition = details.globalPosition;
                  final previousPosition = currentPosition - details.delta;

                  // Calculate angles
                  double previousAngle =
                      (previousPosition - _rotationOrigin).direction;
                  double currentAngle =
                      (currentPosition - _rotationOrigin).direction;

                  if (previousAngle > 0 != currentAngle > 0) {
                    if (previousAngle < 0)
                      previousAngle += 2 * pi;
                    else
                      currentAngle += 2 * pi;
                  }
                  // Update rotation
                  setState(() {
                    _rotation += (currentAngle - previousAngle);

                    dev.log("======");
                    dev.log("currentPosition:${_rotationOrigin.toString()}");
                    dev.log("Rotation:${_rotation.toString()}");
                    dev.log("previousPosition:${previousPosition.toString()}");
                    dev.log("currentPosition:${currentPosition.toString()}");

                    dev.log("Previous Angle:${previousAngle.toString()}");
                    dev.log("Current Angle:${currentAngle.toString()}");
                    dev.log("======");
                  });
                },
                onPanEnd: (details) {
                  _rotationOrigin = Offset.zero;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
