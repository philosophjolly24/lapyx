import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/action_provider.dart';
import 'package:icarus/const/placed_classes.dart';

final placedImageProvider =
    NotifierProvider<ImageProvider, ImageState>(ImageProvider.new);

class ImageState {
  ImageState({required this.images, required this.currentImage});

  final List<PlacedImage> images;
  final Uint8List? currentImage;

  ImageState copyWith({
    List<PlacedImage>? images,
    Uint8List? currentImage,
  }) {
    return ImageState(
      images: images ?? this.images,
      currentImage: currentImage ?? this.currentImage,
    );
  }
}

class ImageProvider extends Notifier<ImageState> {
  List<PlacedImage> poppedImages = [];

  @override
  ImageState build() {
    return ImageState(images: [], currentImage: null);
  }

  void addImage(PlacedImage placedImage) {
    final action = UserAction(
      type: ActionType.addition,
      id: placedImage.id,
      group: ActionGroup.image,
    );

    ref.read(actionProvider.notifier).addAction(action);
    state = state.copyWith(images: [...state.images, placedImage]);
  }

  void removeImage(String id) {
    final newImages = [...state.images];
    final index = PlacedWidget.getIndexByID(id, newImages);

    if (index < 0) return;
    final image = newImages.removeAt(index);
    poppedImages.add(image);

    state = state.copyWith(images: newImages);
  }

  void updatePosition(Offset position, String id) {
    final newImages = [...state.images];
    final index = PlacedWidget.getIndexByID(id, newImages);

    if (index < 0) return;
    newImages[index].updatePosition(position);

    final temp = newImages.removeAt(index);

    final action = UserAction(
      type: ActionType.edit,
      id: id,
      group: ActionGroup.image,
    );
    ref.read(actionProvider.notifier).addAction(action);

    state = state.copyWith(images: [...newImages, temp]);
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
        final newImages = [...state.images];
        newImages.add(poppedImages.removeLast());
        state = state.copyWith(images: newImages);
      case ActionType.edit:
        undoPosition(action.id);
    }
  }

  void undoPosition(String id) {
    final newImages = [...state.images];
    final index = PlacedWidget.getIndexByID(id, newImages);

    if (index < 0) return;
    newImages[index].undoAction();

    state = state.copyWith(images: newImages);
  }

  void redoAction(UserAction action) {
    final newImages = [...state.images];

    try {
      switch (action.type) {
        case ActionType.addition:
          final index = PlacedWidget.getIndexByID(action.id, poppedImages);
          newImages.add(poppedImages.removeAt(index));

        case ActionType.deletion:
          final index = PlacedWidget.getIndexByID(action.id, poppedImages);
          poppedImages.add(newImages.removeAt(index));

        case ActionType.edit:
          final index = PlacedWidget.getIndexByID(action.id, newImages);
          newImages[index].redoAction();
      }
    } catch (_) {
      log("Failed to find index");
    }
    state = state.copyWith(images: newImages);
  }

  void changeCurrentImage(Uint8List newImage) {
    state = state.copyWith(currentImage: newImage);
  }

  void clearCurrentImage() {
    state = ImageState(images: [...state.images], currentImage: null);
  }

  String toJson() {
    final List<Map<String, dynamic>> jsonList =
        state.images.map((image) => image.toJson()).toList();
    return jsonEncode(jsonList);
  }

  void fromJson(String jsonString) {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    state = state.copyWith(
        images: jsonList
            .map((json) => PlacedImage.fromJson(json as Map<String, dynamic>))
            .toList());
  }

  void updateScale(int index, double scale) {
    final newState = state.copyWith();

    newState.images[index].scale = scale;

    state = newState;
  }

  // @override
  // String toString() {
  //   String output = "[";

  //   for (PlacedImage image in state) {
  //     output += ", ";
  //   }

  //   output += "]";

  //   return output;
  // }
}
