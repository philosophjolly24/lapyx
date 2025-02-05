import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/agents.dart';

enum FilterState { all, onMap, role }

final agentFilterProvider =
    NotifierProvider<AgentFilterProvider, AgentFilterState>(
        AgentFilterProvider.new);

class AgentFilterProvider extends Notifier<AgentFilterState> {
  @override
  AgentFilterState build() {
    return AgentFilterState(currentFilter: FilterState.all, roleFilter: []);
  }

  void updateFilterState(FilterState filterState) {
    state = state.copyWith(currentFilter: filterState);
  }
}

class AgentFilterState {
  final FilterState currentFilter;
  final List<AgentRole> roleFilter;

  AgentFilterState({
    required this.currentFilter,
    required this.roleFilter,
  });

  AgentFilterState copyWith({
    FilterState? currentFilter,
    List<AgentRole>? roleFilter,
  }) {
    return AgentFilterState(
      currentFilter: currentFilter ?? this.currentFilter,
      roleFilter: roleFilter ?? this.roleFilter,
    );
  }
}
