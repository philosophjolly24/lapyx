import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/agents.dart';
import 'package:icarus/providers/agent_filter_provider.dart';

class AgentFilter extends ConsumerWidget {
  AgentFilter({super.key});

  final List<AgentRole> agentRoles = [
    AgentRole.duelist,
    AgentRole.controller,
    AgentRole.initiator,
    AgentRole.sentinel,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomSlidingSegmentedControl<FilterState>(
      height: 32,
      initialValue: FilterState.all,
      decoration: BoxDecoration(
        color: const Color(0xFF313131),
        border: Border.all(color: const Color(0xFF1A161A)),
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF1A161A),
            blurRadius: 4.0,
            spreadRadius: -1.0,
            offset: Offset(0, 2),
          ),
        ],
      ),

      thumbDecoration: BoxDecoration(
        color: const Color(0xFF673AB7),
        borderRadius: BorderRadius.circular(42),
      ),

      children: const {
        FilterState.all: FilterText(
          text: "All",
          filterState: FilterState.all,
        ),
        FilterState.onMap: FilterText(
          text: "On Map",
          filterState: FilterState.onMap,
        ),
        FilterState.role: FilterText(
          text: "Role",
          filterState: FilterState.role,
        ),
      },
      innerPadding: const EdgeInsets.all(4),
      // groupValue: ref.watch(agentFilterProvider).currentFilter,
      onValueChanged: (value) {
        ref.read(agentFilterProvider.notifier).updateFilterState(value);
      },
    );
  }
}

class FilterText extends ConsumerWidget {
  final String text;
  final FilterState filterState;

  const FilterText({
    super.key,
    required this.text,
    required this.filterState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected =
        ref.watch(agentFilterProvider).currentFilter == filterState;

    return Text(
      text,
      style: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
