import 'package:flutter/material.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/widgets/ability/ability_widget.dart';
import 'package:icarus/widgets/ability/rotatable_widget.dart';
import 'dart:math' as math;

class PlacedAbilityWidget extends StatefulWidget {
  final PlacedAbility ability;
  final Function(DraggableDetails details) onDragEnd;

  const PlacedAbilityWidget(
      {super.key, required this.ability, required this.onDragEnd});

  @override
  State<PlacedAbilityWidget> createState() => _PlacedAbilityWidgetState();
}

class _PlacedAbilityWidgetState extends State<PlacedAbilityWidget> {
  Offset rotationOrigin = Offset.zero;
  GlobalKey globalKey = GlobalKey();
  Offset pointDragAnchorStrategy(
      Draggable<Object> draggable, BuildContext context, Offset position) {
    RenderBox? renderbox;

    renderbox = globalKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderbox == null) return Offset.zero;

    Offset feedBackCenter = renderbox
        .localToGlobal(Offset(renderbox.size.width / 2, renderbox.size.height));

    return (context.findRenderObject() as RenderBox)
        .globalToLocal(feedBackCenter);
  }

  @override
  Widget build(BuildContext context) {
    double rotation = widget.ability.rotaion;

    final coordinateSystem = CoordinateSystem.instance;

    return Positioned(
      left: coordinateSystem.coordinateToScreen(widget.ability.position).dx,
      top: coordinateSystem.coordinateToScreen(widget.ability.position).dy,
      child: !widget.ability.data.isTransformable
          ? Draggable(
              feedback: AbilityWidget(
                ability: widget.ability.data,
              ),
              childWhenDragging: const SizedBox.shrink(),
              onDragEnd: widget.onDragEnd,
              child: AbilityWidget(
                ability: widget.ability.data,
              ),
            )
          : RotatableWidget(
              rotation: rotation,
              onPanStart: (details) {
                final box = context.findRenderObject() as RenderBox;
                final bottomCenter =
                    Offset(box.size.width / 2, box.size.height);

                rotationOrigin = box.localToGlobal(bottomCenter);
              },
              onPanUpdate: (details) {
                if (rotationOrigin == Offset.zero) return;

                final currentPosition = details.globalPosition;

                // Calculate angles
                final Offset currentPositionNormalized =
                    (currentPosition - rotationOrigin);

                double currentAngle = math.atan2(
                    currentPositionNormalized.dy, currentPositionNormalized.dx);

                // // Update rotation
                setState(() {
                  rotation = (currentAngle) + (math.pi / 2);
                  widget.ability.rotaion = rotation;
                });
              },
              onPanEnd: (details) {
                setState(() {
                  rotationOrigin = Offset.zero;
                });
              },
              child: Positioned(
                child: Draggable(
                  feedback: Transform.rotate(
                    angle: rotation,
                    child: AbilityWidget(
                      ability: widget.ability.data,
                      key: globalKey,
                    ),
                  ),
                  childWhenDragging: const SizedBox.shrink(),
                  onDragEnd: widget.onDragEnd,
                  // dragAnchorStrategy: pointDragAnchorStrategy,
                  child: AbilityWidget(
                    ability: widget.ability.data,
                  ),
                ),
              ),
            ),
    );
  }
}
