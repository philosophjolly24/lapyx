import 'package:flutter/material.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/coordinate_system.dart';

class CustomCircleWidget extends StatelessWidget {
  const CustomCircleWidget({super.key, required this.coordinateSystem, required this.customCircleAbility});

  final CoordinateSystem coordinateSystem;
  final AbilityInfo customCircleAbility;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  static Widget Function(CoordinateSystem, AbilityInfo) customCircleAbility(
      double size, Color outlineColor, bool hasCenterDot, bool isDouble,
      [int? opactiy, double? secondarySize, Color? secondaryColor]) {
    return (CoordinateSystem coordinateSystem, AbilityInfo abilityInfo) {
      double scaleSize =
          coordinateSystem.scale(size) - coordinateSystem.scale(5);
      double secondaryScaleSize = coordinateSystem.scale(secondarySize ?? 5) -
          coordinateSystem.scale(5);

      abilityInfo.updateCenterPoint(Offset(scaleSize / 2, scaleSize / 2));
      if (hasCenterDot) {
        return !isDouble
            ? Stack(
                children: [
                  IgnorePointer(
                    child: Container(
                      width: scaleSize,
                      height: scaleSize,
                      decoration: BoxDecoration(
                        color: outlineColor.withAlpha(opactiy ?? 70),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: outlineColor,
                            width: coordinateSystem.scale(5)),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,

                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3)),
                        child: Container(
                          width: coordinateSystem.scale(25),
                          height: coordinateSystem.scale(25),
                          padding: EdgeInsets.all(coordinateSystem.scale(3)),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1B1B1B),
                          ),
                          child: Image.asset(
                            abilityInfo.iconPath,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      // child: Container(
                      //   width: 9,
                      //   height: 9,
                      //   decoration: const BoxDecoration(
                      //     color: Colors.white,
                      //     shape: BoxShape.circle,
                      //   ),
                      // ),
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
                  IgnorePointer(
                    child: Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: IgnorePointer(
                          child: Container(
                            width: secondaryScaleSize,
                            height: secondaryScaleSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: secondaryColor!.withAlpha(opactiy ?? 70),
                              border: Border.all(
                                color: secondaryColor,
                                width: coordinateSystem.scale(5),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3)),
                        child: Container(
                          width: coordinateSystem.scale(25),
                          height: coordinateSystem.scale(25),
                          padding: EdgeInsets.all(coordinateSystem.scale(3)),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1B1B1B),
                          ),
                          child: Image.asset(
                            abilityInfo.iconPath,
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
            color: outlineColor.withAlpha(opactiy ?? 70),
            shape: BoxShape.circle,
            border: Border.all(
                color: outlineColor, width: coordinateSystem.scale(5))),
      );
    };
  }
}