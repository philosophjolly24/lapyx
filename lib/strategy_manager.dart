import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:icarus/const/hive_boxes.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/providers/strategy_provider.dart';

class StrategyManager extends ConsumerWidget {
  const StrategyManager({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strategies =
        Hive.box<StrategyData>(HiveBoxNames.strategiesBox).values.toList();
    return Scaffold(
      body: GridView.builder(
        itemCount: strategies.length,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 268,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          // if (newIndex == 0) {
          //   return InkWell(
          //     child: Container(
          //       decoration: const BoxDecoration(
          //         color: Color(0xFF151515),
          //         borderRadius: BorderRadius.all(Radius.circular(24)),
          //       ),
          //       child: const Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Icon(Icons.add),
          //           SizedBox(height: 20),
          //           Text("Make new Strategy")
          //         ],
          //       ),
          //     ),
          //     onTap: () {},
          //   );
          // }
          return InkWell(
            child: Container(
              decoration: BoxDecoration(
                color: Settings.sideBarColor,
                border: Border.all(
                  color: Settings.highlightColor,
                  width: 2,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 193,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24)),
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(strategies[index].name),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(""),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {},
          );
        },
      ),
    );
  }
}
