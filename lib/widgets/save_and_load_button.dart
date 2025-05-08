import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/strategy_provider.dart';
import 'package:icarus/widgets/strategy_save_icon_button.dart';

class SaveButtonAndLoad extends ConsumerWidget {
  const SaveButtonAndLoad({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const AutoSaveButton(),
          IconButton(
            onPressed: () async {
              await ref
                  .read(strategyProvider.notifier)
                  .exportFile(ref.read(strategyProvider).id);
            },
            icon: const Icon(Icons.file_upload),
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
