import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/providers/ability_provider.dart';
import 'package:icarus/widgets/mouse_watch.dart';

class CustomSquareWidget extends ConsumerWidget {
  const CustomSquareWidget({
    super.key,
    required this.color,
    required this.width,
    required this.height,
    this.distanceBetweenAOE,
    this.rotation,
    required this.iconPath,
    required this.origin,
    required this.id,
    required this.isAlly,
  });

  final String? id;
  final Color color;
  final double width;
  final double height;
  final String iconPath;
  final Offset origin;
  final double? distanceBetweenAOE;
  final double? rotation;
  final bool isAlly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coordinateSystem = CoordinateSystem.instance;
    final scaledWidth = coordinateSystem.scale(width);
    final scaledHeight = coordinateSystem.scale(height);
    final scaledDistance = coordinateSystem.scale(distanceBetweenAOE ?? 0);
    final scaledAbilitySize = coordinateSystem.scale(Settings.abilitySize);
    final totalHeight = scaledHeight + scaledDistance + scaledAbilitySize;

    return SizedBox(
      width: scaledWidth,
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main square
          Positioned(
            top: 0,
            left: 0,
            child: IgnorePointer(
              child: Container(
                width: scaledWidth,
                height: scaledHeight,
                color: color.withAlpha(100),
              ),
            ),
          ),
          // Ability icon
          Positioned(
            bottom: 0,
            left: (scaledWidth - scaledAbilitySize) / 2,
            child: MouseWatch(
              onDeleteKeyPressed: () {
                if (id == null) return;

                ref.read(abilityProvider.notifier).removeAbility(id!);
              },
              child: Container(
                width: scaledAbilitySize,
                height: scaledAbilitySize,
                padding: EdgeInsets.all(coordinateSystem.scale(3)),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isAlly
                        ? const Color.fromARGB(106, 105, 240, 175)
                        : const Color.fromARGB(139, 255, 82, 82),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(3)),
                  color: const Color(0xFF1B1B1B),
                ),
                child: Image.asset(
                  iconPath,
                  fit: BoxFit.contain,
                ),
              ),
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
