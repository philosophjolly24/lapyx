import 'package:flutter/material.dart';
import 'package:icarus/const/bounding_box.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/json_converters.dart';
import 'package:json_annotation/json_annotation.dart';

part "drawing_element.g.dart";

abstract class DrawingElement {
  @ColorConverter()
  final Color color;
  final bool isDotted;
  final bool hasArrow;

  BoundingBox? boundingBox;

  DrawingElement({
    required this.color,
    this.boundingBox,
    required this.isDotted,
    required this.hasArrow,
  });
}

class Line extends DrawingElement {
  final Offset lineStart;
  Offset lineEnd;

  Line({
    required this.lineStart,
    required this.lineEnd,
    required super.color,
    required super.isDotted,
    required super.hasArrow,
  });

  void updateEndPoint(Offset endPoint) {
    lineEnd = endPoint;
  }
}

@JsonSerializable()
class FreeDrawing extends DrawingElement {
  FreeDrawing({
    List<Offset>? listOfPoints,
    Path? path,
    required super.color,
    super.boundingBox,
    required super.isDotted,
    required super.hasArrow,
  })  : listOfPoints = listOfPoints ?? [],
        path = path ?? Path();

  @OffsetListConverter()
  List<Offset> listOfPoints = [];

  @JsonKey(includeFromJson: false, includeToJson: false)
  Path path = Path();

  factory FreeDrawing.fromJson(Map<String, dynamic> json) =>
      _$FreeDrawingFromJson(json);

  // @override
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

    Offset? previousPoint;
    for (int i = 0; i < screenPoints.length; i++) {
      final current = screenPoints[i];

      if (i != 0 && previousPoint != null) {
        double midX = (previousPoint.dx + current.dx) / 2;
        double midY = (previousPoint.dy + current.dy) / 2;
        if (i == 1) {
          path.lineTo(midX, midY);
        } else {
          path.quadraticBezierTo(
              previousPoint.dx, previousPoint.dy, midX, midY);
        }
      }
      previousPoint = current;
    }

    path.lineTo(previousPoint!.dx, previousPoint.dy);

    this.path = path;
  }

  FreeDrawing copyWith({
    List<Offset>? listOfPoints,
    Path? path,
    Color? color,
    BoundingBox? boundingBox,
    bool? isDotted,
    bool? hasArrow,
  }) {
    return FreeDrawing(
      color: color ?? this.color,
      listOfPoints: listOfPoints ?? this.listOfPoints,
      path: path ?? this.path,
      boundingBox: boundingBox ?? this.boundingBox,
      isDotted: isDotted ?? this.isDotted,
      hasArrow: hasArrow ?? this.hasArrow,
    );
  }

  @override
  String toString() {
    String ouptut = "";

    for (Offset offset in listOfPoints) {
      ouptut += "${offset.toString()}, ";
    }
    return ouptut;
  }

  List<Offset> pathSmoothing(List<Offset> points) {
    final List<Offset> smoothPoints = [];
    if (points.length < 2) {
      return points;
    }

    // Add the first point
    smoothPoints.add(points[0]);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];

      // Add more intermediate points with more extreme weighting
      // This creates 5 points between each original pair
      final q1 = Offset(
        0.9 * p0.dx + 0.1 * p1.dx,
        0.9 * p0.dy + 0.1 * p1.dy,
      );
      final q2 = Offset(
        0.7 * p0.dx + 0.3 * p1.dx,
        0.7 * p0.dy + 0.3 * p1.dy,
      );
      final q3 = Offset(
        0.5 * p0.dx + 0.5 * p1.dx,
        0.5 * p0.dy + 0.5 * p1.dy,
      );
      final q4 = Offset(
        0.3 * p0.dx + 0.7 * p1.dx,
        0.3 * p0.dy + 0.7 * p1.dy,
      );
      final q5 = Offset(
        0.1 * p0.dx + 0.9 * p1.dx,
        0.1 * p0.dy + 0.9 * p1.dy,
      );

      smoothPoints.add(q1);
      smoothPoints.add(q2);
      smoothPoints.add(q3);
      smoothPoints.add(q4);
      smoothPoints.add(q5);
    }

    // Add the last point
    smoothPoints.add(points.last);

    return smoothPoints;
  }
}
