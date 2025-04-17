import 'dart:async' show Completer;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/custom_icons.dart';
import 'package:icarus/const/placed_classes.dart';
import 'package:icarus/providers/drawing_provider.dart';
import 'package:icarus/providers/image_provider.dart';
import 'package:icarus/providers/interaction_state_provider.dart';
import 'package:icarus/providers/text_provider.dart';
import 'package:icarus/widgets/drawing_tools.dart';
import 'package:uuid/uuid.dart';

class ToolGrid extends ConsumerWidget {
  const ToolGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentInteractionState = ref.watch(interactionStateProvider);

    void showImageDialog() {
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

      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 27, 27, 27),
            title: const Text("Choose Image"),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ImageSelector(),
                // SizedBox(child: TextField()),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'), // Explicit "Cancel"
                onPressed: () {
                  ref.read(placedImageProvider.notifier).clearCurrentImage();
                  Navigator.of(context).pop(); // Just close the dialog
                },
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () async {
                  if (ref.read(placedImageProvider).currentImage == null) {
                    Navigator.of(context).pop(); // Just close the dialog
                    return;
                  }
                  const uuid = Uuid();
                  final imageBytes =
                      ref.read(placedImageProvider).currentImage!;

                  final image = PlacedImage(
                    position: const Offset(500, 500),
                    id: uuid.v4(),
                    aspectRatio: await getImageAspectRatio(imageBytes),
                    scale: 200,
                    image: imageBytes,
                  );

                  ref.read(placedImageProvider.notifier).addImage(image);

                  ref.read(placedImageProvider.notifier).clearCurrentImage();

                  if (!context.mounted) return;
                  Navigator.of(context).pop(); // Just close the dialog
                },
              ),
            ],
          );
        },
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: const Text(
          "Tools",
          style: TextStyle(fontSize: 20),
        ),
        initiallyExpanded: true,
        children: [
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 5,
            children: [
              IconButton(
                onPressed: () {
                  switch (currentInteractionState) {
                    case InteractionState.drawing:
                      ref
                          .read(interactionStateProvider.notifier)
                          .update(InteractionState.navigation);
                    default:
                      ref
                          .read(interactionStateProvider.notifier)
                          .update(InteractionState.drawing);
                  }
                },
                icon: const Icon(Icons.draw),
                isSelected: currentInteractionState == InteractionState.drawing,
              ),
              IconButton(
                onPressed: () {
                  switch (currentInteractionState) {
                    case InteractionState.erasing:
                      ref
                          .read(interactionStateProvider.notifier)
                          .update(InteractionState.navigation);
                    default:
                      ref
                          .read(interactionStateProvider.notifier)
                          .update(InteractionState.erasing);
                  }
                },
                icon: const Icon(
                  CustomIcons.eraser,
                  size: 20,
                ),
                isSelected: currentInteractionState == InteractionState.erasing,
              ),
              IconButton(
                onPressed: () {
                  ref.read(drawingProvider.notifier).clearAll();
                },
                icon: const Icon(Icons.delete),
              ),
              IconButton(
                onPressed: () {
                  ref
                      .read(interactionStateProvider.notifier)
                      .update(InteractionState.navigation);
                  const uuid = Uuid();
                  ref.read(textProvider.notifier).addText(
                        PlacedText(
                          position: const Offset(500, 500),
                          id: uuid.v4(),
                        ),
                      );
                },
                icon: const Icon(Icons.text_fields),
              ),
              IconButton(
                onPressed: () {
                  ref
                      .read(interactionStateProvider.notifier)
                      .update(InteractionState.navigation);

                  showImageDialog();
                },
                icon: const Icon(Icons.image_outlined),
              )
            ],
          ),
          const DrawingTools()
        ],
      ),
    );
  }
}

class ImageSelector extends ConsumerWidget {
  const ImageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
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
          final Uint8List newImage = await data.readAsBytes();

          ref.read(placedImageProvider.notifier).changeCurrentImage(newImage);
        },
        child: (ref.watch(placedImageProvider).currentImage == null)
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
                ref.watch(placedImageProvider).currentImage!,
                width: 200,
                height: 200,
              ),
      ),
    );
  }
}
