import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:icarus/DrawingElement.dart';
import 'package:icarus/interactive_map.dart';
import 'package:icarus/main.dart';
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
    );

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

  DrawingPainter({
    required this.updateCounter,
    required this.coordinateSystem,
    required this.elements,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

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

        // final freePath = Path();
        // freePath.moveTo(coordinateSystem.coordinateToScreen(paths[0]).dx,
        //     coordinateSystem.coordinateToScreen(paths[0]).dy);

        // for (int i = 0; i < paths.length - 2; i++) {
        //   final current = coordinateSystem.coordinateToScreen(paths[i]);
        //   final next = coordinateSystem.coordinateToScreen(paths[i + 1]);

        //   // Calculate the control point as the midpoint between points
        //   final controlPoint = Offset(
        //     (current.dx + next.dx) / 2,
        //     (current.dy + next.dy) / 2,
        //   );

        //   freePath.quadraticBezierTo(
        //     current.dx, current.dy, // control point
        //     controlPoint.dx, controlPoint.dy, // end point
        //   );
        // }

        // // Draw the last segment
        // if (paths.length >= 2) {
        //   final last = paths.length - 1;
        //   final secondLast = paths.length - 2;

        //   final lastPoint = coordinateSystem.coordinateToScreen(paths[last]);
        //   final secondLastPoint =
        //       coordinateSystem.coordinateToScreen(paths[secondLast]);

        //   freePath.quadraticBezierTo(
        //     secondLastPoint.dx,
        //     secondLastPoint.dy,
        //     lastPoint.dx,
        //     lastPoint.dy,
        //   );
        // }

        // //Todo:fsf

        // for (int i = 1; i < paths.length; i++) {
        //   freePath.lineTo(coordinateSystem.coordinateToScreen(paths[i]).dx,
        //       coordinateSystem.coordinateToScreen(paths[i]).dy);
        // }
        canvas.drawPath(freeDrawing.path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    if (oldDelegate.coordinateSystem.playAreaSize !=
        coordinateSystem.playAreaSize) {
      log("I updataed");
      return true;
    }
    return oldDelegate.updateCounter !=
        updateCounter; // Repaint when elements change
  }
}
