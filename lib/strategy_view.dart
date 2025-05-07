import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/custom_icons.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/interactive_map.dart';
import 'package:icarus/providers/strategy_provider.dart';
import 'package:icarus/sidebar.dart';
import 'package:icarus/widgets/map_selector.dart';
import 'package:icarus/widgets/save_and_load_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

class StrategyView extends ConsumerStatefulWidget {
  const StrategyView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StrategyViewState();
}

class _StrategyViewState extends ConsumerState<StrategyView>
    with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _init();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  void _init() async {
    // Add this line to override the default close handler
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 15, top: 15, bottom: 10, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.home)),
                    const SizedBox(width: 5),
                    const MapSelector(),
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          await launchUrl(Settings.dicordLink);
                        },
                        child: const Row(
                          children: [
                            Text("Have any bugs? Join the Discord"),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              CustomIcons.discord,
                              color: Colors.white,
                            )
                          ],
                        )),
                    // IconButton(
                    //   onPressed: () {
                    //     String id = ref.watch(strategyProvider).id;
                    //     ref.read(strategyProvider.notifier).exportFile(id);
                    //   },
                    //   icon: const Icon(Icons.file_open_outlined),
                    // )
                  ],
                )
              ],
            ),
          ),
          const Expanded(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: InteractiveMap(),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: SaveButtonAndLoad(),
                ),
                SideBarUI()
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (!isPreventClose) return;

    if (ref.read(strategyProvider).isSaved) {
      if (!mounted) return;
      Navigator.of(context).pop(); // Close the dialog *after* saving
      await windowManager.destroy(); // Then close the window/app
      return;
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Settings.sideBarColor,
          title: const Text("Save Strategy?"),
          content: const Text(
            "You have unsaved changes to your strategy.\n"
            "Closing without saving will lose these changes.",
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'), // Explicit "Cancel"
              onPressed: () {
                Navigator.of(context).pop(); // Just close the dialog
              },
            ),
            TextButton(
              child: const Text("Don't Save"),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await windowManager.destroy(); // Then, close the window/app
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                await ref
                    .read(strategyProvider.notifier)
                    .saveToHive(ref.read(strategyProvider).id);
                if (!mounted) return;
                Navigator.of(context).pop(); // Close the dialog *after* saving
                await windowManager.destroy(); // Then close the window/app
              },
            ),
          ],
        );
      },
    );
  }
}
