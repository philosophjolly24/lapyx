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

  @override
  String toString() {
    String ouptut = "";

    for (Offset offset in listOfPoints) {
      ouptut += "${offset.toString()}, ";
    }
    return ouptut;
  }
}
