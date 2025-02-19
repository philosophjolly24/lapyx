import 'package:flutter/material.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/json_converters.dart';
import 'package:json_annotation/json_annotation.dart';

part "drawing_element.g.dart";

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

@JsonSerializable()
class FreeDrawing extends DrawingElement {
  FreeDrawing();

  @OffsetListConverter()
  List<Offset> listOfPoints = [];

  @JsonKey(includeFromJson: false, includeToJson: false)
  Path path = Path();

  factory FreeDrawing.fromJson(Map<String, dynamic> json) =>
      _$FreeDrawingFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FreeDrawingToJson(this);

  void updatePath(Path newPath) {
    path = newPath;
  }

  void rebuildPath(CoordinateSystem coordinateSystem) {
    if (listOfPoints.length < 2) return;

    final path = Path();
    final screenPoints = listOfPoints
        .map((p) => coordinateSystem.coordinateToScreen(p))
        .toList();

    // Move to first point
    path.moveTo(screenPoints[0].dx, screenPoints[0].dy);

    // Add cubic Bezier segments between points
    for (int i = 0; i < screenPoints.length; i++) {
      final p0 = i > 0 ? screenPoints[i - 1] : screenPoints[0];
      final p1 = screenPoints[i];
      final p2 = i < screenPoints.length - 1 ? screenPoints[i + 1] : p1;
      final p3 = i < screenPoints.length - 2 ? screenPoints[i + 2] : p2;

      if (i == 0) {
        // First segment
        final controlPoint1 = p1 + (p2 - p0) * 0.1;
        final controlPoint2 = p2 - (p3 - p1) * 0.1;
        path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
            controlPoint2.dy, p2.dx, p2.dy);
      } else if (i < screenPoints.length - 2) {
        // Middle segments
        const tension = 0.5; // Adjust this value (0.0-1.0) for curve tightness
        final controlPoint1 = p1 + (p2 - p0) * tension * 0.5;
        final controlPoint2 = p2 - (p3 - p1) * tension * 0.5;
        path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
            controlPoint2.dy, p2.dx, p2.dy);
      }
    }

    // Handle last segment if needed
    if (screenPoints.length >= 2) {
      final last = screenPoints[screenPoints.length - 1];
      final secondLast = screenPoints[screenPoints.length - 2];
      path.quadraticBezierTo(secondLast.dx, secondLast.dy, last.dx, last.dy);
    }

    this.path = path;
  }

  @override
  String toString() {
    String ouptut = "";

    for (Offset offset in listOfPoints) {
      ouptut += "${offset.toString()}, ";
    }
    return ouptut;
  }
}
