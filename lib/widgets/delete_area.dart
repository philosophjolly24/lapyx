import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/placed_classes.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/providers/ability_provider.dart';
import 'package:icarus/providers/agent_provider.dart';
import 'package:icarus/providers/text_provider.dart';

class DeleteArea extends ConsumerWidget {
  const DeleteArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 70,
        width: 70,
        child: DragTarget(
          builder: (context, candidateData, rejectedData) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              color:
                  candidateData.isNotEmpty ? Colors.red : Settings.sideBarColor,
              child: const Icon(
                Icons.delete_outline,
                color: Color.fromARGB(255, 245, 245, 245),
              ),
            );
          },
          onAcceptWithDetails: (dragData) {
            final placedData = dragData.data;

            if (placedData is PlacedAgent) {
              ref.read(agentProvider.notifier).removeAgent(placedData.id);
            } else if (placedData is PlacedAbility) {
              ref.read(abilityProvider.notifier).removeAbility(placedData.id);
            } else if (placedData is PlacedText) {
              ref.read(textProvider.notifier).removeText(placedData.id);
            }
            log("I worked");
          },
        ),
      ),
    );
  }
}
