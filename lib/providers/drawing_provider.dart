import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:icarus/DrawingElement.dart';

class DrawingProvider extends ChangeNotifier {
  bool isDrawing = false;
  int updateCounter = 0;
  int indexOfCurrentEdit = -1;
  List<DrawingElement> listOfElements = [
    Line(null,
        lineStart: const Offset(300, 300), lineEnd: const Offset(300, 900))
  ];
  Offset? lineStart;
  Offset? currentEndPoint;

  int getNextUpdate() {
    updateCounter = (updateCounter + 1) % 3;
    notifyListeners();
    return updateCounter;
  }

  void startLine(Offset start) {
    if (indexOfCurrentEdit > 0) {
      log("An error occured the gesture detecture is attempting to draw a ling that doesn't exist");
      return;
    }
    Line newLine = Line(null, lineStart: start, lineEnd: start);

    listOfElements.add(newLine);
    indexOfCurrentEdit = listOfElements.length - 1;

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
}
