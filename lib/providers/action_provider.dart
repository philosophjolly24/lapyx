import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ActionType {
  agent,
  ability,
  drawing,
}

class ActionProvider extends Notifier<List<ActionType>> {
  @override
  List<ActionType> build() {
    return [];
  }

  void addAction(ActionType action) {
    state = [action, ...state];
  }
}
