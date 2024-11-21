import 'package:flutter/material.dart';

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
  List<Offset> paths = [];
}
