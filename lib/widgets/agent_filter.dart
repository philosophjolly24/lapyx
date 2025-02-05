import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/agent_filter_provider.dart';

class AgentFilter extends ConsumerWidget {
  AgentFilter({super.key});

  final List<Widget> _filterWidget = [
    const Text(
      "All",
    ),
    const Text("On Map"),
    const Text("Role"),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //   return ToggleButtons(
    //     isSelected: FilterState.values
    //         .map(
    //           (value) => value == ref.watch(agentFilterProvider).currentFilter,
    //         )
    //         .toList(),
    //     onPressed: (index) {
    //
    //     },
    //     borderRadius: const BorderRadius.all(Radius.circular(8)),
    //     renderBorder: true,
    //     children: _filterWidget,
    //   );
    // }

    return Row(
      children: [
        for (final (index, Widget child) in _filterWidget.indexed)
          IconButton(
            isSelected: false,
            onPressed: () {
              final filterState = FilterState.values[index];
              ref
                  .read(agentFilterProvider.notifier)
                  .updateFilterState(filterState);
            },
            icon: child,
          )
      ],
    );
  }
}
