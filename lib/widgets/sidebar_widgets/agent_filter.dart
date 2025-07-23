import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/providers/agent_filter_provider.dart';

class AgentFilter extends ConsumerWidget {
  AgentFilter({super.key});

  final List<String> _filterText = [
    "All",
    "On Map",
    "Role",
  ];

  final List<AgentRole> agentRoles = [
    AgentRole.duelist,
    AgentRole.controller,
    AgentRole.initiator,
    AgentRole.sentinel,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        for (final (index, String text) in _filterText.indexed)
          TextButton(
            onPressed: () {
              final filterState = FilterState.values[index];
              ref
                  .read(agentFilterProvider.notifier)
                  .updateFilterState(filterState);
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0), // Reduced from default
            ),
            child: Text(
              text,
              style: TextStyle(
                color: (ref.watch(agentFilterProvider).currentFilter ==
                        FilterState.values[index])
                    ? Colors.deepPurpleAccent
                    : Colors.grey,
              ),
            ),
          )
      ],
    );
  }
}
