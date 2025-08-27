import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/drawing_element.dart';
import 'package:icarus/const/placed_classes.dart';
import 'package:icarus/providers/strategy_settings_provider.dart';
import 'package:icarus/widgets/dot_painter.dart';

class ScreenShotInteractiveMap extends StatelessWidget {
  const ScreenShotInteractiveMap(
      {super.key,
      required this.mapAssetName,
      required this.agents,
      required this.abilities,
      required this.text,
      required this.items,
      required this.drawings});
  final String mapAssetName;
  final List<PlacedAgent> agents;
  final List<PlacedAbility> abilities;
  final List<PlacedText> text;
  final List<PlacedImage> items;
  final List<DrawingElement> drawings;
  final StrategySettings strategySettings;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: CoordinateSystem.screenShotSize.width,
      height: CoordinateSystem.screenShotSize.height,
      color: const Color(0xFF1B1B1B),
      child: Stack(
        children: [
          const Positioned.fill(
            child: DotGrid(),
          ),
          // Map SVG
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: SvgPicture.asset(
                mapAssetName,
                semanticsLabel: 'Map',
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned.fill(
            child: PlacedWidgetBuilder(),
          ),

          //Painting
          Positioned.fill(
            child: InteractivePainter(),
          ),
        ],
      ),
    );
  }
}
