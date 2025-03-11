import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/const/placed_classes.dart';

class DeleteArea extends ConsumerWidget {
  const DeleteArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 70,
        width: 70,
        child: DragTarget<DraggableData>(
          builder: (context, candidateData, rejectedData) {
            return Container(
              color: const Color(0xFFFFD7D7),
              child: const Icon(
                Icons.delete_outline,
                color: Color(0xFFFF0000),
              ),
            );
          },
          onAcceptWithDetails: (dragData) {
            final placedData = dragData.data;

            if (placedData is PlacedAgent) {
              log("I am agent");
            } else if (placedData is PlacedAbility) {
              log("I am ability");
            } else if (placedData is PlacedText) {
              log("I am text");
            }

            log("I worked");
          },
        ),
      ),
    );
  }
}
