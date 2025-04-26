import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:icarus/const/hive_boxes.dart';
import 'package:icarus/providers/strategy_provider.dart';
import 'package:icarus/strategy_tile.dart';
import 'package:icarus/widgets/bg_dot_painter.dart';

final strategiesProvider = StreamProvider<List<StrategyData>>((ref) {
  return Hive.box<StrategyData>(HiveBoxNames.strategiesBox).watch().map(
      (event) =>
          Hive.box<StrategyData>(HiveBoxNames.strategiesBox).values.toList());
});

class StrategyManager extends ConsumerWidget {
  const StrategyManager({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void showCreateDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Name Strategy"),
            content: const TextField(),
            actions: [
              TextButton(
                onPressed: () async {
                  await ref
                      .read(strategyProvider.notifier)
                      .createNewStrategy("other one");
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                },
                child: const Text("Create"),
              )
            ],
          );
        },
      );
    }

    final AsyncValue<List<StrategyData>> strategies =
        ref.watch(strategiesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Strategies"),
        actions: [
          TextButton.icon(
            onPressed: () {
              showCreateDialog();
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              "Create Strategy",
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.pressed)) {
                    return const Color.fromARGB(0, 224, 224, 224);
                  }
                  return Colors.transparent;
                },
              ),
              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.pressed)) {
                    return Colors.white.withAlpha(51);
                  }
                  return null; // Use the default ripple color.
                },
              ),
            ),
          )
        ],
      ),
      body:
          // StrategyTile(strategyData: strategies[0])

          Stack(
        children: [
          Positioned.fill(child: LayoutBuilder(builder: (context, constraints) {
            return BGDotGrid(
                size: Size(constraints.maxWidth, constraints.maxHeight));
          })),
          Positioned.fill(
            child: strategies.when(
              data: (strategies) {
                return GridView.builder(
                  itemCount: strategies.length,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 306,
                    mainAxisExtent: 250,
                  ),
                  itemBuilder: (context, index) {
                    return StrategyTile(strategyData: strategies[index]);
                  },
                );
              },
              loading: () => const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stackTrace) => Text('Error: $error'),
            ),
          ),
        ],
      ),
    );
  }
}
