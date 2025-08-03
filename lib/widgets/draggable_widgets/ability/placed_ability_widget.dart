import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/abilities.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/maps.dart';
import 'package:icarus/const/placed_classes.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/providers/ability_provider.dart';
import 'package:icarus/providers/map_provider.dart';
import 'package:icarus/providers/screen_zoom_provider.dart';
import 'package:icarus/widgets/draggable_widgets/ability/rotatable_widget.dart';
import 'dart:math' as math;

import 'package:icarus/widgets/draggable_widgets/zoom_transform.dart';

class PlacedAbilityWidget extends StatefulWidget {
  final PlacedAbility ability;
  final Function(DraggableDetails details) onDragEnd;
  final String id;
  final PlacedWidget data;
  final double rotation;
  const PlacedAbilityWidget({
    super.key,
    required this.ability,
    required this.onDragEnd,
    required this.id,
    required this.data,
    required this.rotation,
  });

  @override
  State<PlacedAbilityWidget> createState() => _PlacedAbilityWidgetState();
}

class _PlacedAbilityWidgetState extends State<PlacedAbilityWidget> {
  Offset rotationOrigin = Offset.zero;
  GlobalKey globalKey = GlobalKey();

  double? localRotation;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    localRotation ??= widget.rotation;
  }

  Offset rotateOffset(Offset point, Offset origin, double angle) {
    // Translate point to origin
    final dx = point.dx - origin.dx;
    final dy = point.dy - origin.dy;

    // Rotate around origin using rotation matrix
    final rotatedX = dx * math.cos(angle) - dy * math.sin(angle);
    final rotatedY = dx * math.sin(angle) + dy * math.cos(angle);

    // Translate back
    return Offset(
      rotatedX + origin.dx,
      rotatedY + origin.dy,
    );
  }

  @override
  Widget build(BuildContext context) {
    final coordinateSystem = CoordinateSystem.instance;
    if (localRotation == null) {
      return const SizedBox.shrink();
    }

    return Consumer(builder: (context, ref, child) {
      final index =
          PlacedWidget.getIndexByID(widget.id, ref.watch(abilityProvider));
      final bool isAlly = ref.watch(abilityProvider)[index].isAlly;

      final mapScale = Maps.mapScale[ref.watch(mapProvider).currentMap] ?? 1;
      //Linking the local rotation with global rotation for things like undo redo
      if (ref.watch(abilityProvider)[index].rotation != localRotation! &&
          rotationOrigin == Offset.zero) {
        localRotation = ref.read(abilityProvider)[index].rotation;
      }

      if (index < 0) {
        return Draggable<PlacedWidget>(
          dragAnchorStrategy:
              ref.read(screenZoomProvider.notifier).zoomDragAnchorStrategy,
          data: widget.data,
          feedback: Opacity(
            opacity: Settings.feedbackOpacity,
            child: ZoomTransform(
                child: widget.ability.data.abilityData!
                    .createWidget(null, isAlly, mapScale)),
          ),
          childWhenDragging: const SizedBox.shrink(),
          onDragEnd: widget.onDragEnd,
          child: widget.ability.data.abilityData!
              .createWidget(widget.id, isAlly, mapScale),
        );
      }

      if (widget.ability.data.abilityData is SquareAbility ||
          widget.ability.data.abilityData is CenterSquareAbility ||
          widget.ability.data.abilityData is RotatableImageAbility) {
        final isCenterSquare =
            widget.ability.data.abilityData is CenterSquareAbility;

        return Positioned(
          left: coordinateSystem.coordinateToScreen(widget.ability.position).dx,
          top: coordinateSystem.coordinateToScreen(widget.ability.position).dy,
          child: RotatableWidget(
            buttonTop: isCenterSquare
                ? widget.ability.data.abilityData!.getAnchorPoint(mapScale).dy -
                    Settings.abilitySize -
                    30
                : null,
            rotation: localRotation!,
            isDragging: isDragging,
            origin: widget.ability.data.abilityData!.getAnchorPoint(mapScale),
            onPanStart: (details) {
              log("Rotation Start");
              ref.read(abilityProvider.notifier).updateRotationHistory(index);
              final box = context.findRenderObject() as RenderBox;
              final bottomCenter = widget.ability.data.abilityData!
                  .getAnchorPoint(mapScale)
                  .scale(coordinateSystem.scaleFactor,
                      coordinateSystem.scaleFactor);
              // final bottomCenter =
              //     Offset(box.size.width / 2, box.size.height);

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
              final newRotation = (currentAngle) + (math.pi / 2);

              setState(() {
                localRotation = newRotation;
              });
            },
            onPanEnd: (details) {
              ref
                  .read(abilityProvider.notifier)
                  .updateRotation(index, localRotation!);
              setState(() {
                rotationOrigin = Offset.zero;
              });
            },
            child: Draggable<PlacedWidget>(
              data: widget.data,
              dragAnchorStrategy: (draggable, context, position) {
                final RenderBox renderObject =
                    context.findRenderObject()! as RenderBox;
                final anchorPoint = widget.ability.data.abilityData!
                    .getAnchorPoint(mapScale)
                    .scale(coordinateSystem.scaleFactor,
                        coordinateSystem.scaleFactor);
                Offset rotatedPos = rotateOffset(
                    renderObject.globalToLocal(position),
                    anchorPoint,
                    localRotation!);

                return ref
                    .read(screenZoomProvider.notifier)
                    .zoomOffset(rotatedPos);
              },
              feedback: Opacity(
                opacity: Settings.feedbackOpacity,
                child: Transform.rotate(
                  angle: localRotation!,
                  alignment: Alignment.topLeft,
                  origin: widget.ability.data.abilityData!
                      .getAnchorPoint(mapScale)
                      .scale(
                          coordinateSystem.scaleFactor *
                              ref.watch(screenZoomProvider),
                          coordinateSystem.scaleFactor *
                              ref.watch(screenZoomProvider)),
                  child: ZoomTransform(
                    child: ref
                        .watch(abilityProvider)[index]
                        .data
                        .abilityData!
                        .createWidget(
                            widget.id, isAlly, mapScale, localRotation!),
                  ),
                ),
              ),
              childWhenDragging: const SizedBox.shrink(),
              onDragStarted: () {
                setState(() {
                  isDragging = true;
                });
              },
              onDragEnd: (DraggableDetails details) {
                setState(() {
                  isDragging = false;
                });
                widget.onDragEnd(details);
              },
              // dragAnchorStrategy: pointDragAnchorStrategy,
              child: ref
                  .watch(abilityProvider)[index]
                  .data
                  .abilityData!
                  .createWidget(widget.id, isAlly, mapScale, localRotation!),
            ),
          ),
        );
      }
      return Positioned(
        left: coordinateSystem.coordinateToScreen(widget.ability.position).dx,
        top: coordinateSystem.coordinateToScreen(widget.ability.position).dy,
        child: Draggable<PlacedWidget>(
          dragAnchorStrategy:
              ref.read(screenZoomProvider.notifier).zoomDragAnchorStrategy,
          data: widget.data,
          feedback: Opacity(
            opacity: Settings.feedbackOpacity,
            child: ZoomTransform(
                child: widget.ability.data.abilityData!
                    .createWidget(null, isAlly, mapScale)),
          ),
          childWhenDragging: const SizedBox.shrink(),
          onDragEnd: widget.onDragEnd,
          child: widget.ability.data.abilityData!
              .createWidget(widget.id, isAlly, mapScale),
        ),
      );
    });
  }
}
