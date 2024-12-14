import 'package:flutter/material.dart';
import 'package:icarus/providers/drawing_provider.dart';
import 'package:provider/provider.dart';

class BottomActionbar extends StatefulWidget {
  const BottomActionbar({super.key});

  @override
  State<BottomActionbar> createState() => _BottomActionbarState();
}

class _BottomActionbarState extends State<BottomActionbar> {
  @override
  Widget build(BuildContext context) {
    DrawingProvider drawingProvider = context.watch<DrawingProvider>();
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 55,
        width: 300,
        margin: const EdgeInsets.only(
          bottom: 16,
        ), // Add some margin from bottom
        child: Card(
          color: const Color(0xFF242126),
          elevation: 8, // Add some elevation for floating effect
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  switch (drawingProvider.interactionState) {
                    case InteractionState.drawFreeLine:
                      drawingProvider
                          .updateInteractionState(InteractionState.navigation);
                    default:
                      drawingProvider.updateInteractionState(
                          InteractionState.drawFreeLine);
                  }
                },
                icon: const Icon(Icons.draw),
                isSelected: drawingProvider.interactionState ==
                    InteractionState.drawFreeLine,
              ),
              IconButton(
                  onPressed: () {
                    drawingProvider.clearAll();
                  },
                  icon: const Icon(Icons.delete))
            ],
          ),
        ),
      ),
    );
  }
}
