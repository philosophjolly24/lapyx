import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/hive_boxes.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/const/update_checker.dart';
import 'package:icarus/providers/new_strategy_dialog.dart';
import 'package:icarus/providers/strategy_provider.dart';
import 'package:icarus/strategy_tile.dart';
import 'package:icarus/widgets/bg_dot_painter.dart';
import 'package:icarus/widgets/custom_drop_target.dart';
import 'package:window_manager/window_manager.dart';

final strategiesProvider = Provider<ValueListenable<Box<StrategyData>>>((ref) {
  return Hive.box<StrategyData>(HiveBoxNames.strategiesBox).listenable();
});

class StrategyManager extends ConsumerStatefulWidget {
  const StrategyManager({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StrategyManagerState();
}

class _StrategyManagerState extends ConsumerState<StrategyManager>
    with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _init();
    _checkUpdate();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  void _checkUpdate() async {
    await UpdateChecker.checkForUpdate(context);
  }

  void _init() async {
    // Add this line to override the default close handler
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (!isPreventClose) return;

    await windowManager.destroy(); // Then close the window/app
  }

  @override
  Widget build(BuildContext context) {
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

    // UpdateChecker.checkForUpdate(context);
    final strategiesListenable = ref.watch(strategiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Strategies"),
        toolbarHeight: 90,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: 40,
              child: TextButton.icon(
                onPressed: () async {
                  await ref
                      .read(strategyProvider.notifier)
                      .loadFromFilePicker();
                },
                icon: const Icon(Icons.file_download, color: Colors.white),
                label: const Text(
                  "Import .ica",
                  // textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  alignment: Alignment.center,
                  backgroundColor:
                      WidgetStateProperty.all(Settings.highlightColor),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
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
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: SizedBox(
              height: 40,
              child: TextButton.icon(
                onPressed: showCreateDialog,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Create Strategy",
                  // textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  alignment: Alignment.center,
                  backgroundColor: WidgetStateProperty.all(Colors.deepPurple),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
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
              ),
            ),
          ),
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
                strategies.sort((a, b) => b.lastEdited.compareTo(a.lastEdited));
                if (strategies.isEmpty) {
                  return const FileImportDropTarget(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('No strategies available'),
                          Text("Create a new strategy or drop an .ica file")
                        ],
                      ),
                    ),
                  );
                }

                return FileImportDropTarget(
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
