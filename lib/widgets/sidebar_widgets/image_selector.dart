import 'dart:async';
import 'dart:typed_data' show Uint8List;
import 'dart:ui' as ui;
import 'package:icarus/const/placed_classes.dart';
import 'package:path/path.dart' as path;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/image_provider.dart';
import 'package:uuid/uuid.dart';

class ImageSelector extends ConsumerStatefulWidget {
  const ImageSelector({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ImageSelectorState();
}

class _ImageSelectorState extends ConsumerState<ImageSelector> {
  String? fileExtension;
  Uint8List? imageData;

  Future<double> getImageAspectRatio(Uint8List imageData) async {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(
      imageData,
      (ui.Image img) {
        completer.complete(img);
      },
    );
    final ui.Image image = await completer.future;
    return image.width / image.height;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      title: const Text("Choose Image"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(3)),
            child: InkWell(
              onTap: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  type: FileType.custom,
                  allowedExtensions: ["png", "jpg", "gif", "webp"],
                );

                if (result == null) return;
                final data = result.files.first.xFile;
                final String newExtension = path.extension(data.path);

                final Uint8List newImage = await data.readAsBytes();

                setState(() {
                  imageData = newImage;
                  fileExtension = newExtension;
                });
              },
              child: (imageData == null)
                  ? Container(
                      height: 200,
                      width: 200,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 20, 20, 20),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            size: 40,
                          ),
                          Text("Click to add new image"),
                        ],
                      ),
                    )
                  : Image.memory(
                      imageData!,
                      width: 200,
                      height: 200,
                    ),
            ),
          )
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'), // Explicit "Cancel"
          onPressed: () {
            // ref.read(placedImageProvider.notifier).clearCurrentImage();
            Navigator.of(context).pop(); // Just close the dialog
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () async {
            if (imageData == null) {
              Navigator.of(context).pop(); // Just close the dialog
              return;
            }

            final imageID = const Uuid().v4();
            final imageBytes = imageData!;
            final fileExtension = this.fileExtension!;

            await ref
                .read(placedImageProvider.notifier)
                .saveSecureImage(imageBytes, imageID, fileExtension);

            final image = PlacedImage(
              fileExtension: fileExtension,
              position: const Offset(500, 500),
              id: imageID,
              aspectRatio: await getImageAspectRatio(imageBytes),
              scale: 200,
            );

            ref.read(placedImageProvider.notifier).addImage(image);

            if (!context.mounted) return;
            Navigator.of(context).pop(); // Just close the dialog
          },
        ),
      ],
    );
  }
}
