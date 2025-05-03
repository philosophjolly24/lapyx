import 'package:flutter/material.dart';

class CoordinateSystem {
  // System parameters

  CoordinateSystem._({required Size playAreaSize})
      : _playAreaSize = playAreaSize;

  final Size _playAreaSize;
  Size get playAreaSize => _playAreaSize;

  static CoordinateSystem? _instance;

  // The normalized coordinate space will maintain this aspect ratio
  final double normalizedHeight = 1000.0;
  late final double normalizedWidth = normalizedHeight * 1.24;

  factory CoordinateSystem({required Size playAreaSize}) {
    _instance = CoordinateSystem._(playAreaSize: playAreaSize);
    return _instance!;
  }

  static CoordinateSystem get instance {
    if (_instance == null) {
      throw StateError(
          "CoordinateSystem must be initialized with playAreaSize first");
    }
    return _instance!;
  }

  Offset screenToCoordinate(Offset screenPoint) {
    // Convert screen points to the normalized space while maintaining aspect ratio
    double normalizedX =
        (screenPoint.dx / _playAreaSize.width) * normalizedWidth;
    double normalizedY =
        (screenPoint.dy / _playAreaSize.height) * normalizedHeight;

    return Offset(normalizedX, normalizedY);
  }

  Offset coordinateToScreen(Offset coordinates) {
    // Convert from normalized space back to screen space while maintaining aspect ratio
    double screenX =
        (coordinates.dx / normalizedWidth) * (_playAreaSize.width - (34 * 1.2));
    double screenY =
        (coordinates.dy / normalizedHeight) * (_playAreaSize.height - 34);

    return Offset(screenX, screenY);
  }

  final double _baseHeight = 831.0;
  // Get the scale factor based on screen height
  double get _scaleFactor => _playAreaSize.height / _baseHeight;

  double get scaleFactor => _scaleFactor;
  // Scale any dimension based on height
  double scale(double size) => size * _scaleFactor;

  // Scale a size maintaining aspect ratio
  Size scaleSize(Size size) => Size(
        size.width * _scaleFactor,
        size.height * _scaleFactor,
      );

  // Convenience method to wrap a widget with scaled dimensions
  Widget scaleWidget({
    required Widget child,
    required Size originalSize,
  }) {
    Size scaledSize = scaleSize(originalSize);
    return SizedBox(
      width: scaledSize.width,
      height: scaledSize.height,
      child: child,
    );
  }

  bool isOutOfBounds(Offset offset) {
    const int tolerance = 10;
    return offset.dx > normalizedWidth - tolerance ||
        offset.dy > normalizedHeight - tolerance ||
        offset.dx < 0 + tolerance ||
        offset.dy < 0 + tolerance;
  }
}
