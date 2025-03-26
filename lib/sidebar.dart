import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/agent_dragable.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/widgets/ability_bar.dart';
import 'package:icarus/widgets/agent_filter.dart';
import 'package:icarus/widgets/tool_grid.dart';

class SideBarUI extends StatefulWidget {
  const SideBarUI({super.key});

  @override
  State<SideBarUI> createState() => _SideBarUIState();
}

class _SideBarUIState extends State<SideBarUI> {
  ScrollController gridScrollController = ScrollController();

  final activeAgentProvider = StateProvider<AgentData?>((ref) {
    return null;
  });

  @override
  void dispose() {
    gridScrollController.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   for (int i = 0; i < AgentType.values.length; i++) {
  //     final agent = AgentData.agents[AgentType.values[i]]!;

  //     precacheImage(AssetImage(agent.iconPath), context);
  //   }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    const double sideBarSize = 325;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AbiilityBar(activeAgentProvider),
        Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 8),
          child: Container(
            width: sideBarSize + 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Settings.sideBarColor,
              border: Border.all(
                color: const Color.fromRGBO(210, 214, 219, 0.1),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                const ToolGrid(),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Agents",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                AgentFilter(),
                Expanded(
                  child: RawScrollbar(
                    trackVisibility: true,
                    thumbVisibility: true,
                    thumbColor: const Color(0xFF353435),
                    scrollbarOrientation: ScrollbarOrientation.left,
                    thickness: 10,
                    radius: const Radius.circular(10),
                    controller: gridScrollController,
                    crossAxisMargin: 3,
                    mainAxisMargin: 10,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: sideBarSize,
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context)
                              .copyWith(scrollbars: false),
                          child: RepaintBoundary(
                            child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding:
                                  const EdgeInsets.only(top: 10, right: 10),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisExtent: 100,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 15,
                              ),
                              controller: gridScrollController,
                              // padding: const EdgeInsets.only(right: 8),
                              physics: const BouncingScrollPhysics(),
                              itemCount: AgentType.values.length,
                              itemBuilder: (context, index) {
                                final agent =
                                    AgentData.agents[AgentType.values[index]]!;
                                return AgentDragable(
                                  agent: agent,
                                  activeAgentProvider: activeAgentProvider,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
