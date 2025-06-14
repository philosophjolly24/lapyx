// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/maps.dart';
import 'package:icarus/providers/ability_bar_provider.dart';

import 'package:icarus/providers/map_provider.dart';
import 'package:icarus/providers/screen_zoom_provider.dart';
import 'package:icarus/widgets/dot_painter.dart';

import 'package:icarus/widgets/drawing_painter.dart';
import 'package:icarus/widgets/draggable_widgets/placed_widget_builder.dart';

class InteractiveMap extends ConsumerStatefulWidget {
  const InteractiveMap({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InteractiveMapState();
}

class _InteractiveMapState extends ConsumerState<InteractiveMap> {
  final controller = TransformationController();
  @override
  Widget build(BuildContext context) {
    log(MediaQuery.sizeOf(context).height.toString());

    String assetName =
        'assets/maps/${Maps.mapNames[ref.watch(mapProvider).currentMap]}_map.svg';
    final double height = MediaQuery.sizeOf(context).height - 90;
    final Size playAreaSize = Size(height * 1.2, height);
    CoordinateSystem(playAreaSize: playAreaSize);
    CoordinateSystem coordinateSystem = CoordinateSystem.instance;

    const centerX = 1240 / 2;
    const centerY = 1000 / 2;
    final flipTransform = Matrix4.identity()
      ..translate(centerX, centerY)
      ..scale(-1.0, -1.0)
      ..translate(-centerX, -centerY);
    return Row(
      children: [
        Container(
          width: coordinateSystem.playAreaSize.width,
          height: coordinateSystem.playAreaSize.height,
          color: const Color(0xFF1B1B1B),
          child: InteractiveViewer(
            transformationController: controller,
            onInteractionEnd: (details) {
              ref
                  .read(screenZoomProvider.notifier)
                  .updateZoom(controller.value.getMaxScaleOnAxis());
            },
            child: Stack(
              children: [
                //Dot Grid
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      ref.read(abilityBarProvider.notifier).updateData(null);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: DotGrid(),
                    ),
                  ),
                ),

                // // Map SVG
                // Positioned.fill(
                //   child: GestureDetector(
                //     behavior: HitTestBehavior.translucent,
                //     onTap: () {
                //       ref.read(abilityBarProvider.notifier).updateData(null);
                //     },
                //     child: SvgPicture.asset(

                //       assetName,
                //       semanticsLabel: 'Map',
                //       fit: BoxFit.contain,
                //     ),
                //   ),
                // ),
                // Map SVG
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      ref.read(abilityBarProvider.notifier).updateData(null);
                    },
                    child: Transform(
                      alignment: Alignment.center,
                      transform: (ref.watch(mapProvider).isAttack)
                          ? Matrix4.identity()
                          : Matrix4.diagonal3Values(-1, -1, 1),
                      child: SvgPicture.asset(
                        assetName,
                        semanticsLabel: 'Map',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                //Agents
                Positioned.fill(
                  child: PlacedWidgetBuilder(),
                ),

                //Painting
                Positioned.fill(
                  child: InteractivePainter(),
                ),
                // TODO: Later
                // Positioned.fill(
                //   child: MouseRegion(
                //     onHover: (event) {
                //       // if(ref.watch(interactionStateProvider).)
                //     },
                //   ),
                // )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
