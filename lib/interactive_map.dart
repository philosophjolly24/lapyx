// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/maps.dart';
import 'package:icarus/providers/map_provider.dart';
import 'package:icarus/widgets/delete_area.dart';
import 'package:icarus/widgets/dot_painter.dart';

import 'package:icarus/widgets/drawing_painter.dart';
import 'package:icarus/widgets/placed_widget_builder.dart';

class InteractiveMap extends ConsumerStatefulWidget {
  const InteractiveMap({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InteractiveMapState();
}

class _InteractiveMapState extends ConsumerState<InteractiveMap> {
  @override
  Widget build(BuildContext context) {
    String assetName =
        'assets/maps/${Maps.maps[ref.watch(mapProvider)]}_map.svg';

    final double height = MediaQuery.sizeOf(context).height - kToolbarHeight;
    final Size playAreaSize = Size(height * 1.2, height);
    CoordinateSystem(playAreaSize: playAreaSize);
    CoordinateSystem coordinateSystem = CoordinateSystem.instance;

    return Row(
      children: [
        Container(
          width: coordinateSystem.playAreaSize.width,
          height: coordinateSystem.playAreaSize.height,
          color: const Color(0xFF1B1B1B),
          child: InteractiveViewer(
            child: Stack(
              children: [
                //Dot Grid
                const Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: DotGrid(),
                  ),
                ),

                // Map SVG
                Positioned.fill(
                  child: SvgPicture.asset(
                    assetName,
                    semanticsLabel: 'Map',
                    fit: BoxFit.contain,
                  ),
                ),

                //Painting
                Positioned.fill(
                  child: InteractivePainter(),
                ),

                //Delete widget
                Align(
                  alignment: Alignment.topRight,
                  child: DeleteArea(),
                ),

                //Agents
                Positioned.fill(
                  child: PlacedWidgetBuilder(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
