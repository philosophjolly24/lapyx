import 'package:flutter/widgets.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/widgets/draggable_widgets/agents/agent_widget.dart';

class ScreenshotPlacedWidgetBuilder extends StatelessWidget {
  const ScreenshotPlacedWidgetBuilder({super.key});

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
            for (PlacedAbility ability in ref.watch(abilityProvider))
              PlacedAbilityWidget(
                rotation: ability.rotation,
                data: ability,
                ability: ability,
                id: ability.id,
                length: ability.length,
                onDragEnd: (details) {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  Offset localOffset = renderBox.globalToLocal(details.offset);
                  // Updating info

                  Offset virtualOffset =
                      coordinateSystem.screenToCoordinate(localOffset);
                  Offset safeArea = ability.data.abilityData!
                      .getAnchorPoint(mapScale, abilitySize);

                  if (coordinateSystem.isOutOfBounds(
                      virtualOffset.translate(safeArea.dx, safeArea.dy))) {
                    ref
                        .read(abilityProvider.notifier)
                        .removeAbility(ability.id);
                    return;
                  }

                  log(renderBox.size.toString());

                  ref.read(abilityProvider.notifier).updatePosition(
                      coordinateSystem.screenToCoordinate(localOffset),
                      ability.id);
                },
              ),
            for (PlacedAgent agent in ref.watch(agentProvider))
              Positioned(
                left: coordinateSystem.coordinateToScreen(agent.position).dx,
                top: coordinateSystem.coordinateToScreen(agent.position).dy,
                child: AgentWidget(
                  isAlly: agent.isAlly,
                  id: "",
                  agent: AgentData.agents[agent.type]!,
                ),
              ),
            for (PlacedText placedText in ref.watch(textProvider))
              Positioned(
                left:
                    coordinateSystem.coordinateToScreen(placedText.position).dx,
                top:
                    coordinateSystem.coordinateToScreen(placedText.position).dy,
                child: PlacedTextBuilder(
                  size: placedText.size,
                  placedText: placedText,
                  onDragEnd: (details) {
                    RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    Offset localOffset =
                        renderBox.globalToLocal(details.offset);

                    //Basically makes sure that if more than half is of the screen it gets deleted
                    Offset virtualOffset =
                        coordinateSystem.screenToCoordinate(localOffset);
                    double safeArea = agentSize / 2;

                    if (coordinateSystem.isOutOfBounds(
                        virtualOffset.translate(safeArea, safeArea))) {
                      ref.read(textProvider.notifier).removeText(placedText.id);

                      return;
                    }

                    ref
                        .read(textProvider.notifier)
                        .updatePosition(virtualOffset, placedText.id);
                  },
                ),
              ),
            for (PlacedImage placedImage
                in ref.watch(placedImageProvider).images)
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
                    onDragEnd: (details) {
                      RenderBox renderBox =
                          context.findRenderObject() as RenderBox;
                      Offset localOffset =
                          renderBox.globalToLocal(details.offset);

                      //Basically makes sure that if more than half is of the screen it gets deleted
                      Offset virtualOffset =
                          coordinateSystem.screenToCoordinate(localOffset);
                      double safeArea = agentSize / 2;

                      if (coordinateSystem.isOutOfBounds(
                          virtualOffset.translate(safeArea, safeArea))) {
                        ref
                            .read(placedImageProvider.notifier)
                            .removeImage(placedImage.id);

                        return;
                      }

                      ref
                          .read(placedImageProvider.notifier)
                          .updatePosition(virtualOffset, placedImage.id);
                    },
                  )),
            for (PlacedUtility placedUtility in ref.watch(utilityProvider))
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
                  onDragEnd: (details) {
                    RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    Offset localOffset =
                        renderBox.globalToLocal(details.offset);

                    //Basically makes sure that if more than half is of the screen it gets deleted
                    Offset virtualOffset =
                        coordinateSystem.screenToCoordinate(localOffset);
                    double safeArea = agentSize / 2;

                    if (coordinateSystem.isOutOfBounds(
                        virtualOffset.translate(safeArea, safeArea))) {
                      ref
                          .read(utilityProvider.notifier)
                          .removeUtility(placedUtility.id);

                      return;
                    }

                    ref
                        .read(utilityProvider.notifier)
                        .updatePosition(virtualOffset, placedUtility.id);
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
