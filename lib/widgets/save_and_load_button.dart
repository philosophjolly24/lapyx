import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/providers/strategy_provider.dart';

class SaveButtonAndLoad extends ConsumerWidget {
  const SaveButtonAndLoad({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              await ref
                  .read(strategyProvider.notifier)
                  .saveFile(ref.read(strategyProvider).id);

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Center(
                    child: Text(
                      "File Saved",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  duration: Duration(milliseconds: 350),
                  backgroundColor: Settings.sideBarColor,
                  behavior: SnackBarBehavior.floating,
                  width: 200,
                ),
              );
            },
            icon: const Icon(Icons.save),
          ),
          IconButton(
            onPressed: () async {
              await ref.read(strategyProvider.notifier).loadFile("");
            },
            icon: const Icon(Icons.file_open),
          ),
          // IconButton(
          //   onPressed: () async {
          //     log(ref.read(drawingProvider).toString());
          //   },
          //   icon: const Icon(Icons.bug_report),
          // ),
        ],
      ),
    );
  }
}
