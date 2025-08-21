import 'package:flutter/material.dart';
import 'package:icarus/widgets/draggable_widgets/utilities/image_utility_widget.dart';

enum UtilityType {
  spike,
}

class UtilityData {
  final UtilityType type;

  UtilityData({required this.type});

  static Map<UtilityType, Utilities> utilityWidgets = {
    UtilityType.spike: ImageUtility(imagePath: 'assets/spike.svg', size: 20),
  };
}

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
    return ImageUtilityWidget(imagePath: imagePath, size: size, id: id);
  }

  @override
  Offset getAnchorPoint() {
    return Offset(size / 2, size / 2);
  }
}
