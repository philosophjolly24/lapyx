import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageUtilityWidget extends ConsumerWidget {
  const ImageUtilityWidget({
    super.key,
    required this.imagePath,
    required this.size,
  });
  final String imagePath;
  final double size;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(imagePath),
    );
  }
}
