import 'package:flutter/material.dart';
import 'package:icarus/const/coordinate_system.dart';

class DotGrid extends StatelessWidget {
  const DotGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: DotPainter());
  }
}

class DotPainter extends CustomPainter {
  final playAreaSize = CoordinateSystem.instance.playAreaSize;
  static const double dotSize = 2.0; // Size of each dot
  static const double dotSpacing = 15;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromRGBO(210, 214, 219, 0.1)
      ..style = PaintingStyle.fill;
    int rows = (size.height / dotSpacing).floor();
    int columns = (size.width / dotSpacing).floor();

    for (int row = 0; row < rows; row++) {
      for (int column = 0; column < columns; column++) {
        double x = column * dotSpacing;
        double y = row * dotSpacing;

        canvas.drawCircle(Offset(x, y), dotSize / 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DotPainter oldDelegate) {
    if (oldDelegate.playAreaSize != playAreaSize) {
      return true;
    }
    return false;
  }
}
