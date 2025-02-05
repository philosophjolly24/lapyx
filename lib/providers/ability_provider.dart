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
    newState[index].rotaion = rotation;
    state = newState;
  }
}
