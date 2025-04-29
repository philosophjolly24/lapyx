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
import 'package:uuid/uuid.dart';

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

  Future<String> toJson(String strategyID) async {
    // Asynchronously convert each image using the custom serializer.
    final List<Map<String, dynamic>> jsonList = await Future.wait(
      state.images
          .map((image) => PlacedImageSerializer.toJson(image, strategyID)),
    );

    return jsonEncode(jsonList);
  }

  Future<void> fromJson(String jsonString) async {
    final List<dynamic> jsonList = jsonDecode(jsonString);

    // Use the custom deserializer for each JSON map.
    final images = await Future.wait(
      jsonList.map((json) =>
          PlacedImageSerializer.fromJson(json as Map<String, dynamic>)),
    );

    state = state.copyWith(images: images);
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

/// A helper class to handle the asynchronous conversion of [PlacedImage].
///
/// Note: Because reading bytes from disk and writing them back is an
/// asynchronous operation, these methods should be called outside the
/// synchronous `toJson`/`fromJson` normally generated by [json_serializable].
class PlacedImageSerializer {
  /// Serializes a [PlacedImage] into a JSON map.
  ///
  /// The [strategyID] is required here to determine the parent folder
  /// where the image is stored.
  static Future<Map<String, dynamic>> toJson(
    PlacedImage image,
    String strategyID,
  ) async {
    // Compute the final file path.
    final filePath = await _computeFilePath(image, strategyID);

    // Read the image file as bytes.
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('Image file does not exist at $filePath');
    }
    final Uint8List fileBytes = await file.readAsBytes();

    // Use your custom serializer for Uint8List.
    final serializedBytes = serializeUint8List(fileBytes);

    // Get the basic JSON from the code-generated method.
    final Map<String, dynamic> json = image.toJson();

    // Add the image bytes into the JSON.
    json['imageBytes'] = serializedBytes;

    // Optionally update the object's link.
    image.updateLink(filePath);

    return json;
  }

  /// Deserializes a JSON map back into a [PlacedImage].
  ///
  /// A new strategy ID is generated for the file location using [Uuid].
  static Future<PlacedImage> fromJson(
    Map<String, dynamic> json,
  ) async {
    // Use your code-generated deserializer for basic fields.
    final placedImage = PlacedImage.fromJson(json);

    // Generate a new strategy ID for storing this image.
    final String strategyID = const Uuid().v4();

    // Retrieve and deserialize the image bytes.
    if (!json.containsKey('imageBytes')) {
      throw Exception('JSON does not contain imageBytes.');
    }
    final serializedBytes = json['imageBytes'];
    final Uint8List imageBytes = deserializeUint8List(serializedBytes);

    // Compute the final file path to write the image.
    final filePath = await _computeFilePath(placedImage, strategyID);

    // Ensure the target directory exists.
    final file = File(filePath);
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }

    // Write the image bytes to disk.
    await file.writeAsBytes(imageBytes);

    // Update the link on the instance.
    placedImage.updateLink(filePath);

    return placedImage;
  }

  /// Computes the file path where the image should be stored.
  ///
  /// It uses the application support directory, creates a custom folder based
  /// on [strategyID] and an `images` subfolder, and forms the filename from the
  /// image's [id] and [fileExtension].
  static Future<String> _computeFilePath(
      PlacedImage image, String strategyID) async {
    // Get the system's application support directory.
    final Directory appSupportDir = await getApplicationSupportDirectory();

    // Create the custom directory using the strategy ID.
    final Directory customDirectory =
        Directory(path.join(appSupportDir.path, strategyID));
    if (!await customDirectory.exists()) {
      await customDirectory.create(recursive: true);
    }

    // Create the images subfolder.
    final Directory imagesDirectory =
        Directory(path.join(customDirectory.path, 'images'));
    if (!await imagesDirectory.exists()) {
      await imagesDirectory.create(recursive: true);
    }

    // The final file path: [id][fileExtension]
    return path.join(imagesDirectory.path, '${image.id}${image.fileExtension}');
  }
}

/// Dummy custom serializer for Uint8List.
/// Replace these with your actual implementations.
dynamic serializeUint8List(Uint8List data) {
  // For example, convert to a Base64 string.
  return base64Encode(data);
}

Uint8List deserializeUint8List(dynamic jsonData) {
  // For example, convert the Base64 string back into a Uint8List.
  if (jsonData is String) {
    return Uint8List.fromList(base64Decode(jsonData));
  }
  throw Exception('Invalid data for Uint8List deserialization.');
}
