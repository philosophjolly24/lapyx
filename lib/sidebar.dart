import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/widgets/ability/agent_widget.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/widgets/ability_bar.dart';
import 'package:icarus/widgets/tool_grid.dart';

class SideBarUI extends StatefulWidget {
  const SideBarUI({super.key});

  @override
  State<SideBarUI> createState() => _SideBarUIState();
}

class _SideBarUIState extends State<SideBarUI> {
  ScrollController gridScrollController = ScrollController();
  double sideBarSize = 270;

  final activeAgentProvider = StateProvider<AgentData?>((ref) {
    return null;
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AbiilityBar(activeAgentProvider),
            Container(
              color: const Color(0xFF141114),
              width: sideBarSize + 20,
              child: Column(
                children: [
                  const ToolGrid(),
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
                                      child: Consumer(
                                          builder: (context, ref, child) {
                                        return InkWell(
                                          onTap: () {
                                            ref
                                                .read(activeAgentProvider
                                                    .notifier)
                                                .state = agent;
                                          },
                                          child: Image.asset(
                                            agent.iconPath,
                                            fit: BoxFit.contain,
                                          ),
                                        );
                                      }),
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
