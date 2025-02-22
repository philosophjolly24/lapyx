import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:icarus/const/coordinate_system.dart';

class CustomCircleWidget extends StatelessWidget {
  const CustomCircleWidget({
    super.key,
    required this.iconPath,
    required this.size,
    required this.outlineColor,
    required this.hasCenterDot,
    required this.hasPerimeter,
    this.opacity,
    this.innerSize,
    this.fillColor,
  });

  final String iconPath;
  final double size;
  final Color outlineColor;

  final bool hasCenterDot;
  final bool hasPerimeter;
  final int? opacity;
  final double? innerSize;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    final CoordinateSystem coordinateSystem = CoordinateSystem.instance;
    double scaleSize = coordinateSystem.scale(size) - coordinateSystem.scale(5);
    log(innerSize.toString());
    double secondaryScaleSize =
        coordinateSystem.scale(innerSize ?? 2) - coordinateSystem.scale(2);
    log(secondaryScaleSize.toString());
    // abilityInfo.updateCenterPoint(Offset(scaleSize / 2, scaleSize / 2));
    if (hasCenterDot) {
      return !hasPerimeter
          ? Stack(
              children: [
                IgnorePointer(
                  child: Container(
                    width: scaleSize,
                    height: scaleSize,
                    decoration: BoxDecoration(
                      color: outlineColor.withAlpha(opacity ?? 70),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: outlineColor,
                        width: coordinateSystem.scale(5),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(3)),
                      child: Container(
                        width: coordinateSystem.scale(25),
                        height: coordinateSystem.scale(25),
                        padding: EdgeInsets.all(coordinateSystem.scale(3)),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1B1B1B),
                        ),
                        child: Image.asset(
                          iconPath,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                IgnorePointer(
                  child: Container(
                    width: scaleSize,
                    height: scaleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: outlineColor,
                          width: coordinateSystem.scale(5)),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: Align(
                      alignment: Alignment.center,
                      child: IgnorePointer(
                        child: Container(
                          width: secondaryScaleSize,
                          height: secondaryScaleSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: fillColor!.withAlpha(opacity ?? 70),
                            border: Border.all(
                              color: fillColor!,
                              width: coordinateSystem.scale(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(3)),
                      child: Container(
                        width: coordinateSystem.scale(25),
                        height: coordinateSystem.scale(25),
                        padding: EdgeInsets.all(coordinateSystem.scale(3)),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1B1B1B),
                        ),
                        child: Image.asset(
                          iconPath,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
    }

    return Container(
      width: scaleSize,
      height: scaleSize,
      decoration: BoxDecoration(
        color: outlineColor.withAlpha(opacity ?? 70),
        shape: BoxShape.circle,
        border: Border.all(
          color: outlineColor,
          width: coordinateSystem.scale(5),
        ),
      ),
    );
  }
}
