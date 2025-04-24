import 'dart:developer';
import 'dart:typed_data' show Uint8List;
import 'package:path/path.dart' as path;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/image_provider.dart';
import 'package:icarus/widgets/sidebar_widgets/tool_grid.dart';

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
          final String extenstion = path.extension(data.path);

          final Uint8List newImage = await data.readAsBytes();

          ref
              .read(placedImageProvider.notifier)
              .changeCurrentImage(newImage, extenstion);
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
