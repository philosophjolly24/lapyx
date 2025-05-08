import 'dart:convert';
import 'dart:developer' show log;
import 'dart:ui' show Offset;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/placed_classes.dart';
import 'package:icarus/providers/action_provider.dart';

final abilityProvider =
    NotifierProvider<AbilityProvider, List<PlacedAbility>>(AbilityProvider.new);

class AbilitySnapshot {
  final String id;
  final List<PlacedAbility> snapshot;

  AbilitySnapshot({required this.id, required this.snapshot});
}

class AbilityProvider extends Notifier<List<PlacedAbility>> {
  List<PlacedAbility> poppedAbility = [];
  List<AbilitySnapshot> snapshots = [];
  @override
  List<PlacedAbility> build() {
    return [];
  }

  void addAbility(PlacedAbility placedAbility) {
    final action = UserAction(
        type: ActionType.addition,
        id: placedAbility.id,
        group: ActionGroup.ability);
    ref.read(actionProvider.notifier).addAction(action);

    state = [...state, placedAbility];
  }

  void updatePosition(Offset position, String id) {
    final newState = [...state];

    final index = PlacedWidget.getIndexByID(id, newState);

    if (index < 0) return;
    newState[index].updatePosition(position);

    final temp = newState.removeAt(index);

    final action =
        UserAction(type: ActionType.edit, id: id, group: ActionGroup.ability);
    ref.read(actionProvider.notifier).addAction(action);

    state = [...newState, temp];
  }

  void updateRotation(int index, double rotation) {
    final newState = [...state];

    newState[index].updateRotation(rotation);
    final action = UserAction(
        type: ActionType.edit,
        id: newState[index].id,
        group: ActionGroup.ability);
    ref.read(actionProvider.notifier).addAction(action);
    state = newState;
  }

  void updateRotationHistory(int index) {
    final newState = [...state];

    newState[index].updateRotationHistory();

    state = newState;
  }

  void undoAction(UserAction action) {
    log("I tried to remove a deleted item");

    switch (action.type) {
      case ActionType.addition:
        log("We are attmepting to remove");
        removeAbility(action.id);
      case ActionType.deletion:
        if (poppedAbility.isEmpty) {
          log("Popped agents is empty");
          return;
        }
        log("I tried to remove a deleted item");
        final newState = [...state];

        newState.add(poppedAbility.removeLast());
        state = newState;
      case ActionType.edit:
        final newState = [...state];

        final index = PlacedWidget.getIndexByID(action.id, newState);

        newState[index].undoAction();

        state = newState;
    }
  }

  void redoAction(UserAction action) {
    final newState = [...state];

    try {
      switch (action.type) {
        case ActionType.addition:
          final index = PlacedWidget.getIndexByID(action.id, poppedAbility);
          newState.add(poppedAbility.removeAt(index));

        case ActionType.deletion:
          final index = PlacedWidget.getIndexByID(action.id, poppedAbility);

          poppedAbility.add(newState.removeAt(index));
        case ActionType.edit:
          final index = PlacedWidget.getIndexByID(action.id, newState);
          newState[index].redoAction();
      }
    } catch (_) {
      log("failed to find index");
    }
    state = newState;
  }

  void removeAbility(String id) {
    final newState = [...state];

    final index = PlacedWidget.getIndexByID(id, newState);

    if (index < 0) return;
    final ability = newState.removeAt(index);
    poppedAbility.add(ability);

    state = newState;
  }

  void fromHive(List<PlacedAbility> hiveAbilities) {
    poppedAbility = [];
    state = hiveAbilities;
  }

  void clearAll() {
    poppedAbility = [];
    state = [];
  }

  String toJson() {
    final List<Map<String, dynamic>> jsonList =
        state.map((ability) => ability.toJson()).toList();
    return jsonEncode(jsonList);
  }

  List<PlacedAbility> fromJson(String jsonString) {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList
        .map((json) => PlacedAbility.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
