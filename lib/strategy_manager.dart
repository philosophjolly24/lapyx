import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/hive_boxes.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/const/update_checker.dart';
import 'package:icarus/providers/folder_provider.dart';
import 'package:icarus/widgets/custom_button.dart';
import 'package:icarus/widgets/dialogs/strategy/create_strategy_dialog.dart';
import 'package:icarus/providers/strategy_provider.dart';
import 'package:icarus/strategy_tile.dart';
import 'package:icarus/strategy_view.dart';
import 'package:icarus/widgets/custom_drop_target.dart';
import 'package:icarus/widgets/dot_painter.dart';
import 'package:icarus/widgets/folder_edit_dialog.dart';
import 'package:icarus/widgets/folder_tile.dart';
import 'package:window_manager/window_manager.dart';

final strategiesListenable =
    Provider<ValueListenable<Box<StrategyData>>>((ref) {
  return Hive.box<StrategyData>(HiveBoxNames.strategiesBox).listenable();
});

final foldersListenable = Provider<ValueListenable<Box<Folder>>>((ref) {
  return Hive.box<Folder>(HiveBoxNames.foldersBox).listenable();
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

    final strategiesBoxListenable = ref.watch(strategiesListenable);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Strategies"),
        toolbarHeight: 90,
        actionsPadding: const EdgeInsets.only(right: 24),
        actions: [
          Row(
            spacing: 15,
            children: [
              CustomButton(
                onPressed: () async {
                  await ref
                      .read(strategyProvider.notifier)
                      .loadFromFilePicker();
                },
                height: 40,
                icon: const Icon(Icons.file_download, color: Colors.white),
                label: "Import .ica",
                labelColor: Colors.white,
                backgroundColor: Settings.highlightColor,
              ),
              CustomButton(
                onPressed: () async {
                  await showDialog<String>(
                    context: context,
                    builder: (context) {
                      return const FolderEditDialog();
                    },
                  );
                  // await ref.read(folderProvider.notifier).createFolder();
                },
                height: 40,
                icon: const Icon(Icons.create_new_folder_rounded,
                    color: Colors.white),
                label: "Add Folder",
                labelColor: Colors.white,
                backgroundColor: Settings.highlightColor,
              ),
              CustomButton(
                onPressed: showCreateDialog,
                height: 40,
                icon: const Icon(Icons.add, color: Colors.white),
                label: "Create Strategy",
                labelColor: Colors.white,
                backgroundColor: Colors.deepPurple,
              ),
            ],
          )
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: DotGrid(),
            ),
          ),
          Positioned.fill(
            child: ValueListenableBuilder<Box<StrategyData>>(
              valueListenable: strategiesBoxListenable,
              builder: (context, strategyBox, _) {
                final foldersBoxListenable = ref.watch(foldersListenable);
                return ValueListenableBuilder<Box<Folder>>(
                  valueListenable: foldersBoxListenable,
                  builder: (context, folderBox, _) {
                    final folders = folderBox.values.toList();
                    folders
                        .sort((a, b) => a.dateCreated.compareTo(b.dateCreated));

                    final strategies = strategyBox.values.toList();
                    strategies
                        .sort((a, b) => b.lastEdited.compareTo(a.lastEdited));

                    // Filter strategies and folders by the current folder
                    strategies
                        .removeWhere((strategy) => strategy.folderID != null);
                    folders.removeWhere(
                        (listFolder) => listFolder.parentID != null);
                    List<GridItem> gridItems = [
                      ...folders.map((folder) => FolderItem(folder)),
                      ...strategies.map((strategy) => StrategyItem(strategy)),
                    ];

                    if (gridItems.isEmpty) {
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
                      child: LayoutBuilder(builder: (context, constraints) {
                        // Calculate how many columns can fit with minimum width
                        const double minTileWidth = 250; // Your minimum width
                        const double spacing = 20;
                        const double padding = 32; // 16 * 2

                        int crossAxisCount =
                            ((constraints.maxWidth - padding + spacing) /
                                    (minTileWidth + spacing))
                                .floor();
                        crossAxisCount =
                            crossAxisCount.clamp(1, double.infinity).toInt();
                        return GridView.builder(
                          itemCount: gridItems.length,
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisExtent: 250,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                          itemBuilder: (context, index) {
                            final item = gridItems[index];
                            if (item is FolderItem) {
                              return FolderTile(folder: item.folder);
                            } else if (item is StrategyItem) {
                              return StrategyTile(strategyData: item.strategy);
                            }
                            return const SizedBox.shrink();
                          },
                        );
                      }),
                    );
                  },
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

abstract class GridItem {}

class FolderItem extends GridItem {
  final Folder folder;

  FolderItem(this.folder);
}

class StrategyItem extends GridItem {
  final StrategyData strategy;

  StrategyItem(this.strategy);
}
