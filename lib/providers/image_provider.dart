import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/action_provider.dart';
import 'package:icarus/const/placed_classes.dart';
import 'package:icarus/providers/strategy_provider.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

final placedImageProvider =
    NotifierProvider<ImageProvider, ImageState>(ImageProvider.new);

class ImageState {
  ImageState(
      {required this.images,
      required this.currentImage,
      required this.imageExtenstion});

  final List<PlacedImage> images;
  final Uint8List? currentImage;
  final String? imageExtenstion;

  ImageState copyWith({
    List<PlacedImage>? images,
    Uint8List? currentImage,
    String? imageExtenstion,
  }) {
    return ImageState(
      images: images ?? this.images,
      currentImage: currentImage ?? this.currentImage,
      imageExtenstion: imageExtenstion ?? this.imageExtenstion,
    );
  }
}

class ImageProvider extends Notifier<ImageState> {
  List<PlacedImage> poppedImages = [];

  @override
  ImageState build() {
    return ImageState(
      images: [],
      currentImage: null,
      imageExtenstion: null,
    );
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

  void changeCurrentImage(Uint8List newImage, String fileExtension) {
    state =
        state.copyWith(currentImage: newImage, imageExtenstion: fileExtension);
  }

  void clearCurrentImage() {
    state = ImageState(
        images: [...state.images], currentImage: null, imageExtenstion: null);
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

  Future<void> saveSecureImage(
    Uint8List imageBytes,
    String imageID,
    String fileExtenstion,
  ) async {
    final strategyID = ref.watch(strategyProvider).id;
    // Get the system's application support directory.
    final directory = await getApplicationSupportDirectory();

    // Create a custom directory inside the application support directory.

    final customDirectory = Directory(path.join(directory.path, strategyID));

    if (!await customDirectory.exists()) {
      await customDirectory.create(recursive: true);
    }

    // Now create the full file path.
    final filePath = path.join(
      customDirectory.path,
      'images',
      '$imageID$fileExtenstion',
    );

    log(filePath);
    // Ensure the images subdirectory exists.
    final imagesDir = Directory(path.join(customDirectory.path, 'images'));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    // Write the file.
    final file = File(filePath);
    await file.writeAsBytes(imageBytes);
  }

  void fromHive(List<PlacedImage> hiveImages) {
    poppedImages = [];
    state = state.copyWith(images: hiveImages);
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
