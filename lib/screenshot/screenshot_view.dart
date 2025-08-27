import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/maps.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/providers/map_provider.dart';
import 'package:icarus/widgets/dot_painter.dart';
import 'package:icarus/widgets/draggable_widgets/placed_widget_builder.dart';
import 'package:icarus/widgets/drawing_painter.dart';

class ScreenshotView extends ConsumerWidget {
  const ScreenshotView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isAttack = ref.watch(mapProvider).isAttack;

    String assetName =
        'assets/maps/${Maps.mapNames[ref.watch(mapProvider).currentMap]}_map${isAttack ? "" : "_defense"}.svg';
    return Container(
      color: const Color(0xFF1B1B1B),
      height: CoordinateSystem.screenShotSize.height,
      width: CoordinateSystem.screenShotSize.width,
      child: Stack(
        children: [
          const DotGrid(isScreenshot: true),

          Positioned.fill(
            child: SvgPicture.asset(
              assetName,
              semanticsLabel: 'Map',
              fit: BoxFit.contain,
            ),
          ),

          const Positioned.fill(
            child: PlacedWidgetBuilder(),
          ),

          //Painting
          const Positioned.fill(
            child: InteractivePainter(),
          ),
          // Add any other widgets you want to include in the screenshot
        ],
      ),
    );
  }
}
