import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/providers/ability_provider.dart';
import 'package:icarus/widgets/mouse_watch.dart';

class CustomCircleWidget extends ConsumerWidget {
  const CustomCircleWidget({
    super.key,
    required this.iconPath,
    required this.size,
    required this.outlineColor,
    required this.hasCenterDot,
    required this.hasPerimeter,
    this.opacity = 70,
    this.innerSize = 2,
    this.fillColor,
    required this.id,
    required this.isAlly,
  });

  final bool isAlly;
  final String? id;
  final String iconPath;
  final double size;
  final Color outlineColor;
  final bool hasCenterDot;
  final bool hasPerimeter;
  final int? opacity;
  final double? innerSize;
  final Color? fillColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coordinateSystem = CoordinateSystem.instance;
    final scaleSize = coordinateSystem.scale(size) - coordinateSystem.scale(5);
    final secondaryScaleSize =
        coordinateSystem.scale(innerSize ?? 2) - coordinateSystem.scale(2);

    // If no center dot is needed, return a simple circle
    if (!hasCenterDot) {
      return _buildSimpleCircle(coordinateSystem, scaleSize);
    }

    // With center dot, build appropriate stack based on perimeter setting
    return Stack(
      children: [
        // Outer circle/perimeter
        _buildOuterCircle(coordinateSystem, scaleSize, hasPerimeter),

        // Inner circle (only when has perimeter)
        if (hasPerimeter)
          _buildInnerCircle(coordinateSystem, secondaryScaleSize),

        // Icon in center
        _buildCenterIcon(coordinateSystem, ref),

        Container(
          width: 4,
          height: 4,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildSimpleCircle(
      CoordinateSystem coordinateSystem, double scaleSize) {
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

  Widget _buildOuterCircle(
      CoordinateSystem coordinateSystem, double scaleSize, bool hasPerimeter) {
    return IgnorePointer(
      child: Container(
        width: scaleSize,
        height: scaleSize,
        decoration: BoxDecoration(
          color: hasPerimeter ? null : outlineColor.withAlpha(opacity ?? 70),
          shape: BoxShape.circle,
          border: Border.all(
            color: hasPerimeter ? outlineColor.withAlpha(100) : outlineColor,
            width: coordinateSystem.scale(2),
          ),
        ),
      ),
    );
  }

  Widget _buildInnerCircle(
      CoordinateSystem coordinateSystem, double secondaryScaleSize) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Align(
          alignment: Alignment.center,
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
    );
  }

  Widget _buildCenterIcon(CoordinateSystem coordinateSystem, WidgetRef ref) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: MouseWatch(
          onDeleteKeyPressed: () {
            if (id == null) return;
            ref.watch(abilityProvider.notifier).removeAbility(id!);
          },
          child: Container(
            width: coordinateSystem.scale(25),
            height: coordinateSystem.scale(25),
            padding: EdgeInsets.all(coordinateSystem.scale(3)),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(3),
              ),
              color: const Color(0xFF1B1B1B),
              border: Border.all(
                color: isAlly
                    ? const Color.fromARGB(106, 105, 240, 175)
                    : const Color.fromARGB(139, 255, 82, 82),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              child: Image.asset(
                iconPath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
