import 'package:flutter/widgets.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/widgets/draggable_widgets/ability/ability_widget.dart';

class CenterSquareWidget extends StatelessWidget {
  const CenterSquareWidget(
      {super.key,
      required this.width,
      required this.height,
      required this.iconPath,
      required this.color,
      this.rotation,
      required this.origin,
      required this.id,
      required this.isAlly});
  final double width;
  final double height;
  final String iconPath;
  final Color color;
  final double? rotation;
  final Offset origin;
  final String? id;
  final bool isAlly;

  @override
  Widget build(BuildContext context) {
    final coordinateSystem = CoordinateSystem.instance;

    final totalWidth = coordinateSystem.scale(Settings.abilitySize);
    final scaledWidth = coordinateSystem.scale(width);
    final scaledHeight = coordinateSystem.scale(height);
    return SizedBox(
      width: totalWidth,
      height: scaledHeight,
      child: Stack(
        children: [
          Positioned(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: scaledWidth,
                height: scaledHeight,
                decoration: BoxDecoration(
                  color: color.withAlpha(150),
                ),
              ),
            ),
          ),
          Positioned(
            child: Align(
              alignment: Alignment.center,
              child: AbilityWidget(
                iconPath: iconPath,
                id: null,
                isAlly: isAlly,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
