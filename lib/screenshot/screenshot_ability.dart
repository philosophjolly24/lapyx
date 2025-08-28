import 'package:flutter/widgets.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/placed_classes.dart';

class ScreenshotAbility extends StatelessWidget {
  final PlacedAbility ability;
  final Function(DraggableDetails details) onDragEnd;
  final PlacedWidget data;
  final double rotation;
  final double length;
  final double abilitySize;
  final double mapScale;
  const ScreenshotAbility({
    super.key,
    required this.ability,
    required this.onDragEnd,
    required this.data,
    required this.rotation,
    required this.length,
    required this.abilitySize,
    required this.mapScale,
  });
  @override
  Widget build(BuildContext context) {
    final coordinateSystem = CoordinateSystem.instance;

    final bool isAlly = ability.isAlly;

    if (ability.data.abilityData is SquareAbility ||
        ability.data.abilityData is CenterSquareAbility ||
        ability.data.abilityData is RotatableImageAbility ||
        ability.data.abilityData is ResizableSquareAbility) {
      final isCenterSquare =
          widget.ability.data.abilityData is CenterSquareAbility;
      final double? buttonTop;
      if (isCenterSquare) {
        buttonTop = widget.ability.data.abilityData!
                .getAnchorPoint(mapScale, abilitySize)
                .dy -
            abilitySize -
            30;
      } else if (widget.ability.data.abilityData is ResizableSquareAbility) {
        final resizeWidget =
            (widget.ability.data.abilityData! as ResizableSquareAbility);

        // final double anchorLength = coordinateSystem.scale(
        //   resizeWidget.height -
        //       (coordinateSystem.normalize(localLength ?? 0))
        //           .clamp(resizeWidget.minLength, resizeWidget.height),
        // );
        final double clampedLength = resizeWidget.height -
            ((localLength ?? 0))
                .clamp(resizeWidget.minLength, resizeWidget.height);

        final double anchorLength = (clampedLength * mapScale);

        // log("anchor length: ${anchorLength.toString()} local length: ${localLength.toString()}");
        buttonTop = anchorLength;
      } else {
        buttonTop = null;
      }
      return Positioned(
        left: coordinateSystem.coordinateToScreen(widget.ability.position).dx,
        top: coordinateSystem.coordinateToScreen(widget.ability.position).dy,
        child: RotatableWidget(
          buttonTop: buttonTop,
          rotation: localRotation!,
          isDragging: isDragging,
          origin: widget.ability.data.abilityData!
              .getAnchorPoint(mapScale, abilitySize),
          onPanStart: (details) {
            log("Rotation Start");
            // ref.read(abilityProvider.notifier).updateRotationHistory(index);
            // ref.read(abilityProvider.notifier).updateLengthHistory(index);

            final box = context.findRenderObject() as RenderBox;
            final bottomCenter = widget.ability.data.abilityData!
                .getAnchorPoint(mapScale, abilitySize)
                .scale(
                    coordinateSystem.scaleFactor, coordinateSystem.scaleFactor);

            rotationOrigin = box.localToGlobal(bottomCenter);
            if (widget.ability.data.abilityData is ResizableSquareAbility) {
              final resizeAbility =
                  (widget.ability.data.abilityData! as ResizableSquareAbility);
              lengthOrigin = box.localToGlobal(
                resizeAbility.getLengthAnchor(mapScale, abilitySize).scale(
                    coordinateSystem.scaleFactor, coordinateSystem.scaleFactor),
              );
            }
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
            if (widget.ability.data.abilityData is ResizableSquareAbility) {
              final Offset currentPosLength = (currentPosition -
                  rotateOffset(lengthOrigin, rotationOrigin, localRotation!));
              double currentLength =
                  coordinateSystem.normalize(currentPosLength.distance) /
                      mapScale /
                      ref.watch(screenZoomProvider);

              setState(() {
                localLength = currentLength;
              });
            }
          },
          onPanEnd: (details) {
            ref
                .read(abilityProvider.notifier)
                .updateRotation(index, localRotation!, localLength ?? 0);

            setState(() {
              rotationOrigin = Offset.zero;
              lengthOrigin = Offset.zero;
            });
          },
          child: Draggable<PlacedWidget>(
            data: widget.data,
            dragAnchorStrategy: (draggable, context, position) {
              final RenderBox renderObject =
                  context.findRenderObject()! as RenderBox;
              final anchorPoint = widget.ability.data.abilityData!
                  .getAnchorPoint(mapScale, abilitySize)
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
                    .getAnchorPoint(mapScale, abilitySize)
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
                      .createWidget(widget.id, isAlly, mapScale, localRotation!,
                          localLength!),
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
                .createWidget(
                    widget.id, isAlly, mapScale, localRotation!, localLength),
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
  }
}
