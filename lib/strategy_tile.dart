import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/maps.dart';
import 'package:icarus/const/placed_classes.dart';
import 'package:icarus/const/routes.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/providers/strategy_provider.dart';
import 'package:icarus/strategy_view.dart';
import 'package:icarus/widgets/delete_strategy_alert_dialog.dart';

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

String timeAgo(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inMinutes < 1) {
    return 'just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min${difference.inMinutes == 1 ? '' : 's'} ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
  } else if (difference.inDays < 30) {
    return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
  } else {
    // Approximate the number of months (assuming 30 days per month)
    final months = (difference.inDays / 30).floor();
    return '$months month${months == 1 ? '' : 's'} ago';
  }
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
                await ref
                    .read(strategyProvider.notifier)
                    .loadFromHive(widget.strategyData.id);

                if (!context.mounted) return;
                // Navigator.pushNamed(context, Routes.strategyView);

                // Navigator.push(
                //   context,
                //   PageRouteBuilder(
                //     pageBuilder: (_, __, ___) => const StrategyView(),
                //     transitionsBuilder: (_, animation, __, child) {
                //       const begin = Offset(1.0, 0.0);
                //       const end = Offset.zero;
                //       const curve = Curves.ease;
                //       var tween = Tween(begin: begin, end: end)
                //           .chain(CurveTween(curve: curve));
                //       return SlideTransition(
                //         position: animation.drive(tween),
                //         child: child,
                //       );
                //     },
                //   ),
                // );
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 200),
                    reverseTransitionDuration:
                        const Duration(milliseconds: 200), // pop duration
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const StrategyView(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.9, end: 1.0)
                              .chain(CurveTween(curve: Curves.easeOut))
                              .animate(animation),
                          child: child,
                        ),
                      );
                    },
                  ),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
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
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    "Attack",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    timeAgo(widget.strategyData.lastEdited),
                                  ),
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
                MenuItemButton(
                  onPressed: () async {
                    await ref
                        .read(strategyProvider.notifier)
                        .loadFromHive(widget.strategyData.id);
                    await ref
                        .read(strategyProvider.notifier)
                        .exportFile(widget.strategyData.id);
                    // await ref.read(strategyProvider.notifier).
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.upload,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "Export",
                      )
                    ],
                  ),
                ),
                MenuItemButton(
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
