import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:developer' as dev;

class InteractiveMap extends StatefulWidget {
  const InteractiveMap({super.key});

  @override
  State<InteractiveMap> createState() => _InteractiveMapState();

  void screenToCoordinate() {}
}

class _InteractiveMapState extends State<InteractiveMap> {
  String assetName = 'assets/maps/ascent_map.svg';

  TransformationController transformationController =
      TransformationController();

  @override
  Widget build(BuildContext context) {
    late final CoordinateSystem coordinateSystem;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height -
        60.0; // -60 adjusts for app bar height. I'm not sure if app bar will be included so this would be modified accordingly
    Size playAreaSize = Size(height * 1.24, height);
    coordinateSystem = CoordinateSystem(playAreaSize: playAreaSize);

    return InteractiveViewer(
      scaleEnabled: true,
      transformationController: transformationController,
      child: GestureDetector(
        onTapDown: (details) {
          dev.log("${details.localPosition}");

          coordinateSystem.screenToCoordinate(
              details.localPosition, transformationController);
        },
        child: Container(
          width: playAreaSize.width,
          height: height,
          color: const Color(0xFF1B1B1B),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              assetName,
              semanticsLabel: 'Map',
              height: width,
              width: width,
            ),
          ),
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
  void screenToCoordinate(
      Offset screenPoint, TransformationController transformController) {
    // Get current scale from transformation matrix

    // Normalize coordinates
    double normalizedX = screenPoint.dx / playAreaSize.width;
    double normalizedY = screenPoint.dy / playAreaSize.height;

    dev.log(
        "Normalized X ${normalizedX * 1000} \n Normalized Y ${normalizedY * 1000}");
  }
}
