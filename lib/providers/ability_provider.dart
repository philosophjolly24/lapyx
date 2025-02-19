import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/placed_classes.dart';

final abilityProvider =
    NotifierProvider<AbilityProvider, List<PlacedAbility>>(AbilityProvider.new);

class AbilityProvider extends Notifier<List<PlacedAbility>> {
  @override
  List<PlacedAbility> build() {
    return [];
  }

  void addAbility(PlacedAbility placedAbility) {
    state = [...state, placedAbility];
  }

  void bringFoward(int index) {
    final newState = [...state];

    final temp = newState.removeAt(index);

    state = [...newState, temp];
  }

  void updateRotation(int index, double rotation) {
    final newState = [...state];
    newState[index].rotation = rotation;
    state = newState;
  }

  void removeAbility(int index) {
    final newState = [...state];
    newState.removeAt(index);
    state = newState;
  }

  String toJson() {
    final List<Map<String, dynamic>> jsonList =
        state.map((ability) => ability.toJson()).toList();
    return jsonEncode(jsonList);
  }

  void fromJson(String jsonString) {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    state = jsonList
        .map((json) => PlacedAbility.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
