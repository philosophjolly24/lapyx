import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:icarus/const/hive_boxes.dart';
import 'package:icarus/providers/screenshot_provider.dart';
import 'package:icarus/providers/strategy_provider.dart';
import 'package:icarus/screenshot/screen_interactive_map.dart';
import 'package:icarus/screenshot/screenshot_view.dart';
import 'package:icarus/widgets/settings_tab.dart';
import 'package:icarus/widgets/strategy_save_icon_button.dart';
import 'package:screenshot/screenshot.dart';

class SaveButtonAndLoad extends ConsumerWidget {
  const SaveButtonAndLoad({
    super.key,
    required this.screenshotController,
  });
  final ScreenshotController screenshotController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              // // Navigator.of(context).pushNamed(Routes.settings);
              // Navigator.of(context).push(
              //   PageRouteBuilder(
              //     opaque: false,
              //     // barrierColor: Colors.black54,
              //     pageBuilder: (_, __, ___) => const SettingsTab(),
              //   ),
              // );

              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  transitionDuration: const Duration(milliseconds: 250),
                  reverseTransitionDuration: const Duration(milliseconds: 200),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const SettingsTab();
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    // Slide from right to left on push, and left to right on pop
                    final offsetAnimation = Tween<Offset>(
                      begin: const Offset(
                          -1, 0.0), // start off-screen to the right
                      end: Offset.zero, // end at normal position
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                      reverseCurve: Curves.easeOutCubic,
                    ));

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
          const AutoSaveButton(),
          IconButton(
            tooltip: "Export",
            onPressed: () async {
              await ref
                  .read(strategyProvider.notifier)
                  .exportFile(ref.read(strategyProvider).id);
            },
            icon: const Icon(Icons.file_upload),
          ),
          IconButton(
            tooltip: "Screenshot",
            onPressed: () async {
              // final dir = await getDownloadsDirectory();
              ref.read(screenshotProvider.notifier).setIsScreenShot(true);
              final String id = ref.read(strategyProvider).id;
              await ref.read(strategyProvider.notifier).saveToHive(id);

              final newStrat =
                  Hive.box<StrategyData>(HiveBoxNames.strategiesBox)
                      .values
                      .where((StrategyData strategy) {
                return strategy.id == id;
              }).firstOrNull;

              if (newStrat == null) {
                log("Couldn't find save");
                return;
              }
              // screenshotController.capture().then((Uint8List image){});

              screenshotController.captureFromWidget(ScreenShotInteractiveMap(
                mapValue: newStrat.mapData,
                agents: newStrat.agentData,
                abilities: newStrat.abilityData,
                text: newStrat.textData,
                items: newStrat.imageData,
                drawings: newStrat.drawingData,
                utilities: newStrat.utilityData,
                strategySettings: newStrat.strategySettings,
              ));
            },
            icon: const Icon(Icons.camera_alt_outlined),
          ),
        ],
      ),
    );
  }
}
