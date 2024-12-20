import 'package:flutter/material.dart';
import 'package:icarus/agents.dart';

class AbilityProvider extends ChangeNotifier {
  List<PlacedAbility> placedAbilities = [];

  void addAbility(PlacedAbility placedAbility) {
    placedAbilities.add(placedAbility);
    notifyListeners();
  }

  void bringAbilityFoward(int index) {
    PlacedAbility tempPlacedAgent = placedAbilities[index];
    placedAbilities.removeAt(index);
    placedAbilities.add(tempPlacedAgent);
    notifyListeners();
  }
}
