import 'package:flutter/material.dart';
import 'package:icarus/agents.dart';
import 'package:icarus/interactive_map.dart';

class OuterUi extends StatefulWidget {
  const OuterUi({super.key});

  @override
  State<OuterUi> createState() => _OuterUiState();
}

class _OuterUiState extends State<OuterUi> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height -
        60.0; // -60 adjusts for app bar height. I'm not sure if app bar will be included so this would be modified accordingly
    Size playAreaSize = Size(height * 1.24, height);
    CoordinateSystem coordinateSystem =
        CoordinateSystem(playAreaSize: playAreaSize);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          color: const Color(0xFF141114),
          height: height,
          width: MediaQuery.of(context).size.width * 0.207,
          child: Column(
            children: [
              Container(
                color: Colors.red,
                height: 50,
                width: MediaQuery.of(context).size.width * 0.207,
              ),
              SizedBox(
                height: height - 50,
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 100,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 15),
                    // padding: const EdgeInsets.only(right: 8),

                    itemCount: AgentType.values.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Center(
                          child: SizedBox(
                            child: Draggable(
                              data: AgentData.agents[AgentType.values[index]],
                              feedback: agentWidget(
                                  AgentData.agents[AgentType.values[index]]!,
                                  coordinateSystem),
                              dragAnchorStrategy: pointerDragAnchorStrategy,
                              child: Image.asset(
                                  AgentData.agents[AgentType.values[index]]!
                                      .iconPath,
                                  fit: BoxFit.contain),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        )
      ],
    );
  }
}
