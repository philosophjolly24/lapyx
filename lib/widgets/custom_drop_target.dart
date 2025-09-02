import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/strategy_provider.dart';

class FileImportDropTarget extends ConsumerStatefulWidget {
  const FileImportDropTarget({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomDropTargetState();
}

class _CustomDropTargetState extends ConsumerState<FileImportDropTarget> {
  bool isDragging = false;
  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragEntered: (details) {
        setState(() {
          isDragging = true;
        });
        // log("I'm in gurt");
      },
      onDragExited: (details) {
        setState(() {
          isDragging = false;
        });
      },
      onDragDone: (details) async {
        isDragging = false;

        await ref
            .read(strategyProvider.notifier)
            .loadFromFileDrop(details.files);
      },
      child: Stack(
        children: [
          (isDragging)
              ? const Positioned.fill(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.download, size: 60),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Import .ica file",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                )
              : Positioned.fill(child: widget.child)
        ],
      ),
    );
  }
}
