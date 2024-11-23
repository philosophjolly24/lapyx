import 'package:flutter/material.dart';
import 'package:icarus/interactive_map.dart';

abstract class DrawingElement {}

class Line extends DrawingElement {
  final Offset lineStart;
  Offset lineEnd;
  final Color? color;

  Line(this.color, {required this.lineStart, required this.lineEnd});

  void updateEndPoint(Offset endPoint) {
    lineEnd = endPoint;
  }
}

class FreeDrawing extends DrawingElement {
  List<Offset> listOfPoints = [];
  Path path = Path();

  void updatePath(Path newPath) {
    path = newPath;
  }

  void rebuildPath(CoordinateSystem coordinateSystem) {
    if (listOfPoints.length < 2) return;

    final freePath = Path();
    freePath.moveTo(coordinateSystem.coordinateToScreen(listOfPoints[0]).dx,
        coordinateSystem.coordinateToScreen(listOfPoints[0]).dy);

    for (int i = 0; i < listOfPoints.length - 2; i++) {
      final current = coordinateSystem.coordinateToScreen(listOfPoints[i]);
      final next = coordinateSystem.coordinateToScreen(listOfPoints[i + 1]);

      // Calculate the control point as the midpoint between points
      final controlPoint = Offset(
        (current.dx + next.dx) / 2,
        (current.dy + next.dy) / 2,
      );

      freePath.quadraticBezierTo(
        current.dx, current.dy, // control point
        controlPoint.dx, controlPoint.dy, // end point
      );
    }

    // Draw the last segment
    if (listOfPoints.length >= 2) {
      final last = listOfPoints.length - 1;
      final secondLast = listOfPoints.length - 2;

      final lastPoint = coordinateSystem.coordinateToScreen(listOfPoints[last]);
      final secondLastPoint =
          coordinateSystem.coordinateToScreen(listOfPoints[secondLast]);

      freePath.quadraticBezierTo(
        secondLastPoint.dx,
        secondLastPoint.dy,
        lastPoint.dx,
        lastPoint.dy,
      );
    }

    path = freePath;
  }
}
