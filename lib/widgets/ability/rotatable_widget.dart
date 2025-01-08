import 'package:flutter/material.dart';
import 'package:icarus/const/coordinate_system.dart';

class RotatableWidget extends StatelessWidget {
  final Widget child;
  final double rotation;
  final Function(DragUpdateDetails details) onPanUpdate;
  final Function(DragStartDetails details) onPanStart;

  final Function(DragEndDetails details) onPanEnd;

  const RotatableWidget({
    super.key,
    required this.child,
    required this.rotation,
    required this.onPanUpdate,
    required this.onPanStart,
    required this.onPanEnd,
  });

  @override
  Widget build(BuildContext context) {
    final coordinateSystem = CoordinateSystem.instance;

    return Transform(
      transform: Matrix4.rotationZ(rotation),
      alignment: Alignment.bottomCenter,
      child: Stack(
        children: [
          child,
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanStart: onPanStart,
                onPanUpdate: onPanUpdate,
                onPanEnd: onPanEnd,
                child: Container(
                  width: coordinateSystem.scale(20),
                  height: coordinateSystem.scale(20),
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
