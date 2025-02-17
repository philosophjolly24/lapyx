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

  void bringFoward(int index) {
    final newState = [...state];

    final temp = newState.removeAt(index);

    state = [...newState, temp];
  }

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
}
