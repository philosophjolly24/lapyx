import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/drawing_element.dart';

class DrawingState {
  final List<DrawingElement> elements;
  final int updateCounter; // Keep this!

  DrawingState({
    required this.elements,
    this.updateCounter = 0,
  });

  DrawingState copyWith({
    List<DrawingElement>? elements,
    int? updateCounter,
    int? indexOfCurrentEdit,
  }) {
    return DrawingState(
      elements: elements ?? this.elements,
      updateCounter: updateCounter ?? this.updateCounter,
    );
  }
}

final drawingProvider =
    NotifierProvider<DrawingProvider, DrawingState>(DrawingProvider.new);

class DrawingProvider extends Notifier<DrawingState> {
  int _indexOfCurrentEdit = -1;
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
    state = state.copyWith(updateCounter: (state.updateCounter + 1) % 3);
  }

  void startFreeDrawing(Offset start, CoordinateSystem coordinateSystem) {
    if (_indexOfCurrentEdit > 0) {
      log("An error occured the gesture detecture is attempting to draw while another line is active");
      return;
    }

    FreeDrawing freeDrawing = FreeDrawing();

    freeDrawing.path.moveTo(start.dx, start.dy);

    freeDrawing.listOfPoints.add(coordinateSystem.screenToCoordinate(start));

    state = state.copyWith(elements: [...state.elements, freeDrawing]);

    _indexOfCurrentEdit = state.elements.length - 1;
    _triggerRepaint();
  }

  void updateFreeDrawing(Offset offset, CoordinateSystem coordinateSystem) {
    final listOfElements = state.elements;
    List<Offset> currentFreeDrawing =
        (listOfElements[_indexOfCurrentEdit] as FreeDrawing).listOfPoints;
    Offset lastPoint = currentFreeDrawing[currentFreeDrawing.length - 1];

    final minDistance = coordinateSystem.scale(3);
    if ((lastPoint - offset).distance < minDistance) return;

    (listOfElements[_indexOfCurrentEdit] as FreeDrawing)
        .path
        .lineTo(offset.dx, offset.dy);
    (listOfElements[_indexOfCurrentEdit] as FreeDrawing)
        .listOfPoints
        .add(coordinateSystem.screenToCoordinate(offset));

    state = state.copyWith(elements: listOfElements);
    _triggerRepaint();
  }

  void finishFreeDrawing(Offset offset, CoordinateSystem coordinateSystem) {
    final listOfElements = state.elements;

    (listOfElements[_indexOfCurrentEdit] as FreeDrawing)
        .path
        .lineTo(offset.dx, offset.dy);
    (listOfElements[_indexOfCurrentEdit] as FreeDrawing)
        .listOfPoints
        .add(coordinateSystem.screenToCoordinate(offset));
    (listOfElements[_indexOfCurrentEdit] as FreeDrawing)
        .rebuildPath(coordinateSystem);

    _indexOfCurrentEdit = -1;
    state = state.copyWith(elements: listOfElements);
    _triggerRepaint();
  }

  void startLine(Offset start) {
    final listOfElements = state.elements;

    if (_indexOfCurrentEdit > 0) {
      log("An error occured the gesture detecture is attempting to draw while another line is active");
      return;
    }
    Line newLine = Line(null, lineStart: start, lineEnd: start);
    listOfElements.add(newLine);

    state = state.copyWith(elements: listOfElements);
    _indexOfCurrentEdit = listOfElements.length - 1;
    _triggerRepaint();
  }

  void updateCurrentLine(Offset endpoint) {
    final listOfElements = state.elements;
    (listOfElements[_indexOfCurrentEdit] as Line).updateEndPoint(endpoint);

    state = state.copyWith(elements: listOfElements);
    _triggerRepaint();
  }

  void finishCurrentLine(Offset endpoint) {
    final listOfElements = state.elements;

    (listOfElements[_indexOfCurrentEdit] as Line).updateEndPoint(endpoint);
    _indexOfCurrentEdit = -1;

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
    state = state.copyWith(elements: []);
    _triggerRepaint();
  }
}
