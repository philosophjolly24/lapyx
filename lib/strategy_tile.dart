import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/maps.dart';
import 'package:icarus/const/placed_classes.dart';
import 'package:icarus/const/routes.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/providers/strategy_provider.dart';
import 'package:icarus/widgets/delete_strategy_alert_dialog.dart';

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

class StrategyTile extends ConsumerStatefulWidget {
  const StrategyTile({
    super.key,
    required this.strategyData,
  });
  final StrategyData strategyData;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StrategyTileState();
}

class _StrategyTileState extends ConsumerState<StrategyTile> {
  Color highlightColor = Settings.highlightColor;

  @override
  Widget build(BuildContext context) {
    Set<AgentType> findAgentsOnMap() {
      final listOfAgents = widget.strategyData.agentData;
      final Set<AgentType> agentsOnMap = {};

      for (PlacedAgent agent in listOfAgents) {
        agentsOnMap.add(agent.type);
      }
      return agentsOnMap;
    }

    final agentsOnMap = findAgentsOnMap();

    return Stack(
      children: [
        Positioned.fill(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (event) {
              setState(() {
                highlightColor = Colors.deepPurpleAccent;
              });
            },
            onExit: (event) {
              setState(() {
                highlightColor = Settings.highlightColor;
              });
            },
            child: GestureDetector(
              onTap: () async {
                Navigator.pushNamed(context, Routes.strategyView);
                // if (!context.mounted) return;
                await ref
                    .read(strategyProvider.notifier)
                    .loadFromHive(widget.strategyData.id);
              },
              child: Container(
                width: 306,
                height: 240,
                decoration: BoxDecoration(
                  color: Settings.sideBarColor,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  border: Border.all(color: highlightColor, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          height: 116,
                          child: Image.asset(
                            "assets/maps/thumbnails/${Maps.mapNames[widget.strategyData.mapData]}_thumbnail.webp",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A161A),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          border: Border.all(
                              color: Settings.highlightColor, width: 1),
                        ),
                        height: 104,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 130),
                                    child: Text(
                                      widget.strategyData.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    capitalizeFirstLetter(Maps.mapNames[
                                        widget.strategyData.mapData]!),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 96 + 27),
                                    child: Row(
                                      spacing: 5,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        for (int i = 0;
                                            (agentsOnMap.length > 3)
                                                ? i < 3
                                                : i < agentsOnMap.length;
                                            i++)
                                          Container(
                                            height: 27,
                                            width: 27,
                                            decoration: BoxDecoration(
                                              color: Settings.sideBarColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(4)),
                                              border: Border.all(
                                                  color:
                                                      Settings.highlightColor),
                                            ),
                                            child: Image.asset(AgentData
                                                .agents[
                                                    agentsOnMap.elementAt(i)]!
                                                .iconPath),
                                          ),
                                        (agentsOnMap.length > 3)
                                            ? Container(
                                                height: 27,
                                                width: 27,
                                                decoration: BoxDecoration(
                                                  color: Settings.sideBarColor,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(4)),
                                                  border: Border.all(
                                                      color: Settings
                                                          .highlightColor),
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.more_horiz,
                                                    color: Color.fromARGB(
                                                        190, 210, 214, 219),
                                                    size: 18,
                                                  ),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Attack",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  // Text(
                                  //   "3 days ago",
                                  // ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MenuAnchor(
              menuChildren: [
                SizedBox(
                  child: MenuItemButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return DeleteStrategyAlertDialog(
                              strategyID: widget.strategyData.id,
                              name: widget.strategyData.name);
                        },
                      );
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          "Delete",
                          style: TextStyle(color: Colors.redAccent),
                        )
                      ],
                    ),
                  ),
                )
              ],
              builder: (context, controller, child) {
                return IconButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  icon: const Icon(
                    Icons.more_vert_outlined,
                    shadows: [Shadow(blurRadius: 8)],
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
