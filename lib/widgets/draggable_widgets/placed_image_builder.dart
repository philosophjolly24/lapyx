import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/placed_classes.dart';
import 'package:icarus/providers/image_provider.dart';

import 'package:icarus/providers/screen_zoom_provider.dart';
import 'package:icarus/widgets/draggable_widgets/image/image_widget.dart';
import 'package:icarus/widgets/draggable_widgets/scalable_widget.dart';
import 'package:icarus/widgets/draggable_widgets/zoom_transform.dart';

class PlacedImageBuilder extends ConsumerStatefulWidget {
  const PlacedImageBuilder({
    required this.placedImage,
    required this.onDragEnd,
    super.key,
  });

  final PlacedImage placedImage;
  final Function(DraggableDetails details) onDragEnd;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PlacedImageBuilderState();
}

class _PlacedImageBuilderState extends ConsumerState<PlacedImageBuilder> {
  double? localScale; // Make localScale nullable to check if it's initialized

  @override
  void initState() {
    super.initState();
    // Only initialize localScale if it hasn't been initialized yet
    localScale ??= widget.placedImage.scale;
  }

  // Optionally define min and max scale values
  static const double minScale = 200;
  static const double maxScale = 800;
  @override
  Widget build(BuildContext context) {
    if (localScale == null) {
      return const SizedBox
          .shrink(); // Or a loading indicator, or some other placeholder
    }
    return ScalableWidget(
      onPanUpdate: (details) {
        setState(() {
          localScale = details.delta.dx + localScale!;
          if (localScale! < minScale) localScale = minScale;
          if (localScale! > maxScale) localScale = maxScale;
        });
      },
      onPanEnd: (details) {
        final index = PlacedWidget.getIndexByID(
          widget.placedImage.id,
          ref.read(placedImageProvider).images,
        );
        ref.read(placedImageProvider.notifier).updateScale(index, localScale!);
      },
      child: Draggable<PlacedWidget>(
        data: widget.placedImage,
        feedback: ZoomTransform(
          child: IgnorePointer(
            child: ImageWidget(
              link: widget.placedImage.link,
              aspectRatio: widget.placedImage.aspectRatio,
              scale: localScale!,
              fileExtension: widget.placedImage.fileExtension,
              id: widget.placedImage.id,
            ),
          ),
        ),
        childWhenDragging: const SizedBox.shrink(),
        dragAnchorStrategy:
            ref.read(screenZoomProvider.notifier).zoomDragAnchorStrategy,
        onDragEnd: widget.onDragEnd,
        child: ImageWidget(
          fileExtension: widget.placedImage.fileExtension,
          aspectRatio: widget.placedImage.aspectRatio,
          link: widget.placedImage.link,
          scale: localScale!,
          id: widget.placedImage.id,
        ),
      ),
    );
  }
}
