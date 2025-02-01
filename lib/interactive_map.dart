// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/widgets/dot_painter.dart';

import 'package:icarus/widgets/drawing_painter.dart';
import 'package:icarus/widgets/placed_agent_builder.dart';

class InteractiveMap extends StatefulWidget {
  const InteractiveMap({super.key});

  @override
  State<InteractiveMap> createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap> {
  String assetName = 'assets/maps/ascent_map.svg';

  @override
  Widget build(BuildContext context) {
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
                const Positioned.fill(
                    child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: DotGrid(),
                )),
                Positioned.fill(
                  child: SvgPicture.asset(
                    assetName,
                    semanticsLabel: 'Map',
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned.fill(
                  child: InteractivePainter(),
                ),
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
