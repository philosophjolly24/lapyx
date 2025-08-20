import 'package:flutter/material.dart';

abstract class Utilities {
  Offset getAnchorPoint();
  Widget createWidget(String? id, [double? rotation, double? length]);
}

class ImageUtility extends Utilities {
  final String imagePath;
  final double size;

  ImageUtility({required this.imagePath, required this.size});

  @override
  Widget createWidget(String? id, [double? rotation, double? length]) {
    return Image.asset(
      imagePath,
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }

  @override
  Offset getAnchorPoint() {
    return Offset(size / 2, size / 2);
  }
}
