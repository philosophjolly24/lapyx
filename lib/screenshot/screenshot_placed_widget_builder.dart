import 'package:flutter/widgets.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/placed_classes.dart';
import 'package:icarus/providers/strategy_settings_provider.dart';
import 'package:icarus/widgets/draggable_widgets/agents/agent_widget.dart';

class ScreenshotPlacedWidgetBuilder extends StatelessWidget {
  const ScreenshotPlacedWidgetBuilder(
      {super.key,
      required this.agents,
      required this.abilities,
      required this.text,
      required this.images,
      required this.mapScale,
      required this.strategySettings,
      required this.utilities});
  final List<PlacedAgent> agents;
  final List<PlacedAbility> abilities;
  final List<PlacedText> text;
  final List<PlacedImage> images;
  final List<PlacedUtility> utilities;
  final double mapScale;
  final StrategySettings strategySettings;
  @override
  Widget build(BuildContext context) {
    final coordinateSystem = CoordinateSystem.instance;
    // final mapScale = Maps.mapScale[ref.watch(mapProvider).currentMap];

    // final agentSize = ref.watch(strategySettingsProvider).agentSize;
    // final abilitySize = ref.watch(strategySettingsProvider).abilitySize;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            for (PlacedAbility ability in abilities)
              PlacedAbilityWidget(
                rotation: ability.rotation,
                data: ability,
                ability: ability,
                id: ability.id,
                length: ability.length,
                onDragEnd: (details) {},
              ),
            for (PlacedAgent agent in agents)
              Positioned(
                left: coordinateSystem.coordinateToScreen(agent.position).dx,
                top: coordinateSystem.coordinateToScreen(agent.position).dy,
                child: AgentWidget(
                  isAlly: agent.isAlly,
                  id: "",
                  agent: AgentData.agents[agent.type]!,
                ),
              ),
            for (PlacedText placedText in text)
              Positioned(
                left:
                    coordinateSystem.coordinateToScreen(placedText.position).dx,
                top:
                    coordinateSystem.coordinateToScreen(placedText.position).dy,
                child: PlacedTextBuilder(
                  size: placedText.size,
                  placedText: placedText,
                  onDragEnd: (details) {},
                ),
              ),
            for (PlacedImage placedImage in images)
              Positioned(
                  left: coordinateSystem
                      .coordinateToScreen(placedImage.position)
                      .dx,
                  top: coordinateSystem
                      .coordinateToScreen(placedImage.position)
                      .dy,
                  child: PlacedImageBuilder(
                    placedImage: placedImage,
                    scale: placedImage.scale,
                    onDragEnd: (details) {},
                  )),
            for (PlacedUtility placedUtility in utilities)
              Positioned(
                left: coordinateSystem
                    .coordinateToScreen(placedUtility.position)
                    .dx,
                top: coordinateSystem
                    .coordinateToScreen(placedUtility.position)
                    .dy,
                child: UtilityWidgetBuilder(
                  rotation: placedUtility.rotation,
                  length: placedUtility.length,
                  utility: placedUtility,
                  id: placedUtility.id,
                  onDragEnd: (details) {},
                ),
              ),
          ],
        );
      },
    );
  }
}
