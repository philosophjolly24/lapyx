import 'package:flutter/widgets.dart';
import 'package:icarus/const/coordinate_system.dart';

class RotatableImageWidget extends StatelessWidget {
  const RotatableImageWidget(
      {super.key,
      required this.imagePath,
      required this.height,
      required this.width});
  final String imagePath;
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    final coordinateSystem = CoordinateSystem.instance;

    return Column(
      children: [
        SizedBox(
          height: coordinateSystem.scale(30),
        ),
        SizedBox(
          width: coordinateSystem.scale(width),
          height: coordinateSystem.scale(height),
          child: Image.asset(imagePath),
        ),
      ],
    );
  }
}
