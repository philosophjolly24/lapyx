import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:developer' as dev;

import 'package:icarus/drawing_painter.dart';

class InteractiveMap extends StatefulWidget {
  const InteractiveMap({super.key});

  @override
  State<InteractiveMap> createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap> {
  String assetName = 'assets/maps/ascent_map.svg';

  TransformationController transformationController =
      TransformationController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height -
        60.0; // -60 adjusts for app bar height. I'm not sure if app bar will be included so this would be modified accordingly
    Size playAreaSize = Size(height * 1.24, height);

    return InteractiveViewer(
      scaleEnabled: true,
      transformationController: transformationController,
      child: Container(
        width: playAreaSize.width,
        height: height,
        color: const Color(0xFF1B1B1B),
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 55.0, top: 8),
                child: SvgPicture.asset(
                  assetName,
                  semanticsLabel: 'Map',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned.fill(
              child: InteractivePainter(playAreaSize: playAreaSize),
            ),
          ],
        ),
      ),
    );
  }
}

class CoordinateSystem {
  // System parameters

  final Size playAreaSize;

  CoordinateSystem({required this.playAreaSize});

  // Methods
  Offset screenToCoordinate(Offset screenPoint) {
    // Get current scale from transformation matrix

    // Normalize coordinates
    double normalizedX = (screenPoint.dx / playAreaSize.width) * 1000;
    double normalizedY = (screenPoint.dy / playAreaSize.height) * 1000;
    // dev.log("Normalized X $normalizedX \n Normalized Y $normalizedY");
    return Offset(normalizedX, normalizedY);
  }

  Offset coordinateToScreen(Offset coordinates) {
    double screenX = (coordinates.dx / 1000) * playAreaSize.width;
    double screenY = (coordinates.dy / 1000) * playAreaSize.height;

    // dev.log("Raw X $screenX \n Raw Y $screenY");
    return Offset(screenX, screenY);
  }
}
