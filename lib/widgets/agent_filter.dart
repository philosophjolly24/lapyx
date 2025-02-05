import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/agent_filter_provider.dart';

class AgentFilter extends ConsumerWidget {
  AgentFilter({super.key});

  final List<String> _filterText = [
    "All",
    "On Map",
    "Role",
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          for (final (index, String text) in _filterText.indexed)
            TextButton(
              onPressed: () {
                final filterState = FilterState.values[index];
                ref
                    .read(agentFilterProvider.notifier)
                    .updateFilterState(filterState);
              },
              // style: ButtonStyle(

              // ),
              child: Text(
                text,
                style: TextStyle(
                  color: (ref.watch(agentFilterProvider).currentFilter ==
                          FilterState.values[index])
                      ? Colors.blue
                      : Colors.grey,
                ),
              ),
            )
        ],
      ),
    );
  }
}
