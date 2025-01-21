import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icarus/widgets/ability/agent_widget.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/widgets/dot_painter.dart';
import 'dart:developer' as dev;

import 'package:icarus/widgets/drawing_painter.dart';
import 'package:icarus/providers/ability_provider.dart';
import 'package:icarus/providers/agent_provider.dart';
import 'package:icarus/widgets/placed_ability_widget.dart';
import 'package:icarus/widgets/placed_agent_builder.dart';
import 'package:provider/provider.dart';

class InteractiveMap extends StatefulWidget {
  const InteractiveMap({super.key});

  @override
  State<InteractiveMap> createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap> {
  String assetName = 'assets/maps/ascent_map.svg';

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height - kToolbarHeight;
    final Size playAreaSize = Size(height * 1.2, height);

    final coordinateSystem = CoordinateSystem(playAreaSize: playAreaSize);

    return Row(
      children: [
        Container(
          width: playAreaSize.width,
          height: height,
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
                //TODO: Remove play area size parameter, not needed.
                Positioned.fill(
                  child: InteractivePainter(playAreaSize: playAreaSize),
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
