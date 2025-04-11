import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/action_provider.dart';
import 'package:icarus/const/placed_classes.dart';

final imageProvider =
    NotifierProvider<ImageNotifier, List<PlacedImage>>(ImageNotifier.new);

class ImageNotifier extends Notifier<List<PlacedImage>> {
  List<PlacedImage> poppedImages = [];

  @override
  List<PlacedImage> build() {
    return [];
  }

  void addImage(PlacedImage placedImage) {
    final action = UserAction(
      type: ActionType.addition,
      id: placedImage.id,
      group: ActionGroup.image,
    );

    ref.read(actionProvider.notifier).addAction(action);
    state = [...state, placedImage];
  }

  void removeImage(String id) {
    final newState = [...state];

    final index = PlacedWidget.getIndexByID(id, newState);

    if (index < 0) return;
    final image = newState.removeAt(index);
    poppedImages.add(image);

    state = newState;
  }

  void updatePosition(Offset position, String id) {
    final newState = [...state];

    final index = PlacedWidget.getIndexByID(id, newState);

    if (index < 0) return;
    newState[index].updatePosition(position);

    final temp = newState.removeAt(index);

    final action =
        UserAction(type: ActionType.edit, id: id, group: ActionGroup.image);
    ref.read(actionProvider.notifier).addAction(action);

    state = [...newState, temp];
  }

  void undoAction(UserAction action) {
    log("Attempting to undo image action");

    switch (action.type) {
      case ActionType.addition:
        removeImage(action.id);
      case ActionType.deletion:
        if (poppedImages.isEmpty) {
          log("Popped images is empty");
          return;
        }
        final newState = [...state];
        newState.add(poppedImages.removeLast());
        state = newState;
      case ActionType.edit:
        undoPosition(action.id);
    }
  }

  void undoPosition(String id) {
    final newState = [...state];

    final index = PlacedWidget.getIndexByID(id, newState);
    if (index < 0) return;

    newState[index].undoAction();

    state = newState;
  }

  void redoAction(UserAction action) {
    final newState = [...state];

    try {
      switch (action.type) {
        case ActionType.addition:
          final index = PlacedWidget.getIndexByID(action.id, poppedImages);
          newState.add(poppedImages.removeAt(index));

        case ActionType.deletion:
          final index = PlacedWidget.getIndexByID(action.id, poppedImages);
          poppedImages.add(newState.removeAt(index));

        case ActionType.edit:
          final index = PlacedWidget.getIndexByID(action.id, newState);
          newState[index].redoAction();
      }
    } catch (_) {
      log("Failed to find index");
    }
    state = newState;
  }

  String toJson() {
    final List<Map<String, dynamic>> jsonList =
        state.map((image) => image.toJson()).toList();
    return jsonEncode(jsonList);
  }

  // void fromJson(String jsonString) {
  //   final List<dynamic> jsonList = jsonDecode(jsonString);
  //   state = jsonList
  //       .map((json) => PlacedImage.fromJson(json as Map<String, dynamic>))
  //       .toList();
  // }

  // @override
  // String toString() {
  //   String output = "[";

  //   for (PlacedImage image in state) {
  //     output += "Path: ${image.path}, Position: ${image.position}, ";
  //   }

  //   output += "]";

  //   return output;
  // }
}
