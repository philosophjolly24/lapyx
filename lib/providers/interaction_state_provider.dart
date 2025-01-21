import 'package:flutter_riverpod/flutter_riverpod.dart';

enum InteractionState {
  navigation,
  drag,
  drawLine,
  drawFreeLine,
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

  void update(InteractionState state) {
    this.state = state;
  }
}
