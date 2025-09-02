import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/strategy_provider.dart';
import 'package:path/path.dart' as path;

class ImageWidget extends ConsumerWidget {
  const ImageWidget({
    super.key,
    required this.link,
    required this.aspectRatio,
    required this.scale,
    required this.fileExtension,
    required this.id,
  });
  final double aspectRatio;
  final String? link;
  final double scale;
  final String? fileExtension;
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log(scale.toString());
    final file = File(path.join(
      ref.watch(strategyProvider).storageDirectory!,
      'images',
      '$id$fileExtension',
    ));

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: scale),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // The grey container on left
            Container(
              width: 10,
              decoration: BoxDecoration(
                color: const Color(0xFFC5C5C5),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 2),
            Flexible(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                margin: EdgeInsets.zero,
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 20, 20, 20),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: (file.existsSync() && fileExtension != null)
                          ? Image.file(
                              file,
                              fit: BoxFit.cover,
                            )
                          : const Placeholder(),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
