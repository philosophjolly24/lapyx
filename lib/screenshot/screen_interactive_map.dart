import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/drawing_element.dart';
import 'package:icarus/const/maps.dart';
import 'package:icarus/const/placed_classes.dart';
import 'package:icarus/providers/strategy_settings_provider.dart';
import 'package:icarus/screenshot/screenshot_placed_widget_builder.dart';
import 'package:icarus/widgets/dot_painter.dart';

class ScreenShotInteractiveMap extends StatelessWidget {
  const ScreenShotInteractiveMap({
    super.key,
    required this.mapValue,
    required this.agents,
    required this.abilities,
    required this.text,
    required this.items,
    required this.drawings,
    required this.utilities,
    required this.strategySettings,
    required this.isAttack,
  });
  final MapValue mapValue;
  final List<PlacedAgent> agents;
  final List<PlacedAbility> abilities;
  final List<PlacedText> text;
  final List<PlacedImage> items;
  final List<DrawingElement> drawings;
  final List<PlacedUtility> utilities;
  final StrategySettings strategySettings;
  final bool isAttack;
  @override
  Widget build(BuildContext context) {
    String assetName =
        'assets/maps/${Maps.mapNames[mapValue]}_map${isAttack ? "" : "_defense"}.svg';
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
                assetName,
                semanticsLabel: 'Map',
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned.fill(
            child: ScreenshotPlacedWidgetBuilder(
              agents: agents,
              abilities: abilities,
              text: text,
              images: items,
              mapScale: Maps.mapScale[mapValue]!,
              strategySettings: strategySettings,
              utilities: utilities,
            ),
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
