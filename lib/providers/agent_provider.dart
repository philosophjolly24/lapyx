import 'package:flutter/material.dart';
import 'package:icarus/agents.dart';

class AgentProvider extends ChangeNotifier {
  List<PlacedAgent> placedAgents = [
    PlacedAgent(
        data: AgentData.agents[AgentType.breach]!, position: Offset(500, 500))
  ];

  void addAgent(PlacedAgent placedAgent) {
    placedAgents.add(placedAgent);
    notifyListeners();
  }
}
