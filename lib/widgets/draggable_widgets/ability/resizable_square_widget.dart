import 'package:flutter/widgets.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/widgets/draggable_widgets/ability/ability_widget.dart';

class ResizableSquareWidget extends StatelessWidget {
  const ResizableSquareWidget(
      {super.key,
      required this.color,
      required this.width,
      required this.maxLength,
      required this.minLength,
      required this.iconPath,
      required this.distanceBetweenAOE,
      required this.length,
      this.id,
      required this.isAlly,
      required this.origin});
  final Color color;
  final double width;
  final double maxLength;
  final double minLength;
  final String iconPath;
  final double distanceBetweenAOE;
  final double length;
  final String? id;
  final bool isAlly;
  final Offset origin;

  @override
  Widget build(BuildContext context) {
    final coordinateSystem = CoordinateSystem.instance;

    final scaledWidth = coordinateSystem.scale(width);
    final scaledBoxHeight = coordinateSystem.scale(maxLength);

    final scaledDistance = coordinateSystem.scale((distanceBetweenAOE));
    final scaledAbilitySize = coordinateSystem.scale(Settings.abilitySize);

    //The 7.5 is to account for the size of the resize button
    final resizeButtonOffset = coordinateSystem.scale(7.5);

    final totalHeight = scaledBoxHeight +
        scaledDistance +
        scaledAbilitySize +
        resizeButtonOffset;

    final double scaledLength;
    if (length < minLength) {
      scaledLength = coordinateSystem.scale(minLength);
    } else if (length > maxLength) {
      scaledLength = coordinateSystem.scale(maxLength);
    } else {
      scaledLength = coordinateSystem.scale(length);
    }

    return SizedBox(
      height: totalHeight,
      width: scaledWidth,
      child: Stack(
        children: [
          const Positioned.fill(
            child: IgnorePointer(
              child: SizedBox(),
            ),
          ),
          Positioned(
            bottom: scaledDistance + scaledAbilitySize,
            child: IgnorePointer(
              child: Container(
                height: scaledLength,
                width: scaledWidth,
                decoration: BoxDecoration(color: color.withAlpha(100)),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: (scaledWidth - scaledAbilitySize) / 2,
            child: AbilityWidget(
              iconPath: iconPath,
              id: null,
              isAlly: isAlly,
            ),
          ),
        ],
      ),
    );
  }
}
