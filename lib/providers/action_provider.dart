import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/ability_provider.dart';
import 'package:icarus/providers/agent_provider.dart';
import 'package:icarus/providers/drawing_provider.dart';

enum ActionGroup {
  agent,
  ability,
  drawing,
}

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
    }

    final newState = [...state];
    newState.add(poppedItems.removeLast());
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
    }
    // log("Undo action was called");
    final newState = [...state];
    poppedItems.add(newState.removeLast());

    state = newState;
    // log("\n Current state \n ${state.toString()}");

    // log("\n Popped State \n ${poppedItems.toString()}");
  }
}
