import 'package:flutter_riverpod/flutter_riverpod.dart';

enum InteractionState {
  navigation,
  drag,
  drawing,
  erasing,
}

final interactionStateProvider =
    NotifierProvider<InteractionStateProvider, InteractionState>(
  InteractionStateProvider.new,
);

class InteractionStateProvider extends Notifier<InteractionState> {
  @override
  InteractionState build() {
    return InteractionState.navigation;
  }

  void update(InteractionState newState) {
    if (newState == state) return;
    state = newState;
  }
}
