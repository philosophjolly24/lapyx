import 'package:flutter/material.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/providers/agent_provider.dart';
import 'package:provider/provider.dart';
import 'package:icarus/const/coordinate_system.dart';

class OuterUi extends StatefulWidget {
  const OuterUi({super.key});

  @override
  State<OuterUi> createState() => _OuterUiState();
}

class _OuterUiState extends State<OuterUi> {
  ScrollController gridScrollController = ScrollController();
  double sideBarSize = 270;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height -
        60.0; // -60 adjusts for app bar height. I'm not sure if app bar will be included so this would be modified accordingly
    Size playAreaSize = Size(height * 1.24, height);
    CoordinateSystem coordinateSystem =
        CoordinateSystem(playAreaSize: playAreaSize);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Consumer<AgentProvider>(
              builder: (context, agentProivder, child) {
                if (agentProivder.activeAgent == null)
                  // ignore: curly_braces_in_flow_control_structures
                  return const SizedBox.shrink();

                AgentData activeAgent = agentProivder.activeAgent!;
                return Container(
                  width: 90,
                  height: 350,
                  decoration: const BoxDecoration(
                      color: Color(0xFF100D10),
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(24))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ...List.generate(
                        activeAgent.abilities.length,
                        (index) {
                          return Draggable(
                            data: activeAgent.abilities[index],
                            feedback: defaultAbilityWidget(
                                activeAgent.abilities[index], coordinateSystem),
                            dragAnchorStrategy: pointerDragAnchorStrategy,
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
              height: height,
              width: sideBarSize + 20,
              child: Column(
                children: [
                  Container(
                    color: Colors.red,
                    height: 50,
                    width: sideBarSize + 20,
                  ),
                  SizedBox(
                    height: height - 50,
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
                                return Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Center(
                                    child: SizedBox(
                                      child: Draggable(
                                        data: AgentData
                                            .agents[AgentType.values[index]],
                                        feedback: agentWidget(
                                            AgentData.agents[
                                                AgentType.values[index]]!,
                                            coordinateSystem),
                                        dragAnchorStrategy:
                                            pointerDragAnchorStrategy,
                                        child: InkWell(
                                          onTap: () {
                                            Provider.of<AgentProvider>(
                                                    listen: false, context)
                                                .setActiveAgent(AgentData
                                                        .agents[
                                                    AgentType.values[index]]!);
                                          },
                                          child: Image.asset(
                                              AgentData
                                                  .agents[
                                                      AgentType.values[index]]!
                                                  .iconPath,
                                              fit: BoxFit.contain),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
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
