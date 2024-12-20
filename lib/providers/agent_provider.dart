import 'package:flutter/material.dart';
import 'package:icarus/agents.dart';

class AgentProvider extends ChangeNotifier {
  AgentData? activeAgent;

  List<PlacedAgent> placedAgents = [
    PlacedAgent(
        data: AgentData.agents[AgentType.breach]!,
        position: const Offset(500, 500))
  ];

  void addAgent(PlacedAgent placedAgent) {
    placedAgents.add(placedAgent);
    notifyListeners();
  }

  void bringAgentFoward(int index) {
    PlacedAgent tempPlacedAgent = placedAgents[index];
    placedAgents.removeAt(index);
    placedAgents.add(tempPlacedAgent);
    notifyListeners();
  }

  void setActiveAgent(AgentData agentData) {
    activeAgent = agentData;
    notifyListeners();
  }
}
