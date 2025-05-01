import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/hive_boxes.dart';
import 'package:icarus/providers/new_strategy_dialog.dart';
import 'package:icarus/providers/strategy_provider.dart';
import 'package:icarus/strategy_tile.dart';
import 'package:icarus/widgets/bg_dot_painter.dart';
import 'package:icarus/widgets/custom_drop_target.dart';

final strategiesProvider = Provider<ValueListenable<Box<StrategyData>>>((ref) {
  return Hive.box<StrategyData>(HiveBoxNames.strategiesBox).listenable();
});

class StrategyManager extends ConsumerWidget {
  const StrategyManager({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double height = MediaQuery.sizeOf(context).height - 90;
    final Size playAreaSize = Size(height * 1.2, height);
    CoordinateSystem(playAreaSize: playAreaSize);
    void showCreateDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return const CreateStrategyDialog();
        },
      );
    }

    final strategiesListenable = ref.watch(strategiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Strategies"),
        actions: [
          TextButton.icon(
            onPressed: showCreateDialog,
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
                  return null;
                },
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return BGDotGrid(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                );
              },
            ),
          ),
          Positioned.fill(
            child: ValueListenableBuilder<Box<StrategyData>>(
              valueListenable: strategiesListenable,
              builder: (context, box, _) {
                final strategies = box.values.toList();

                if (strategies.isEmpty) {
                  return const CustomDropTarget(
                    child: Center(
                      child: Text('No strategies available'),
                    ),
                  );
                }

                return CustomDropTarget(
                  child: GridView.builder(
                    itemCount: strategies.length,
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 306,
                      mainAxisExtent: 250,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) {
                      return StrategyTile(strategyData: strategies[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
