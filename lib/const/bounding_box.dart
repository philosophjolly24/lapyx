import 'dart:ui';

class BoundingBox {
  final Offset min;
  final Offset max;

  BoundingBox({required this.min, required this.max});

  bool isWithin(Offset position) {
    if (position.dx >= min.dx &&
        position.dx <= max.dx &&
        position.dy >= min.dy &&
        position.dy <= max.dy) {
      return true;
    }
    return false;
  }

  @override
  String toString() {
    return 'BoundingBox(min: $min, max: $max)';
  }
}
