import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/widgets/custom_border_container.dart';
import 'package:icarus/widgets/draggable_widgets/ability/ability_widget.dart';

class CustomSquareWidget extends ConsumerWidget {
  const CustomSquareWidget({
    super.key,
    required this.color,
    required this.width,
    required this.height,
    required this.distanceBetweenAOE,
    this.rotation,
    required this.iconPath,
    required this.origin,
    required this.id,
    required this.isAlly,
    required this.hasTopborder,
    required this.hasSideBorders,
    required this.isWall,
    required this.isTransparent,
  });

  final String? id;
  final Color color;
  final double width;
  final double height;
  final String iconPath;
  final Offset origin;
  final double distanceBetweenAOE;
  final double? rotation;
  final bool isAlly;
  final bool hasTopborder;
  final bool hasSideBorders;
  final bool isWall;
  final bool isTransparent;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coordinateSystem = CoordinateSystem.instance;

    final double scaledWidth;

    if (isWall) {
      scaledWidth = coordinateSystem.scale(Settings.abilitySize * 2);
    } else {
      scaledWidth = coordinateSystem.scale(width);
    }
    final resizeButtonOffset = coordinateSystem.scale(7.5);

    final scaledHeight = coordinateSystem.scale(height);
    final scaledDistance = coordinateSystem.scale((distanceBetweenAOE));
    final scaledAbilitySize = coordinateSystem.scale(Settings.abilitySize);
    final totalHeight =
        scaledHeight + scaledDistance + scaledAbilitySize + resizeButtonOffset;

    return SizedBox(
      width: scaledWidth,
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main square

          isWall //This is here because there's a certain size needed to prevent input clipping issues
              ? Positioned(
                  top: 0,
                  left: 0,
                  child: IgnorePointer(
                    child: Container(
                      width: scaledWidth,
                      height: totalHeight,
                      color: Colors.transparent,
                    ),
                  ),
                )
              : Positioned(
                  top: resizeButtonOffset,
                  left: 0,
                  child: IgnorePointer(
                      child: CustomBorderContainer(
                    color: color,
                    width: scaledWidth,
                    height: scaledHeight,
                    hasTop: hasTopborder,
                    hasSide: hasSideBorders,
                    isTransparent: isTransparent,
                  )

                      // Container(
                      //   width: scaledWidth,
                      //   height: scaledHeight,
                      //   decoration: BoxDecoration(
                      //       color: (hasSideBorders)
                      //           ? Colors.transparent
                      //           : color.withAlpha(100),
                      //       border: Border(
                      //         top: BorderSide(
                      //           color: color.withAlpha(200),
                      //           width: 3,
                      //           style: hasTopborder
                      //               ? BorderStyle.solid
                      //               : BorderStyle.none,
                      //         ),
                      //         left: BorderSide(
                      //           color: color.withAlpha(100),
                      //           width: 3,
                      //           style: hasSideBorders
                      //               ? BorderStyle.solid
                      //               : BorderStyle.none,
                      //         ),
                      //         right: BorderSide(
                      //           color: color.withAlpha(100),
                      //           width: 3,
                      //           style: hasSideBorders
                      //               ? BorderStyle.solid
                      //               : BorderStyle.none,
                      //         ),
                      //       )),
                      // ),
                      ),
                ),

          if (isWall)
            Positioned(
              top: resizeButtonOffset,
              left: (scaledWidth / 2) - width / 2,
              child: IgnorePointer(
                child: Container(
                  width: width,
                  height: scaledHeight,
                  color: color.withAlpha(100),
                ),
              ),
            ),
          // Ability icon
          Positioned(
            bottom: 0,
            left: (scaledWidth / 2) - (scaledAbilitySize / 2),
            child: AbilityWidget(
              iconPath: iconPath,
              id: null,
              isAlly: isAlly,
            ),
          ),
          // Debug point to visualize rotation origin
          // if (false) // Set to true to debug
          //   Positioned(
          //     left: rotationOrigin.dx - 2,
          //     top: rotationOrigin.dy - 2,
          //     child: Container(
          //       width: 4,
          //       height: 4,
          //       color: Colors.red,
          //     ),
          //   ),
        ],
      ),
    );
  }
}
