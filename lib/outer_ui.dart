import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:icarus/widgets/ability/ability_widget.dart';
import 'package:icarus/widgets/ability/agent_widget.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/providers/agent_provider.dart';
import 'package:provider/provider.dart';

class OuterUi extends StatefulWidget {
  const OuterUi({super.key});

  @override
  State<OuterUi> createState() => _OuterUiState();
}

class _OuterUiState extends State<OuterUi> {
  ScrollController gridScrollController = ScrollController();
  double sideBarSize = 270;

  Offset centerDragStrategy(
      Draggable<Object> draggable, BuildContext context, Offset position) {
    AbilityInfo abilityInfo = draggable.data as AbilityInfo;
    return abilityInfo.centerPoint ?? Offset.zero;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Consumer<AgentProvider>(
              builder: (context, agentProivder, child) {
                if (agentProivder.activeAgent == null) //
                  return const SizedBox.shrink();

                AgentData activeAgent = agentProivder.activeAgent!;
                return Container(
                  width: 90,
                  height: 350,
                  decoration: const BoxDecoration(
                    color: Color(0xFF100D10),
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(24)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ...List.generate(
                        activeAgent.abilities.length,
                        (index) {
                          return Draggable(
                            data: activeAgent.abilities[index],
                            feedback: AbilityWidget(
                              ability: activeAgent.abilities[index],
                            ),
                            dragAnchorStrategy: centerDragStrategy,
                            child: InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 55,
                                  width: 55,
                                  child: Image.asset(
                                      activeAgent.abilities[index].iconPath),
                                ),
                              ),
                            ),
                            onDraggableCanceled: (velocity, offset) {
                              log("I oops");
                            },
                          );
                        },
                      )
                    ],
                  ),
                );
              },
            ),
            Container(
              color: const Color(0xFF141114),
              width: sideBarSize + 20,
              child: Column(
                children: [
                  Container(
                    color: Colors.red,
                    height: 50,
                    width: sideBarSize + 20,
                  ),
                  Expanded(
                    child: RawScrollbar(
                      trackVisibility: true,
                      thumbVisibility: true,
                      thumbColor: const Color(0xFF353435),
                      scrollbarOrientation: ScrollbarOrientation.left,
                      thickness: 10,
                      radius: const Radius.circular(10),
                      controller: gridScrollController,
                      crossAxisMargin: 10,
                      mainAxisMargin: 10,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: sideBarSize,
                          child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.only(top: 10),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 100,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 15,
                            ),
                            controller: gridScrollController,
                            // padding: const EdgeInsets.only(right: 8),
                            physics: const BouncingScrollPhysics(),
                            itemCount: AgentType.values.length,
                            itemBuilder: (context, index) {
                              final agent =
                                  AgentData.agents[AgentType.values[index]]!;

                              return Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Center(
                                  child: SizedBox(
                                    child: Draggable(
                                      data: agent,
                                      feedback: AgentWidget(
                                        agent: agent,
                                      ),
                                      dragAnchorStrategy:
                                          pointerDragAnchorStrategy,
                                      child: InkWell(
                                        onTap: () {
                                          Provider.of<AgentProvider>(
                                            listen: false,
                                            context,
                                          ).setActiveAgent(agent);
                                        },
                                        child: Image.asset(
                                          agent.iconPath,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
