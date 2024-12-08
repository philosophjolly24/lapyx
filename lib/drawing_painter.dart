import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:icarus/DrawingElement.dart';
import 'package:icarus/interactive_map.dart';
import 'package:icarus/providers/drawing_provider.dart';
import 'package:provider/provider.dart';

class InteractivePainter extends StatefulWidget {
  final Size playAreaSize;
  const InteractivePainter({super.key, required this.playAreaSize});

  @override
  State<InteractivePainter> createState() => _InteractivePainterState();
}

class _InteractivePainterState extends State<InteractivePainter> {
  @override
  Widget build(BuildContext context) {
    CoordinateSystem coordinateSystem =
        CoordinateSystem(playAreaSize: widget.playAreaSize);

    // Get the drawing data here in the widget
    final drawingProvider = context.watch<DrawingProvider>();

    CustomPainter drawingPainter = DrawingPainter(
        updateCounter: drawingProvider.updateCounter,
        coordinateSystem: coordinateSystem,
        elements: drawingProvider.listOfElements, // Pass the data directly
        drawingProvider: drawingProvider);

    bool isNavigating =
        drawingProvider.interactionState == InteractionState.navigation;
    return IgnorePointer(
      ignoring: isNavigating,
      child: GestureDetector(
        onPanStart: (details) {
          switch (drawingProvider.interactionState) {
            case InteractionState.drawLine:
              Offset lineStart =
                  coordinateSystem.screenToCoordinate(details.localPosition);
              drawingProvider.startLine(lineStart);
            case InteractionState.drawFreeLine:
              drawingProvider.startFreeDrawing(
                  details.localPosition, coordinateSystem);
            default:
          }
        },
        onPanUpdate: (details) {
          switch (drawingProvider.interactionState) {
            case InteractionState.drawLine:
              Offset lineEnd =
                  coordinateSystem.screenToCoordinate(details.localPosition);

              drawingProvider.updateCurrentLine(lineEnd);
            case InteractionState.drawFreeLine:
              drawingProvider.updateFreeDrawing(
                  details.localPosition, coordinateSystem);
            default:
          }
        },
        onPanEnd: (details) {
          switch (drawingProvider.interactionState) {
            case InteractionState.drawLine:
              Offset lineEnd =
                  coordinateSystem.screenToCoordinate(details.localPosition);
              drawingProvider.finishCurrentLine(lineEnd);
            case InteractionState.drawFreeLine:
              drawingProvider.finishFreeDrawing(
                  details.localPosition, coordinateSystem);
            default:
          }
        },
        child: CustomPaint(
          painter: drawingPainter,
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final CoordinateSystem coordinateSystem;
  final List<DrawingElement> elements; // Store the drawing elements
  final int updateCounter;
  final DrawingProvider drawingProvider;

  DrawingPainter(
      {required this.updateCounter,
      required this.coordinateSystem,
      required this.elements,
      required this.drawingProvider});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < elements.length; i++) {
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
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    if (oldDelegate.coordinateSystem.playAreaSize !=
        coordinateSystem.playAreaSize) {
      log("I updataed");
      drawingProvider.rebuildAllPaths(coordinateSystem);
      return true;
    }
    return oldDelegate.updateCounter !=
        updateCounter; // Repaint when elements change
  }
}
