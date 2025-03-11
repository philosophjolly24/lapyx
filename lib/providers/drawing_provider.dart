import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/drawing_element.dart';

class DrawingState {
  final List<DrawingElement> elements;
  final int updateCounter; // Keep this!
  final DrawingElement? currentElement;

  DrawingState({
    required this.elements,
    this.updateCounter = 0,
    this.currentElement,
  });

  DrawingState copyWith({
    List<DrawingElement>? elements,
    int? updateCounter,
    DrawingElement? currentElement,
  }) {
    return DrawingState(
      elements: elements ?? this.elements,
      updateCounter: updateCounter ?? this.updateCounter,
      currentElement: currentElement ?? this.currentElement,
    );
  }

  //The copy with pattern does not work in this current situation because sometimes we actually need to set a null value to drawingState
  DrawingState copyWithButEvil({
    List<DrawingElement>? elements,
    int? updateCounter,
  }) {
    return DrawingState(
      elements: elements ?? this.elements,
      updateCounter: updateCounter ?? this.updateCounter,
      currentElement: null,
    );
  }

  @override
  String toString() {
    String output = "";
    for (DrawingElement element in elements) {
      if (element is FreeDrawing) {
        output += "${element.listOfPoints.toString()} \n--------------\n";
      }
    }
    return output;
  }
}

final drawingProvider =
    NotifierProvider<DrawingProvider, DrawingState>(DrawingProvider.new);

class DrawingProvider extends Notifier<DrawingState> {
  @override
  DrawingState build() {
    return DrawingState(elements: []);
  }

  String toJson() {
    final List<Map<String, dynamic>> jsonList = state.elements
        .whereType<FreeDrawing>()
        .map((element) => element.toJson())
        .toList();
    return jsonEncode(jsonList);
  }

  void fromJson(String jsonString) {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    final coordinateSystem = CoordinateSystem.instance;

    state = state.copyWith(
        elements: jsonList.map((json) {
      final drawing = FreeDrawing.fromJson(json as Map<String, dynamic>);
      drawing.rebuildPath(coordinateSystem);

      return drawing;
    }).toList());

    _triggerRepaint();
  }

  void _triggerRepaint() {
    state = state.copyWith(updateCounter: (state.updateCounter + 1));
  }

  void startFreeDrawing(Offset start, CoordinateSystem coordinateSystem) {
    if (state.currentElement != null) {
      dev.log(
          "An error occured the gesture detecture is attempting to draw while another line is active");
      return;
    }

    FreeDrawing freeDrawing = FreeDrawing();

    freeDrawing.path.moveTo(start.dx, start.dy);

    freeDrawing.listOfPoints.add(coordinateSystem.screenToCoordinate(start));

    state = state.copyWith(currentElement: freeDrawing);

    _triggerRepaint();
  }

  void updateFreeDrawing(Offset offset, CoordinateSystem coordinateSystem) {
    final currentDrawing = (state.currentElement as FreeDrawing);

    List<Offset> currentPoints = currentDrawing.listOfPoints;
    Offset lastPoint = currentPoints[currentPoints.length - 1];

    final minDistance = coordinateSystem.scale(3);
    if ((lastPoint - offset).distance < minDistance) return;

    currentDrawing.path.lineTo(offset.dx, offset.dy);
    currentDrawing.listOfPoints
        .add(coordinateSystem.screenToCoordinate(offset));

    state = state.copyWith(currentElement: currentDrawing);
    _triggerRepaint();
  }

  void finishFreeDrawing(Offset offset, CoordinateSystem coordinateSystem) {
    final currentDrawing = state.currentElement as FreeDrawing;
    currentDrawing.listOfPoints
        .add(coordinateSystem.screenToCoordinate(offset));

    FreeDrawing simplifiedDrawing = douglasPeucker(currentDrawing, 1.5);
    // douglasPeucker(currentDrawing, 1);

    simplifiedDrawing.rebuildPath(coordinateSystem);
    state = state.copyWithButEvil(
      elements: [...state.elements, simplifiedDrawing],
    );
    _triggerRepaint();
  }

  //TODO: Fix ts later
  void startLine(Offset start) {
    final listOfElements = state.elements;

    if (state.currentElement != null) {
      dev.log(
          "An error occured the gesture detecture is attempting to draw while another line is active");
      return;
    }

    Line newLine = Line(null, lineStart: start, lineEnd: start);
    listOfElements.add(newLine);

    state = state.copyWith(elements: listOfElements);
    // _indexOfCurrentEdit = listOfElements.length - 1;
    _triggerRepaint();
  }

