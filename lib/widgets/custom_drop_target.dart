import 'dart:developer';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/strategy_provider.dart';

class CustomDropTarget extends ConsumerStatefulWidget {
  const CustomDropTarget({super.key, required this.child});
  final Widget child;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomDropTargetState();
}

class _CustomDropTargetState extends ConsumerState<CustomDropTarget> {
  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragEntered: (details) {
        log("I'm in gurt");
      },
      onDragDone: (details) async {
        await ref
            .read(strategyProvider.notifier)
            .loadFromFileDrop(details.files);
      },
      child: widget.child,
    );
  }
}
