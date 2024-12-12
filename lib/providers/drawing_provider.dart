import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:icarus/DrawingElement.dart';
import 'package:icarus/interactive_map.dart';

enum InteractionState {
  navigation,
  drawLine,
  drawFreeLine,
}

class DrawingProvider extends ChangeNotifier {
  InteractionState interactionState = InteractionState.navigation;
  bool isDrawing = false;
  int updateCounter = 0;
  int indexOfCurrentEdit = -1;
  List<DrawingElement> listOfElements = [
    // Line(null,
    //     lineStart: const Offset(300, 300), lineEnd: const Offset(300, 900))
  ];

  Offset? lineStart;
  Offset? currentEndPoint;

  int getNextUpdate() {
    updateCounter = (updateCounter + 1) % 3;
    notifyListeners();
    return updateCounter;
  }

  void updateInteractionState(InteractionState interactionState) {
    this.interactionState = interactionState;
    notifyListeners();
  }

  void startLine(Offset start) {
    if (indexOfCurrentEdit > 0) {
      log("An error occured the gesture detecture is attempting to draw while another line is active");
      return;
    }
    Line newLine = Line(null, lineStart: start, lineEnd: start);

    listOfElements.add(newLine);
    indexOfCurrentEdit = listOfElements.length - 1;

    getNextUpdate();
  }

  void startFreeDrawing(Offset start, CoordinateSystem coordinateSystem) {
    if (indexOfCurrentEdit > 0) {
      log("An error occured the gesture detecture is attempting to draw while another line is active");
      return;
    }

    FreeDrawing freeDrawing = FreeDrawing();

    freeDrawing.path.moveTo(start.dx, start.dy);

    freeDrawing.listOfPoints.add(coordinateSystem.screenToCoordinate(start));

    listOfElements.add(freeDrawing);
    indexOfCurrentEdit = listOfElements.length - 1;

    getNextUpdate();
  }

  void updateFreeDrawing(Offset offset, CoordinateSystem coordinateSystem) {
    List<Offset> currentFreeDrawing =
        (listOfElements[indexOfCurrentEdit] as FreeDrawing).listOfPoints;
    Offset lastPoint = currentFreeDrawing[currentFreeDrawing.length - 1];
    if (((lastPoint - offset).distance) < 2) return;

    (listOfElements[indexOfCurrentEdit] as FreeDrawing)
        .path
        .lineTo(offset.dx, offset.dy);
    (listOfElements[indexOfCurrentEdit] as FreeDrawing)
        .listOfPoints
        .add(coordinateSystem.screenToCoordinate(offset));
    getNextUpdate();
  }

  void finishFreeDrawing(Offset offset, CoordinateSystem coordinateSystem) {
    (listOfElements[indexOfCurrentEdit] as FreeDrawing)
        .path
        .lineTo(offset.dx, offset.dy);
    (listOfElements[indexOfCurrentEdit] as FreeDrawing)
        .listOfPoints
        .add(coordinateSystem.screenToCoordinate(offset));
    (listOfElements[indexOfCurrentEdit] as FreeDrawing)
        .rebuildPath(coordinateSystem);

    indexOfCurrentEdit = -1;
    getNextUpdate();
  }

  void updateCurrentLine(Offset endpoint) {
    (listOfElements[indexOfCurrentEdit] as Line).updateEndPoint(endpoint);

    getNextUpdate();
  }

  void finishCurrentLine(Offset endpoint) {
    (listOfElements[indexOfCurrentEdit] as Line).updateEndPoint(endpoint);
    indexOfCurrentEdit = -1;
    getNextUpdate();
  }

  void rebuildAllPaths(CoordinateSystem coordinateSystem) {
    for (DrawingElement drawingElement in listOfElements) {
      if (drawingElement is FreeDrawing) {
        drawingElement.rebuildPath(coordinateSystem);
      }
    }
  }

  void clearAll() {
    listOfElements = [];
    getNextUpdate();
  }
}
