import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/ability_bar_provider.dart';
import 'package:icarus/providers/ability_provider.dart';
import 'package:icarus/providers/agent_provider.dart';
import 'package:icarus/providers/drawing_provider.dart';
import 'package:icarus/providers/image_provider.dart';
import 'package:icarus/providers/strategy_provider.dart';
import 'package:icarus/providers/text_provider.dart';

enum ActionGroup { agent, ability, drawing, text, image }

enum ActionType {
  addition,
  deletion,
  edit,
}

class UserAction {
  final ActionGroup group;
  final String id;
  final ActionType type;
  UserAction({required this.type, required this.id, required this.group});

  @override
  String toString() {
    return """
          Action Group: $group
          Item id: $id
          Action Type: $type
    """;
  }
}

final actionProvider =
    NotifierProvider<ActionProvider, List<UserAction>>(ActionProvider.new);

class ActionProvider extends Notifier<List<UserAction>> {
  List<UserAction> poppedItems = [];

  @override
  List<UserAction> build() {
    return [];
  }

  void addAction(UserAction action) {
    ref.read(strategyProvider.notifier).setFileStatus(false);
    if (action.group != ActionGroup.ability) {
      ref.read(abilityBarProvider.notifier).updateData(null);
    }
    state = [...state, action];

    // log("\n Current state \n ${state.toString()}");
  }

  void redoAction() {
    log(poppedItems.length.toString());
    if (poppedItems.isEmpty) {
      // log("Popped list is empty");
      return;
    }

    final poppedAction = poppedItems.last;
    log(poppedItems.length.toString());
    switch (poppedAction.group) {
      case ActionGroup.agent:
        ref.read(agentProvider.notifier).redoAction(poppedAction);
      case ActionGroup.ability:
        ref.read(abilityProvider.notifier).redoAction(poppedAction);
      case ActionGroup.drawing:
        ref.read(drawingProvider.notifier).redoAction(poppedAction);
      case ActionGroup.text:
        ref.read(textProvider.notifier).redoAction(poppedAction);
      case ActionGroup.image:
        ref.read(placedImageProvider.notifier).redoAction(poppedAction);
    }

    final newState = [...state];
    newState.add(poppedItems.removeLast());

    ref.read(strategyProvider.notifier).setFileStatus(false);

    state = newState;
    // log("\n Current state \n ${state.toString()}");
  }

  void undoAction() {
    // log("Undo action was triggered");

    if (state.isEmpty) return;

    final currentAction = state.last;

    switch (currentAction.group) {
      case ActionGroup.agent:
        ref.read(agentProvider.notifier).undoAction(currentAction);
      case ActionGroup.ability:
        ref.read(abilityProvider.notifier).undoAction(currentAction);
      case ActionGroup.drawing:
        ref.read(drawingProvider.notifier).undoAction(currentAction);
      case ActionGroup.text:
        ref.read(textProvider.notifier).undoAction(currentAction);
      case ActionGroup.image:
        ref.read(placedImageProvider.notifier).undoAction(currentAction);
    }
    // log("Undo action was called");
    final newState = [...state];
    poppedItems.add(newState.removeLast());

    ref.read(strategyProvider.notifier).setFileStatus(false);

    state = newState;
    // log("\n Current state \n ${state.toString()}");

    // log("\n Popped State \n ${poppedItems.toString()}");
  }
}
