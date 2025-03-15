import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/drawing_element.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/providers/drawing_provider.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/providers/interaction_state_provider.dart';
import 'package:icarus/providers/pen_provider.dart';

class InteractivePainter extends ConsumerStatefulWidget {
  const InteractivePainter({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InteractivePainterState();
}

class _InteractivePainterState extends ConsumerState<InteractivePainter> {
  Size? _previousSize;
  @override
  Widget build(BuildContext context) {
    CoordinateSystem coordinateSystem = CoordinateSystem.instance;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_previousSize != coordinateSystem.playAreaSize) {
        ref.read(drawingProvider.notifier).rebuildAllPaths(coordinateSystem);
        _previousSize = coordinateSystem.playAreaSize;
      }
    });
    // Get the drawing data here in the widget
    DrawingState drawingState = ref.watch(drawingProvider);

    CustomPainter drawingPainter = DrawingPainter(
        updateCounter: drawingState.updateCounter,
        coordinateSystem: coordinateSystem,
        elements: drawingState.elements, // Pass the data directly
        drawingProvider: ref.read(drawingProvider.notifier),
        currentLine: drawingState.currentElement);

    final currentInteractionState = ref.watch(interactionStateProvider);

    bool isNavigating = currentInteractionState == InteractionState.navigation;
    return IgnorePointer(
      ignoring: isNavigating,
      child: RepaintBoundary(
        child: GestureDetector(
          onPanStart: (details) {
            final currentColor = ref.watch(penProvider).color;
            log(currentColor.toString());
            switch (currentInteractionState) {
              // case InteractionState.drawLine:
              //   Offset lineStart =
              //       coordinateSystem.screenToCoordinate(details.localPosition);
              //   ref.read(drawingProvider.notifier).startLine(lineStart);

              case InteractionState.drawing:
                ref.read(drawingProvider.notifier).startFreeDrawing(
                    details.localPosition, coordinateSystem, currentColor);
              default:
            }
          },
          onPanUpdate: (details) {
            switch (currentInteractionState) {
              // case InteractionState.drawLine:
              //   Offset lineEnd =
              //       coordinateSystem.screenToCoordinate(details.localPosition);

              //   ref.read(drawingProvider.notifier).updateCurrentLine(lineEnd);
              case InteractionState.drawing:
                ref
                    .read(drawingProvider.notifier)
                    .updateFreeDrawing(details.localPosition, coordinateSystem);
              default:
            }
          },
          onPanEnd: (details) {
            switch (currentInteractionState) {
              // case InteractionState.drawLine:
              //   Offset lineEnd =
              //       coordinateSystem.screenToCoordinate(details.localPosition);
              //   ref.read(drawingProvider.notifier).finishCurrentLine(lineEnd);
              case InteractionState.drawing:
                ref
                    .read(drawingProvider.notifier)
                    .finishFreeDrawing(details.localPosition, coordinateSystem);
              default:
            }
          },
          child: CustomPaint(
            painter: drawingPainter,
          ),
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final CoordinateSystem coordinateSystem;
  final List<DrawingElement> elements; // Store the drawing elements
  final DrawingElement? currentLine;
  final int updateCounter;
  final DrawingProvider drawingProvider;

  DrawingPainter({
    required this.updateCounter,
    required this.currentLine,
    required this.coordinateSystem,
    required this.elements,
    required this.drawingProvider,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = coordinateSystem.scale(Settings.brushSize)
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < elements.length; i++) {
      paint.color = elements[i].color;
      if (elements[i] is Line) {
        Line line = elements[i] as Line;
        Offset screenStartOffset =
            coordinateSystem.coordinateToScreen(line.lineStart);

        Offset screenEndOffset =
            coordinateSystem.coordinateToScreen(line.lineEnd);

        canvas.drawLine(screenStartOffset, screenEndOffset, paint);
      } else if (elements[i] is FreeDrawing) {
        FreeDrawing freeDrawing = elements[i] as FreeDrawing;
        List<Offset> paths = freeDrawing.listOfPoints;
        if (paths.length < 2) return;

        canvas.drawPath(freeDrawing.path, paint);
      }
    }

    if (currentLine != null) {
      paint.color = currentLine!.color;
      if (currentLine is FreeDrawing) {
        final drawingElement = currentLine as FreeDrawing;

        canvas.drawPath(drawingElement.path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return oldDelegate.updateCounter !=
        updateCounter; // Repaint when elements change
  }
}
