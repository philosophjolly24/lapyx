import 'dart:async' show Completer;
import 'dart:convert' show ascii;
import 'dart:developer';
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
import 'package:icarus/providers/strategy_provider.dart';
import 'package:icarus/providers/text_provider.dart';
import 'package:icarus/widgets/sidebar_widgets/drawing_tools.dart';
import 'package:icarus/widgets/sidebar_widgets/image_selector.dart';
import 'package:path/path.dart' as path;
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

                  final imageID = const Uuid().v4();
                  final imageBytes =
                      ref.read(placedImageProvider).currentImage!;
                  final fileExtension =
                      ref.read(placedImageProvider).imageExtenstion!;

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
