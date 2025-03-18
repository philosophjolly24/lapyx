import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class ActionProvider extends Notifier<List<UserAction>> {
  List<UserAction> poppedItems = [];

  @override
  List<UserAction> build() {
    return [];
  }

  void addAction(UserAction action) {
    state = [...state, action];
  }

  void undoAction(WidgetRef ref) {
    if (state.isEmpty) return;

    final currentAction = state.last;

    switch (currentAction.group) {
      case ActionGroup.agent:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ActionGroup.ability:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ActionGroup.drawing:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
