import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../const/placed_classes.dart';

final agentProvider =
    NotifierProvider<AgentProvider, List<PlacedAgent>>(AgentProvider.new);

class AgentProvider extends Notifier<List<PlacedAgent>> {
  @override
  List<PlacedAgent> build() {
    return [];
  }

  void addAgent(PlacedAgent placedAgent) {
    state = [...state, placedAgent];
  }

  void bringFoward(String id) {
    final newState = [...state];

    final index = PlacedWidget.getIndexByID(id, newState);

    if (index < 0) return;

    final temp = newState.removeAt(index);

    state = [...newState, temp];
  }

  void removeAgent(String id) {
    final newState = [...state];

    final index = PlacedWidget.getIndexByID(id, newState);

    if (index < 0) return;
    newState.removeAt(index);

    state = newState;
  }

  // void removeAgentWithID(String id) {
  //   final newState = [...state];

  //   final index = newState.indexWhere(
  //     (element) => element.id == id,
  //   );
  //   if (index < 0) return;
  //   newState.removeAt(index);

  //   state = newState;
  // }

  String toJson() {
    final List<Map<String, dynamic>> jsonList =
        state.map((agent) => agent.toJson()).toList();
    return jsonEncode(jsonList);
  }

  void fromJson(String jsonString) {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    state = jsonList
        .map((json) => PlacedAgent.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  String toString() {
    String output = "[";

    for (PlacedAgent agent in state) {
      output += "Name: ${agent.type}, Position: ${agent.position}, ";
    }

    output += "]";

    return output;
  }
}
