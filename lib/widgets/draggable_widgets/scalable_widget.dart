import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/custom_icons.dart';

class ScalableWidget extends ConsumerWidget {
  const ScalableWidget({
    super.key,
    required this.child,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  final Function(DragUpdateDetails details) onPanUpdate;
  final GestureDragEndCallback onPanEnd;

  final Widget child;

  final double minScale = 100;
  final double maxScale = 500;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomRight,
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeDownRight,
              child: GestureDetector(
                  onPanUpdate: onPanUpdate,
                  // Update the scale based on horizontal drag changes.
                  // onPanUpdate: (details) {
                  onPanEnd: onPanEnd,
                  // },
                  child: const Icon(
                    CustomIcons.resizeCorner,
                    size: 12,
                  )),
            ),
          ),
        )
      ],
    );
  }
}
