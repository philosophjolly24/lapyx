import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';

class RotatableWidget extends StatefulWidget {
  final Widget child;

  const RotatableWidget({
    super.key,
    required this.child,
  });

  @override
  State<RotatableWidget> createState() => _RotatableWidgetState();
}

//TODO: Will fix this mess later
class _RotatableWidgetState extends State<RotatableWidget> {
  double _rotation = 0.0;
  Offset _rotationOrigin = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.rotationZ(_rotation),
      alignment: Alignment.bottomCenter,
      child: Stack(
        children: [
          widget.child,
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                onPanStart: (details) {
                  final box = context.findRenderObject() as RenderBox;
                  final bottomCenter =
                      Offset(box.size.width / 2, box.size.height);

                  _rotationOrigin = box.localToGlobal(bottomCenter);
                },
                onPanUpdate: (details) {
                  if (_rotationOrigin == Offset.zero) return;

                  final currentPosition = details.globalPosition;
                  final previousPosition = currentPosition - details.delta;

                  // Calculate angles
                  double previousAngle =
                      (previousPosition - _rotationOrigin).direction;
                  double currentAngle =
                      (currentPosition - _rotationOrigin).direction;

                  if (previousAngle < 0) previousAngle += (2 * pi);
                  if (currentAngle < 0) currentAngle += (2 * pi);
                  // if (previousAngle < 0 != currentAngle > 0) {
                  //   if (previousAngle < 0)
                  //     previousAngle += 2 * pi;
                  //   else
                  //     currentAngle += 2 * pi;
                  // }
                  // // Update rotation
                  setState(() {
                    _rotation += (currentAngle - previousAngle);

                    dev.log("======");
                    dev.log("Rotation:${_rotation.toString()}");
                    dev.log("previousPosition:${previousPosition.toString()}");
                    dev.log("currentPosition:${currentPosition.toString()}");

                    dev.log("Previous Angle:${previousAngle.toString()}");
                    dev.log("Current Angle:${currentAngle.toString()}");
                    dev.log("======");
                  });
                },
                onPanEnd: (details) {
                  _rotationOrigin = Offset.zero;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
