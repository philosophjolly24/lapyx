import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/providers/drawing_provider.dart';

enum InteractionState {
  navigation,
  drag,
  drawing,
  erasing,
  deleting,
}

final interactionStateProvider =
    NotifierProvider<InteractionStateProvider, InteractionState>(
  InteractionStateProvider.new,
);

class InteractionStateProvider extends Notifier<InteractionState> {
  @override
  InteractionState build() {
    return InteractionState.navigation;
  }

  void update(InteractionState newState) {
    if (newState == state) return;

    if (state == InteractionState.drawing) {
      final coordinateSystem = CoordinateSystem.instance;
      log("Finishing free drawing");
      ref
          .read(drawingProvider.notifier)
          .finishFreeDrawing(null, coordinateSystem);
    }

    state = newState;
  }
}
