import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InteractiveMap extends StatefulWidget {
  const InteractiveMap({super.key});

  @override
  State<InteractiveMap> createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap> {
  String assetName = 'assets/maps/ascent_map.svg';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - 60.0;

    double mapSize = width - 60;

    return InteractiveViewer(
      scaleEnabled: true,
      child: Container(
        width: height * 1.24,
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
    );
  }
}
