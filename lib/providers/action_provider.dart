import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/agent_provider.dart';

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
  }

  void redoAction() {
    log(poppedItems.length.toString());
    if (poppedItems.isEmpty) {
      log("Popped list is empty");
      return;
    }

    final poppedAction = poppedItems.last;
    log(poppedItems.length.toString());
    switch (poppedAction.group) {
      case ActionGroup.agent:
        ref.read(agentProvider.notifier).redoAction(poppedAction);
      case ActionGroup.ability:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ActionGroup.drawing:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    final newState = [...state];
    newState.add(poppedItems.removeLast());
    state = newState;
  }

  void undoAction() {
    if (state.isEmpty) return;

    final currentAction = state.last;

    switch (currentAction.group) {
      case ActionGroup.agent:
        ref.read(agentProvider.notifier).undoAction(currentAction);
      case ActionGroup.ability:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ActionGroup.drawing:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
    log("Undo action was called");
    final newState = [...state];
    poppedItems.add(newState.removeLast());

    state = newState;
  }
}
