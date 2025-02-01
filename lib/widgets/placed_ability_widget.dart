import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/providers/ability_provider.dart';
import 'package:icarus/widgets/ability/ability_widget.dart';
import 'package:icarus/widgets/ability/rotatable_widget.dart';
import 'dart:math' as math;

class PlacedAbilityWidget extends StatefulWidget {
  final PlacedAbility ability;
  final Function(DraggableDetails details) onDragEnd;
  final int index;
  const PlacedAbilityWidget(
      {super.key,
      required this.ability,
      required this.onDragEnd,
      required this.index});

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
    final coordinateSystem = CoordinateSystem.instance;

    return Consumer(builder: (context, ref, child) {
      double rotation = ref.watch(abilityProvider)[widget.index].rotaion;
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

                  double currentAngle = math.atan2(currentPositionNormalized.dy,
                      currentPositionNormalized.dx);

                  // // Update rotation
                  final newRotation = (currentAngle) + (math.pi / 2);
                  ref
                      .read(abilityProvider.notifier)
                      .updateRotation(widget.index, newRotation);
                },
                onPanEnd: (details) {
                  setState(() {
                    rotationOrigin = Offset.zero;
                  });
                },
                child: Positioned(
                  child: Draggable(
                    feedback: ref
                        .watch(abilityProvider)[widget.index]
                        .data
                        .abilityWidget!(rotation),
                    childWhenDragging: const SizedBox.shrink(),
                    onDragEnd: widget.onDragEnd,
                    // dragAnchorStrategy: pointDragAnchorStrategy,
                    child: ref
                        .watch(abilityProvider)[widget.index]
                        .data
                        .abilityWidget!(rotation),
                  ),
                ),
              ),
      );
    });
  }
}
