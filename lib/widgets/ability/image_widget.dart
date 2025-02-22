import 'package:flutter/material.dart';
import 'package:icarus/const/coordinate_system.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key, required this.imagePath, required this.size});
  final double size;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final coordinateSystem = CoordinateSystem.instance;

    return SizedBox(
      width: coordinateSystem.scale(size),
      height: coordinateSystem.scale(size),
      child: Image.asset(imagePath),
    );
  }
}
