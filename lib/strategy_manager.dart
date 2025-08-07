import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/hive_boxes.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/const/update_checker.dart';
import 'package:icarus/widgets/dialogs/new_strategy_dialog.dart';
import 'package:icarus/providers/strategy_provider.dart';
import 'package:icarus/strategy_tile.dart';
import 'package:icarus/strategy_view.dart';
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
    setState(() {});
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height - 90;
    final Size playAreaSize = Size(height * 1.2, height);
    CoordinateSystem(playAreaSize: playAreaSize);
    void showCreateDialog() async {
      final String? strategyId = await showDialog<String>(
        context: context,
        builder: (context) {
          return const CreateStrategyDialog();
        },
      );

      if (strategyId != null) {
        setState(() {
          _isLoading = true;
        });
        if (!context.mounted) return;
        await navigateWithLoading(context, strategyId);
      }
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
          if (_isLoading)
            Positioned.fill(
                child: IgnorePointer(
              child: Container(
                color: const Color.fromARGB(62, 0, 0, 0),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ))
        ],
      ),
    );
  }

  Future<void> navigateWithLoading(
      BuildContext context, String strategyId) async {
    // Show loading overlay
    showLoadingOverlay(context);

    try {
      await ref.read(strategyProvider.notifier).loadFromHive(strategyId);

      if (!context.mounted) return;
      // Remove loading overlay
      Navigator.pop(context);

      setState(() {
        _isLoading = false;
      });
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 200),
          reverseTransitionDuration:
              const Duration(milliseconds: 200), // pop duration
          pageBuilder: (context, animation, secondaryAnimation) =>
              const StrategyView(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle errors
      Navigator.pop(context); // Remove loading overlay
      // Show error message
    }
  }
}