  void updateCurrentLine(Offset endpoint) {
    final listOfElements = state.elements;
    // (listOfElements[_indexOfCurrentEdit] as Line).updateEndPoint(endpoint);

    state = state.copyWith(elements: listOfElements);
    _triggerRepaint();
  }

  void finishCurrentLine(Offset endpoint) {
    final listOfElements = state.elements;

    // (listOfElements[_indexOfCurrentEdit] as Line).updateEndPoint(endpoint);
    // _indexOfCurrentEdit = -1;

    state = state.copyWith(elements: listOfElements);
    _triggerRepaint();
  }

  void rebuildAllPaths(CoordinateSystem coordinateSystem) {
    final listOfElements = state.elements;

    for (DrawingElement drawingElement in listOfElements) {
      if (drawingElement is FreeDrawing) {
        drawingElement.rebuildPath(coordinateSystem);
      }
    }

    state = state.copyWith(elements: listOfElements);
  }

  void clearAll() {
    state = DrawingState(elements: []);
    _triggerRepaint();
  }
}

//Yes I used AI to write the algo. I promise you I understand how it works

FreeDrawing douglasPeucker(FreeDrawing drawing, double epsilon) {
  if (drawing.listOfPoints.length < 3) {
    return drawing;
  }

  FreeDrawing newDrawing = FreeDrawing(listOfPoints: [...drawing.listOfPoints]);
  final listOfPoints = newDrawing.listOfPoints;
  // Find the point farthest from the line between the first and last points
  double maxDistance = 0;
  int index = 0;

  for (int i = 1; i < listOfPoints.length - 1; i++) {
    double distance = perpendicularDistance(
        listOfPoints[i], listOfPoints.first, listOfPoints.last);
    if (distance > maxDistance) {
      maxDistance = distance;
      index = i;
    }
  }

  // If the max distance is greater than epsilon, recursively simplify
  if (maxDistance > epsilon) {
    // final leftDrawing = newDrawing.copyWith(listOfPoints: listOfPoints.sublist(0, index + 1));

    final leftDrawing = douglasPeucker(
        newDrawing.copyWith(listOfPoints: listOfPoints.sublist(0, index + 1)),
        epsilon);
    final rightDrawing = douglasPeucker(
        newDrawing.copyWith(
            listOfPoints: listOfPoints.sublist(index, listOfPoints.length)),
        epsilon);

    // Combine the results, removing the duplicate point at the split
    newDrawing.listOfPoints = [
      ...leftDrawing.listOfPoints,
      ...rightDrawing.listOfPoints.sublist(1)
    ];
    return newDrawing;
  } else {
    // If no point is far enough, return the endpoints
    newDrawing.listOfPoints = [listOfPoints.first, listOfPoints.last];

    return newDrawing;
  }
}

double perpendicularDistance(Offset point, Offset lineStart, Offset lineEnd) {
  double dx = lineEnd.dx - lineStart.dx;
  double dy = lineEnd.dy - lineStart.dy;

  if (dx == 0 && dy == 0) {
    // Line start and end are the same point
    return sqrt(
        pow(point.dx - lineStart.dx, 2) + pow(point.dy - lineStart.dy, 2));
  }

  double numerator = (dy * point.dx -
          dx * point.dy +
          lineEnd.dx * lineStart.dy -
          lineEnd.dy * lineStart.dx)
      .abs();
  double denominator = sqrt(dx * dx + dy * dy);

  return numerator / denominator;
}

List<Offset> pathSmoothing(List<Offset> points) {
  final List<Offset> smoothPoints = [];
  if (points.length < 2) {
    return points;
  }

  for (int i = 0; i < points.length - 1; i++) {
    final p0 = points[i];

    final p1 = points[1 + i];

    final q = Offset(
      0.75 * p0.dx + 0.25 * p1.dx,
      0.75 * p0.dy + 0.25 * p1.dy,
    );
    final r = Offset(
      0.25 * p0.dx + 0.75 * p1.dx,
      0.25 * p0.dy + 0.75 * p1.dy,
    );

    smoothPoints.add(q);
    smoothPoints.add(r);
  }
  return smoothPoints;
}
