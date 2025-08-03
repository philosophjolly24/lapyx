import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:icarus/const/coordinate_system.dart';

class RotatableWidget extends StatelessWidget {
  final Widget child;
  final double rotation;
  final Offset origin;
  final Function(DragUpdateDetails details) onPanUpdate;
  final Function(DragStartDetails details) onPanStart;

  final Function(DragEndDetails details) onPanEnd;
  final bool isDragging;
  final double? buttonLeft;
  final double? buttonTop;
  const RotatableWidget({
    super.key,
    required this.child,
    required this.rotation,
    required this.onPanUpdate,
    required this.onPanStart,
    required this.onPanEnd,
    required this.origin,
    required this.isDragging,
    this.buttonLeft,
    this.buttonTop,
  });

  @override
  Widget build(BuildContext context) {
    final coordinateSystem = CoordinateSystem.instance;
    final rotationOrigin = origin.scale(
        coordinateSystem.scaleFactor, coordinateSystem.scaleFactor);

    log(isDragging.toString());
    return Transform.rotate(
      angle: rotation,
      alignment: Alignment.topLeft,
      origin: rotationOrigin,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          child,
          if (!isDragging)
            Positioned(
              left: coordinateSystem.scale((buttonLeft ?? origin.dx - 7.5)),
              top: coordinateSystem.scale((buttonTop ?? 0)),
              child: SizedBox(
                width: coordinateSystem.scale(15),
                height: coordinateSystem.scale(15),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: onPanStart,
                  onPanUpdate: onPanUpdate,
                  onPanEnd: onPanEnd,
                  onTap: () {
                    log("I'm being hit");
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
