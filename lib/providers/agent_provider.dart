import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/agents.dart';

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
}
